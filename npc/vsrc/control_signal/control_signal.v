module control_signal (
    input   wire[31:0] inst,
    input  rd1_eq_rd2,
    input  rd1_lts_rd2,
    input  rd1_ltu_rd2,
    input  rd1_gts_rd2,
    input  rd1_gtu_rd2,
 
    output inst_div,    
    output inst_divu,   
    output inst_divw,   
    output inst_divuw,  
    output inst_rem,    
    output inst_remu, 
    output inst_remw,  
    output inst_remuw,   
    output inst_lui,    
    output inst_jal,    
    output inst_ld, 
    output inst_lw, 
    output inst_lh, 
    output inst_lb, 
    output inst_lwu,    
    output inst_lhu,    
    output inst_lbu,    
    output inst_jalr,   
    output inst_ebreak, 
    output inst_inv,    
    
    output wire[2:0] sel_mux_pc,
    output ram_re,
    output ram_we,
    output wire[3:0] sel_mux_ram_wdata,
    output wire[4:0] sel_mux_ram_imm,
    output wire[6:0] sel_mux_ram_rdata,
    output wire[1:0] sel_mux_reg_wdata_sign,
    output reg_re,
    output reg_we,
    output wire[2:0]  sel_mux_alu_src1,
    output wire[5:0]  sel_mux_alu_src2,
    output wire[14:0] alu_control

);

    import "DPI-C" function void end_sim();
    
    always @ (*) begin
        if(inst_ebreak) end_sim();
    end

    wire[6:0]   op_1;
    wire[127:0] op_1_d;
    wire[2:0]   op_2;
    wire[7:0]   op_2_d;
    wire[6:0]   func;
    wire[127:0] func_d;

    wire        inst_add; 
    wire        inst_addw;
    wire        inst_sub;
    wire        inst_subw;
    wire        inst_mul;
    wire        inst_mulw;
    wire        inst_slt;
    wire        inst_sltu;
    wire        inst_sll;
    wire        inst_sllw; 
    wire        inst_srl;
    wire        inst_srlw; 
    wire        inst_sraw;
    wire        inst_and;
    wire        inst_or; 
    wire        inst_xor;  
    wire        inst_auipc;
    wire        inst_addi;
    wire        inst_addiw;
    wire        inst_andi;
    wire        inst_ori;
    wire        inst_xori; 
    wire        inst_slti;
    wire        inst_sltiu;
    wire        inst_slli;
    wire        inst_slliw;
    wire        inst_srli;
    wire        inst_srliw;
    wire        inst_srai;
    wire        inst_sraiw;
    wire        inst_sd;
    wire        inst_sw;  
    wire        inst_sh;  
    wire        inst_sb;  
    wire        inst_bne;  
    wire        inst_beq; 
    wire        inst_blt; 
    wire        inst_bltu; 
    wire        inst_bge;
    wire        inst_bgeu; 
    wire        inst_ecall;
    wire        inst_mret;
    wire        inst_csrrw;
    wire        inst_csrrs;

    assign op_1 = inst[31:25];
    assign op_2 = inst[14:12];
    assign func = inst[6:0];

    decoder #(.A_WIDTH (7), .B_WIDTH(128)) u_dec1(.in(op_1), .out(op_1_d));
    decoder #(.A_WIDTH (3), .B_WIDTH(8))   u_dec2(.in(op_2), .out(op_2_d));
    decoder #(.A_WIDTH (7), .B_WIDTH(128)) u_dec3(.in(func), .out(func_d));

    assign inst_add    = op_1_d[7'b0000000] & op_2_d[3'b000] & func_d[7'b0110011];
    assign inst_addw   = op_1_d[7'b0000000] & op_2_d[3'b000] & func_d[7'b0111011];
    assign inst_sub    = op_1_d[7'b0100000] & op_2_d[3'b000] & func_d[7'b0110011];
    assign inst_subw   = op_1_d[7'b0100000] & op_2_d[3'b000] & func_d[7'b0111011];
    assign inst_mul    = op_1_d[7'b0000001] & op_2_d[3'b000] & func_d[7'b0110011];
    assign inst_mulw   = op_1_d[7'b0000001] & op_2_d[3'b000] & func_d[7'b0111011];
    assign inst_div    = op_1_d[7'b0000001] & op_2_d[3'b100] & func_d[7'b0110011];
    assign inst_divu   = op_1_d[7'b0000001] & op_2_d[3'b101] & func_d[7'b0110011];
    assign inst_divw   = op_1_d[7'b0000001] & op_2_d[3'b100] & func_d[7'b0111011];
    assign inst_divuw  = op_1_d[7'b0000001] & op_2_d[3'b101] & func_d[7'b0111011];
    assign inst_rem    = op_1_d[7'b0000001] & op_2_d[3'b110] & func_d[7'b0110011];
    assign inst_remu   = op_1_d[7'b0000001] & op_2_d[3'b111] & func_d[7'b0110011];
    assign inst_remw   = op_2_d[3'b110]     & func_d[7'b0111011];
    assign inst_remuw  = op_1_d[7'b0000001] & op_2_d[3'b111] & func_d[7'b0111011];
    assign inst_slt    = op_1_d[7'b0000000] & op_2_d[3'b010] & func_d[7'b0110011];
    assign inst_sltu   = op_1_d[7'b0000000] & op_2_d[3'b011] & func_d[7'b0110011];
    assign inst_sll    = op_1_d[7'b0000000] & op_2_d[3'b001] & func_d[7'b0110011];
    assign inst_sllw   = op_1_d[7'b0000000] & op_2_d[3'b001] & func_d[7'b0111011];
    assign inst_srl    = op_1_d[7'b0000000] & op_2_d[3'b101] & func_d[7'b0110011];
    assign inst_srlw   = op_1_d[7'b0000000] & op_2_d[3'b101] & func_d[7'b0111011];
    assign inst_sraw   = op_1_d[7'b0100000] & op_2_d[3'b101] & func_d[7'b0111011];
    assign inst_and    = op_1_d[7'b0000000] & op_2_d[3'b111] & func_d[7'b0110011];
    assign inst_or     = op_1_d[7'b0000000] & op_2_d[3'b110] & func_d[7'b0110011];
    assign inst_xor    = op_1_d[7'b0000000] & op_2_d[3'b100] & func_d[7'b0110011];
    assign inst_auipc  = func_d[7'b0010111];
    assign inst_lui    = func_d[7'b0110111];
    assign inst_jal    = func_d[7'b1101111];
    assign inst_ld     = op_2_d[3'b011] & func_d[7'b0000011];
    assign inst_lw     = op_2_d[3'b010] & func_d[7'b0000011];
    assign inst_lh     = op_2_d[3'b001] & func_d[7'b0000011];
    assign inst_lb     = op_2_d[3'b000] & func_d[7'b0000011];
    assign inst_lwu    = op_2_d[3'b110] & func_d[7'b0000011];
    assign inst_lhu    = op_2_d[3'b101] & func_d[7'b0000011];
    assign inst_lbu    = op_2_d[3'b100] & func_d[7'b0000011];
    assign inst_addi   = op_2_d[3'b000] & func_d[7'b0010011];
    assign inst_addiw  = op_2_d[3'b000] & func_d[7'b0011011];
    assign inst_andi   = op_2_d[3'b111] & func_d[7'b0010011];
    assign inst_ori    = op_2_d[3'b110] & func_d[7'b0010011];
    assign inst_xori   = op_2_d[3'b100] & func_d[7'b0010011];
    assign inst_jalr   = op_2_d[3'b000] & func_d[7'b1100111];
    assign inst_slti   = op_2_d[3'b010] & func_d[7'b0010011];
    assign inst_sltiu  = op_2_d[3'b011] & func_d[7'b0010011];
    assign inst_slli   = (inst[31:26] == 6'b000000) & op_2_d[3'b001] & func_d[7'b0010011];
    assign inst_slliw  = op_1_d[7'b0000000] & op_2_d[3'b001] & func_d[7'b0011011];
    assign inst_srli   = (inst[31:26] == 6'b000000) & op_2_d[3'b101] & func_d[7'b0010011];
    assign inst_srliw  = op_1_d[7'b0000000] & op_2_d[3'b101] & func_d[7'b0011011];
    assign inst_srai   = (inst[31:26] == 6'b010000) & op_2_d[3'b101] & func_d[7'b0010011];
    assign inst_sraiw  = op_1_d[7'b0100000] & op_2_d[3'b101] & func_d[7'b0011011];
    assign inst_sd     = op_2_d[3'b011] & func_d[7'b0100011];
    assign inst_sw     = op_2_d[3'b010] & func_d[7'b0100011];
    assign inst_sh     = op_2_d[3'b001] & func_d[7'b0100011];
    assign inst_sb     = op_2_d[3'b000] & func_d[7'b0100011];
    assign inst_bne    = op_2_d[3'b001] & func_d[7'b1100011];
    assign inst_beq    = op_2_d[3'b000] & func_d[7'b1100011];
    assign inst_blt    = op_2_d[3'b100] & func_d[7'b1100011];
    assign inst_bltu   = op_2_d[3'b110] & func_d[7'b1100011];
    assign inst_bge    = op_2_d[3'b101] & func_d[7'b1100011];
    assign inst_bgeu   = op_2_d[3'b111] & func_d[7'b1100011];
    assign inst_ebreak = (inst == 32'b00000000000100000000000001110011);
    assign inst_ecall  = (inst == 32'b00000000000000000000000001110011);
    assign inst_mret   = (inst == 32'b00110000001000000000000001110011);
    assign inst_csrrw  = op_2_d[3'b001] & func_d[7'b1110011];
    assign inst_csrrs  = op_2_d[3'b010] & func_d[7'b1110011];
    assign inst_inv    = 1'b1;



    assign sel_mux_pc[0]     = inst_jalr;
    assign sel_mux_pc[1]     = inst_jal | (inst_bne & (~rd1_eq_rd2)) | (inst_beq & rd1_eq_rd2) | (inst_blt & rd1_lts_rd2) | (inst_bltu & rd1_ltu_rd2) | (inst_bge & (rd1_eq_rd2 | rd1_gts_rd2)) | (inst_bgeu & (rd1_eq_rd2 | rd1_gtu_rd2));
    assign sel_mux_pc[2]     = inst_add | inst_addw | inst_sub | inst_subw | inst_mul | inst_mulw | inst_div | inst_divu | inst_divw | inst_divuw | inst_rem | inst_remu | inst_remw | inst_remuw | inst_slt | inst_sltu | inst_sll | inst_sllw | inst_srl | inst_srlw | inst_sraw | inst_and | inst_or | inst_xor | inst_auipc | inst_lui | inst_ld | inst_lw | inst_lh | inst_lb | inst_lwu | inst_lhu | inst_lbu | inst_addi | inst_addiw | inst_andi | inst_ori | inst_xori | inst_slti | inst_sltiu | inst_slli | inst_slliw | inst_srli | inst_srliw | inst_srai | inst_sraiw | inst_sd | inst_sw | inst_sh | inst_sb | (inst_bne & rd1_eq_rd2) | (inst_beq & (~rd1_eq_rd2)) | (inst_blt & (~rd1_lts_rd2)) | (inst_bltu & (~rd1_ltu_rd2)) | (inst_bge & (~(rd1_eq_rd2 | rd1_gts_rd2))) | (inst_bgeu & (~(rd1_eq_rd2 | rd1_gtu_rd2)));
    assign ram_re        = inst_ld | inst_lw | inst_lh | inst_lb | inst_lwu | inst_lhu | inst_lbu;
    assign ram_we        = inst_sd | inst_sw | inst_sh | inst_sb;

    assign sel_mux_ram_wdata[3] = inst_sd;
    assign sel_mux_ram_wdata[2] = inst_sw;
    assign sel_mux_ram_wdata[1] = inst_sh;
    assign sel_mux_ram_wdata[0] = inst_sb;

    assign sel_mux_ram_imm[0]   = inst_auipc | inst_lui;
    assign sel_mux_ram_imm[1]   = inst_jal;
    assign sel_mux_ram_imm[2]   = inst_ld | inst_lw | inst_lh | inst_lb | inst_lwu | inst_lhu | inst_lbu | inst_addi | inst_addiw | inst_andi | inst_ori | inst_xori | inst_jalr | inst_slti | inst_sltiu | inst_slli | inst_slliw | inst_srli | inst_srliw | inst_srai | inst_sraiw;
    assign sel_mux_ram_imm[3]   = inst_sd | inst_sw | inst_sh | inst_sb;
    assign sel_mux_ram_imm[4]   = inst_bne | inst_beq | inst_blt | inst_bltu | inst_bge | inst_bgeu;

    assign sel_mux_ram_rdata[0] = inst_lbu;
    assign sel_mux_ram_rdata[1] = inst_lhu;
    assign sel_mux_ram_rdata[2] = inst_lwu;
    assign sel_mux_ram_rdata[3] = inst_lb;
    assign sel_mux_ram_rdata[4] = inst_lh;
    assign sel_mux_ram_rdata[5] = inst_lw;
    assign sel_mux_ram_rdata[6] = inst_ld;

    assign sel_mux_reg_wdata_sign[0] = inst_addw | inst_subw | inst_mulw | inst_divw | inst_divuw | inst_remw | inst_sllw | inst_srlw | inst_sraw | inst_addiw | inst_slliw | inst_srliw | inst_sraiw;
    assign sel_mux_reg_wdata_sign[1] = inst_add | inst_sub | inst_mul | inst_div | inst_divu | inst_rem | inst_remu | inst_remuw | inst_slt | inst_sltu | inst_sll | inst_srl | inst_and | inst_or | inst_xor | inst_auipc | inst_lui | inst_jal | inst_ld | inst_lw | inst_lh | inst_lb | inst_lwu | inst_lhu | inst_lbu | inst_addi | inst_andi | inst_ori | inst_xori | inst_jalr | inst_slti | inst_sltiu | inst_slli | inst_srli | inst_srai | inst_bne | inst_beq | inst_blt | inst_bltu | inst_bge | inst_bgeu;

    assign reg_re           = ~(inst_auipc | inst_lui | inst_jal);
    assign reg_we           = ~(inst_sd | inst_sw | inst_sh | inst_sb | inst_bne | inst_beq | inst_blt | inst_bltu | inst_bge | inst_bgeu);

    assign sel_mux_alu_src1[0]     = inst_add | inst_addw | inst_sub | inst_subw | inst_mul | inst_mulw | inst_div | inst_divu | inst_divw | inst_rem | inst_remu | inst_remw | inst_slt | inst_sltu | inst_sll | inst_srl | inst_and | inst_or | inst_xor | inst_lui | inst_ld | inst_lw | inst_lh | inst_lb | inst_lwu | inst_lhu | inst_lbu | inst_addi | inst_addiw | inst_andi | inst_ori | inst_xori | inst_jalr | inst_slti | inst_sltiu | inst_slli | inst_slliw | inst_srli | inst_srai | inst_sd | inst_sw | inst_sh | inst_sb;
    assign sel_mux_alu_src1[1]     = inst_divuw | inst_remuw | inst_sllw | inst_srlw | inst_sraw | inst_srliw | inst_sraiw;
    assign sel_mux_alu_src1[2]     = inst_auipc | inst_jal | inst_bne | inst_beq | inst_blt | inst_bltu | inst_bge | inst_bgeu;

    assign sel_mux_alu_src2[0]     = inst_lui | inst_sraiw;
    assign sel_mux_alu_src2[1]     = inst_srai;
    assign sel_mux_alu_src2[2]     = inst_auipc | inst_jal | inst_ld | inst_lw | inst_lh | inst_lb | inst_lwu | inst_lhu | inst_lbu | inst_addi | inst_addiw | inst_andi | inst_ori | inst_xori | inst_jalr | inst_slti | inst_sltiu | inst_slli | inst_slliw | inst_srli | inst_srliw | inst_sd | inst_sw | inst_sh | inst_sb | inst_bne | inst_beq | inst_blt | inst_bltu | inst_bge | inst_bgeu;
    assign sel_mux_alu_src2[3]     = inst_sll | inst_srl;
    assign sel_mux_alu_src2[4]     = inst_add | inst_addw | inst_sub | inst_subw | inst_mul | inst_mulw | inst_div | inst_divu | inst_divw | inst_rem | inst_remu | inst_remw | inst_slt | inst_sltu | inst_sllw | inst_and | inst_or | inst_xor;
    assign sel_mux_alu_src2[5]     = inst_divuw | inst_remuw | inst_srlw | inst_sraw;

    assign alu_control[0]      = inst_add | inst_addw | inst_auipc | inst_lui | inst_jal | inst_ld | inst_lw | inst_lh | inst_lb | inst_lwu | inst_lhu | inst_lbu | inst_addi | inst_addiw | inst_jalr | inst_sd | inst_sw | inst_sh | inst_sb | inst_bne | inst_beq | inst_blt | inst_bltu | inst_bge | inst_bgeu;
    assign alu_control[1]      = inst_sub | inst_subw;
    assign alu_control[2]      = inst_slt | inst_slti;
    assign alu_control[3]      = inst_sltu | inst_sltiu;
    assign alu_control[4]      = inst_and | inst_andi;
    assign alu_control[5]      = inst_or | inst_ori;
    assign alu_control[6]      = inst_xor | inst_xori;
    assign alu_control[7]      = inst_sll | inst_sllw | inst_slli | inst_slliw;
    assign alu_control[8]      = inst_srl | inst_srlw | inst_srli | inst_srliw;
    assign alu_control[9]      = inst_sraw | inst_srai | inst_sraiw;
    assign alu_control[10]     = inst_mul | inst_mulw;
    assign alu_control[11]     = inst_div | inst_divw;
    assign alu_control[12]     = inst_divu | inst_divuw;
    assign alu_control[13]     = inst_remuw;
    assign alu_control[14]     = inst_sraw | inst_and | inst_xor;

endmodule
