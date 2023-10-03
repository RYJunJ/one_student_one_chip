module EXU (
    input  [63:0] src_pc_reg,
    input  [63:0] src_reg_rdata1,
    input  [63:0] src_reg_rdata2,
    input  [63:0] src_imm,
    input         inst_rem,
    input  [14:0] alu_control,
    input  [ 2:0] sel_mux_alu_src1,
    input  [ 5:0] sel_mux_alu_src2,

    output [63:0] alu_result
);

    wire[14:0] alu_op_real;
    wire[63:0] alu_src1;
    wire[63:0] alu_src2;

    wire       sel_mux_alu_op;

    mux3_64b mux_alu_src1(.in2(src_pc_reg), .in1({{32'b0}, src_reg_rdata1[31:0]}), .in0(src_reg_rdata1), .sel(sel_mux_alu_src1), .out(alu_src1));
    mux6_64b mux_alu_src2(.in5({{32'b0}, src_reg_rdata2[31:0]}), .in4(src_reg_rdata2), .in3({{58'b0}, src_reg_rdata2[5:0]}), .in2(src_imm), .in1({{58'b0}, src_imm[5:0]}), .in0({{59'b0}, src_imm[4:0]}), .sel(sel_mux_alu_src2), .out(alu_src2));
    assign sel_mux_alu_op = inst_rem & src_reg_rdata1[63];
    mux2_15b mux_alu_op(.in0(alu_control), .in1({15'b010000000000000}), .sel(sel_mux_alu_op ? {2'b10} : {2'b01}), .out(alu_op_real));

    alu alu_in_EXU(.alu_control(alu_op_real), .alu_src1(alu_src1), .alu_src2(alu_src2), .alu_result(alu_result));

endmodule
