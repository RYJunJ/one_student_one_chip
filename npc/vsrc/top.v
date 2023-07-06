module top (
    input  wire clk,
    //input  wire rst,

    output wire[31:0] instr,
    output reg[63:0]  pc_addr
);

    wire[63:0] src1;
    wire[63:0] src2;
    wire       pc_jal_mux;
    wire[3:0]  op;
    /* verilator lint_off UNOPTFLAT */
    reg[63:0]  result;
    wire[63:0] jal_pc;

    my_IFU top_my_IFU (.pc_addr(pc_addr), .clk(clk), .pc_jal_mux(pc_jal_mux), .jal_pc(jal_pc), .instr(instr));
    my_IDU top_my_IDU (.pc_addr(pc_addr), .clk(clk), .instr(instr), .src1(src1), .src2(src2), .op(op), .result(result), .pc_jal_mux(pc_jal_mux), .jal_pc(jal_pc));
    my_EXU top_my_EXU (.src1(src1), .src2(src2), .op(op), .result(result));

endmodule
