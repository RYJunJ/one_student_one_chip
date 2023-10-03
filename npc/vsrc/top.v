module top (
    input  wire clk,
    input  wire rst,

    output wire[31:0] instr,
    output reg[63:0]  pc_addr
);

    wire [63:0] inst_addr;
    /* verilator lint_off UNOPTFLAT */
    wire [31:0] inst;
    wire [63:0] imm;
    wire [63:0] dnpc;
    wire [63:0] ram_rdata;
    wire [63:0] reg_rdata1;
    wire [63:0] reg_rdata2;
    wire [63:0] alu_result;
    wire        rd1_eq_rd2;
    wire        rd1_lts_rd2;
    wire        rd1_ltu_rd2;
    wire        rd1_gts_rd2;
    wire        rd1_gtu_rd2;

    wire        inst_div;
    wire        inst_divu;
    wire        inst_divw;
    wire        inst_divuw;
    wire        inst_rem; 
    wire        inst_remu; 
    wire        inst_remw;
    wire        inst_remuw;
    wire        inst_lui;
    wire        inst_jal;  
    wire        inst_ld;
    wire        inst_lw; 
    wire        inst_lh; 
    wire        inst_lb; 
    wire        inst_lwu;  
    wire        inst_lhu;  
    wire        inst_lbu;  
    wire        inst_jalr; 
    wire        inst_ebreak;
    wire        inst_inv;

    wire[2:0]   sel_mux_pc;
    wire        ram_re;
    wire        ram_we;
    wire[3:0]   sel_mux_ram_wdata;
    wire[4:0]   sel_mux_ram_imm;
    wire[6:0]   sel_mux_ram_rdata;
    wire[1:0]   sel_mux_reg_wdata_sign;
    wire        reg_re;
    wire        reg_we;
    wire[2:0]   sel_mux_alu_src1;
    wire[5:0]   sel_mux_alu_src2;
    wire[14:0]  alu_control;

    control_signal my_control_signal (.inst(inst), .rd1_eq_rd2(rd1_eq_rd2), .rd1_lts_rd2(rd1_lts_rd2), .rd1_ltu_rd2(rd1_ltu_rd2), .rd1_gts_rd2(rd1_gts_rd2), .rd1_gtu_rd2(rd1_gtu_rd2), .inst_div(inst_div), .inst_divu(inst_divu), .inst_divw(inst_divw), .inst_divuw(inst_divuw), .inst_rem(inst_rem), .inst_remu(inst_remu), .inst_remw(inst_remw), .inst_remuw(inst_remuw), .inst_lui(inst_lui), .inst_jal(inst_jal), .inst_ld(inst_ld), .inst_lw(inst_lw), .inst_lh(inst_lh), .inst_lb(inst_lb), .inst_lwu(inst_lwu), .inst_lhu(inst_lhu), .inst_lbu(inst_lbu), .inst_jalr(inst_jalr), .inst_ebreak(inst_ebreak), .inst_inv(inst_inv), .sel_mux_pc(sel_mux_pc), .ram_re(ram_re), .ram_we(ram_we), .sel_mux_ram_wdata(sel_mux_ram_wdata), .sel_mux_ram_imm(sel_mux_ram_imm), .sel_mux_ram_rdata(sel_mux_ram_rdata), .sel_mux_reg_wdata_sign(sel_mux_reg_wdata_sign), .reg_re(reg_re), .reg_we(reg_we), .sel_mux_alu_src1(sel_mux_alu_src1), .sel_mux_alu_src2(sel_mux_alu_src2), .alu_control(alu_control));
    IFU     my_IFU     (.clk(clk), .rst(rst), .sel_mux_pc(sel_mux_pc), .src_alu(alu_result), .pc_addr(inst_addr), .dnpc(dnpc));
    ram_IDU my_ram_IDU (.clk(clk), .inst_addr(inst_addr), .src_alu(alu_result), .src_reg_rdata2(reg_rdata2), .sel_mux_ram_wdata(sel_mux_ram_wdata), .sel_mux_ram_imm(sel_mux_ram_imm), .sel_mux_ram_rdata(sel_mux_ram_rdata), .re(ram_re), .we(ram_we), .imm(imm), .inst(inst), .ram_rdata(ram_rdata));
    reg_IDU my_reg_IDU (.clk(clk), .inst(inst), .src_alu(alu_result), .src_imm(imm), .src_pc(dnpc), .src_ram_rdata(ram_rdata), .sel_mux_reg_wdata_sign(sel_mux_reg_wdata_sign), .re(reg_re), .we(reg_we), .inst_div(inst_div), .inst_divu(inst_divu), .inst_divw(inst_divw), .inst_divuw(inst_divuw), .inst_rem(inst_rem), .inst_remu(inst_remu), .inst_remw(inst_remw), .inst_remuw(inst_remuw), .inst_lui(inst_lui), .inst_jal(inst_jal), .inst_jalr(inst_jalr), .inst_ld(inst_ld), .inst_lw(inst_lw), .inst_lh(inst_lh), .inst_lb(inst_lb), .inst_lwu(inst_lwu), .inst_lhu(inst_lhu), .inst_lbu(inst_lbu), .rdata1(reg_rdata1), .rdata2(reg_rdata2), .rd1_eq_rd2(rd1_eq_rd2), .rd1_lts_rd2(rd1_lts_rd2), .rd1_ltu_rd2(rd1_ltu_rd2), .rd1_gts_rd2(rd1_gts_rd2), .rd1_gtu_rd2(rd1_gtu_rd2));
    EXU     my_EXU     (.src_pc_reg(inst_addr), .src_reg_rdata1(reg_rdata1), .src_reg_rdata2(reg_rdata2), .src_imm(imm), .inst_rem(inst_rem), .alu_control(alu_control), .sel_mux_alu_src1(sel_mux_alu_src1), .sel_mux_alu_src2(sel_mux_alu_src2), .alu_result(alu_result));

endmodule
