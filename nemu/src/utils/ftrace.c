#ifdef CONFIG_TARGET_AM
#include <common.h>
#include <elf.h>
#include <stdio.h>

int ftrace_ident = 0, sym_idx = 0;
char *func_name;
FILE *fp_elf = NULL;
FILE *fp_ftrace_log = NULL;
Elf64_Sym *sym_table;

void check_call(vaddr_t addr) {
    for(int i = 0; i < sym_idx; i++) {
        if(sym_table[i].st_value == addr) {
            for(int j = 0; j < ftrace_ident; j++)
                fprintf(fp_ftrace_log, "  ");
            fprintf(fp_ftrace_log, "call [%s@0x%lx]\n", &func_name[sym_table[i].st_name], addr);
            ftrace_ident++;
            break;
        }
    }
    return;
}

void check_ret(vaddr_t addr) {
    int mark_suc_ret = 0;
    for(int i = 0; i < sym_idx; i++) {
        if(sym_table[i].st_value <= addr && addr < sym_table[i].st_value + sym_table[i].st_size) {
            ftrace_ident--;
            for(int j = 0; j < ftrace_ident; j++) 
                fprintf(fp_ftrace_log, "  ");
            fprintf(fp_ftrace_log, "Ret from [%s]\n", &func_name[sym_table[i].st_name]);
            mark_suc_ret = 1;
            break;
        }
    }
    if(!mark_suc_ret)
        fprintf(fp_ftrace_log, "Error Ret\n");
    return;
}

static int check_shstr(Elf64_Shdr test_head) {
    int cur_indicator = ftell(fp_elf);
    fseek(fp_elf, test_head.sh_offset, SEEK_SET);
    char *test_name = (char *)malloc(test_head.sh_size);
    int ret_fread = fread(test_name, sizeof(char), test_head.sh_size, fp_elf);
    assert(ret_fread);
    fseek(fp_elf, cur_indicator, SEEK_SET);
    if(test_name[1] == '.')
	    return 1;
    return 0;
}

void init_ftrace(char *file_name) {
    int ret_fread;
    ftrace_ident = 0;
    Elf64_Ehdr elf_head;
    Elf64_Shdr sym_head, str_tab, shstr, tmp_sec;
    fp_elf = fopen(file_name, "rb");
    fp_ftrace_log = fopen("/home/yjunj/Desktop/ftrace.log", "w");

    //start from ELF Head
    ret_fread = fread(&elf_head, sizeof(Elf64_Ehdr), 1, fp_elf);
    
    //jump to Section Head from ELF Head
    fseek(fp_elf, elf_head.e_shoff, SEEK_SET);
    
    //find shstrtab in Section Table
    for(int i = 0; i < elf_head.e_shnum; i++) {
        ret_fread = fread(&tmp_sec, sizeof(Elf64_Shdr), 1, fp_elf);
        if(tmp_sec.sh_type == SHT_SYMTAB)
            sym_head = tmp_sec;
        if(tmp_sec.sh_type == SHT_STRTAB) {
            if(check_shstr(tmp_sec))
            shstr = tmp_sec;
        }
    }

    //store shstrtab string
    char *sec_name = (char *)malloc(shstr.sh_size);
    fseek(fp_elf, shstr.sh_offset, SEEK_SET);
    ret_fread = fread(sec_name, sizeof(char), shstr.sh_size, fp_elf);
    
    //find strtab in Section Table
    fseek(fp_elf, elf_head.e_shoff, SEEK_SET);
    for(int i = 0; i < elf_head.e_shnum; i++) {
        ret_fread = fread(&tmp_sec, sizeof(Elf64_Ehdr), 1, fp_elf);
        if(tmp_sec.sh_type == SHT_STRTAB && (!strcmp(".strtab", &sec_name[tmp_sec.sh_name])))
            str_tab = tmp_sec;
    }
    
    //goto strtab
    func_name = (char *)malloc(str_tab.sh_size);
    fseek(fp_elf, str_tab.sh_offset, SEEK_SET);

    //store strtab
    ret_fread = fread(func_name, sizeof(char), str_tab.sh_size, fp_elf);

    //go to Symble Table
    fseek(fp_elf, sym_head.sh_offset, SEEK_SET);

    //store Symble Table and Parse STT_FUNC
    sym_idx = 0;
    int symSize = sym_head.sh_size / sym_head.sh_entsize;
    Elf64_Sym tmp_sym;
    sym_table = (Elf64_Sym *)malloc(sizeof(Elf64_Sym) * symSize);
    for(int i = 0; i < symSize; i++) {
        ret_fread = fread(&tmp_sym, sizeof(Elf64_Sym), 1, fp_elf);
        if(ELF64_ST_TYPE(tmp_sym.st_info) == STT_FUNC) {
            sym_table[sym_idx] = tmp_sym;
            sym_idx++;
        }
    }
    
    fclose(fp_elf);
    assert(ret_fread);
    return;
}
#endif