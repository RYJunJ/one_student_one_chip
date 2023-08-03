#include <proc.h>
#include <elf.h>
#include <fs.h>

#ifdef __LP64__
# define Elf_Ehdr Elf64_Ehdr
# define Elf_Phdr Elf64_Phdr
#else
# define Elf_Ehdr Elf32_Ehdr
# define Elf_Phdr Elf32_Phdr
#endif

int fs_open(const char *, int, int);
size_t fs_read(int, void *, size_t);
size_t fs_lseek(int, size_t, int);
size_t ramdisk_read(void *, size_t, size_t);

static uintptr_t loader(PCB *pcb, const char *filename) {
  int fd = fs_open(filename, 0, 0);
  Elf_Ehdr elf_hdr;
  Elf_Phdr elf_pdr;
  fs_read(fd, &elf_hdr, sizeof(Elf_Ehdr));
  //ramdisk_read(&elf_hdr, 0, sizeof(Elf_Ehdr));
  //printf("e_ident == %x\n", *(uint32_t *)elf_hdr.e_ident);
  assert(*(uint32_t *)elf_hdr.e_ident == 0x464c457f);
  assert(elf_hdr.e_phnum != PN_XNUM);
  assert(elf_hdr.e_phoff);
  for(int i = 0 ; i < elf_hdr.e_phnum ; i++) {
    fs_lseek(fd, elf_hdr.e_phoff + (i * elf_hdr.e_phentsize), SEEK_SET);
    fs_read(fd, &elf_pdr, elf_hdr.e_phentsize);
    //ramdisk_read(&elf_pdr, elf_hdr.e_phoff + (i * elf_hdr.e_phentsize), elf_hdr.e_phentsize);
    if(elf_pdr.p_type == PT_LOAD) {
      //printf("virtual addr == %x\n", elf_pdr.p_vaddr);
      fs_lseek(fd, elf_pdr.p_offset, SEEK_SET);
      fs_read(fd, (void *)(elf_pdr.p_vaddr), elf_pdr.p_filesz);
      //ramdisk_read((void *)(elf_pdr.p_vaddr), elf_pdr.p_offset, elf_pdr.p_filesz);
      int tmp_zero = 0;
      for(int j = elf_pdr.p_filesz ; j < elf_pdr.p_memsz ; j++)
        memcpy((void *)(elf_pdr.p_vaddr + j), &tmp_zero, 1);
    }
  }
  return elf_hdr.e_entry;
}

void naive_uload(PCB *pcb, const char *filename) {
  uintptr_t entry = loader(pcb, filename);
  Log("Jump to entry = %p", entry);
  ((void(*)())entry) ();
}

