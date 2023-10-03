module reg_IDU (
    input         clk,
    input  [31:0] inst,
    input  [63:0] src_alu,
    input  [63:0] src_imm,
    input  [63:0] src_pc,
    input  [63:0] src_ram_rdata,
    input  [1:0]  sel_mux_reg_wdata_sign,
    input         re,
    input         we,
    input         inst_div,
    input         inst_divu,
    input         inst_divw,
    input         inst_divuw,
    input         inst_rem,
    input         inst_remu,
    input         inst_remw,
    input         inst_remuw,
    input         inst_lui,
    input         inst_jal,
    input         inst_jalr,
    input         inst_ld,
    input         inst_lw,
    input         inst_lh,
    input         inst_lb,
    input         inst_lwu,
    input         inst_lhu,
    input         inst_lbu,

    output [63:0] rdata1,
    output [63:0] rdata2,
    output        rd1_eq_rd2,
    output        rd1_lts_rd2,
    output        rd1_ltu_rd2,
    output        rd1_gts_rd2,
    output        rd1_gtu_rd2
);

wire [63:0] out_mux_reg_wdata_sign;
wire [63:0] out_mux_reg_wdata;

wire [6:0]  sel_mux_reg_wdata;

wire        rd2_eq_zero;
wire        zero_and_div;
wire        zero_and_divuw;
wire        zero_and_rem;

wire        default_mux_wdata;

reg_file reg_in_IFU (.clk(clk), .waddr(inst[11:7]), .raddr1(inst[19:15]), .raddr2(inst[24:20]), .wdata(out_mux_reg_wdata_sign), .rdata1(rdata1), .rdata2(rdata2), .re(re), .we(we));
mux2_64b mux_reg_wdata_sign (.sel(sel_mux_reg_wdata_sign), .in0({{(32){out_mux_reg_wdata[31]}}, out_mux_reg_wdata[31:0]}), .in1(out_mux_reg_wdata), .out(out_mux_reg_wdata_sign));
mux7_64b mux_reg_wdata (.sel(sel_mux_reg_wdata), .in0(src_ram_rdata), .in1(src_pc), .in2(src_imm), .in3(rdata1), .in4({32'h0, 32'hffffffff}), .in5({64'hffffffffffffffff}), .in6(src_alu), .out(out_mux_reg_wdata));
assign rd2_eq_zero = (rdata2 == 64'h0);
assign zero_and_div   = (rd2_eq_zero & (inst_div | inst_divu | inst_divw));
assign zero_and_divuw = (rd2_eq_zero & inst_divuw);
assign zero_and_rem   = (rd2_eq_zero & (inst_rem | inst_remu | inst_remw | inst_remuw));
assign default_mux_wdata = ~(zero_and_div | zero_and_divuw | zero_and_rem | inst_lui | inst_jal | inst_jalr | inst_ld | inst_lw | inst_lh | inst_lb | inst_lwu | inst_lhu | inst_lbu);
assign sel_mux_reg_wdata = {default_mux_wdata, zero_and_div, zero_and_divuw, zero_and_rem, inst_lui, {inst_jal | inst_jalr}, {inst_ld | inst_lw | inst_lh | inst_lb | inst_lwu | inst_lhu | inst_lbu}};

wire adder_cout;
wire [63:0] adder_result;
assign {adder_cout, adder_result} = rdata1 + ({1'b0, ~rdata2}) + 1'b1;
assign rd1_eq_rd2 = (rdata1 == rdata2);
assign rd1_lts_rd2 = (rdata1[63] & ~rdata2[63]) | (~(rdata1[63] ^ rdata2[63]) & adder_result[63]);
assign rd1_ltu_rd2 = ~adder_cout;
assign rd1_gts_rd2 = ~(rd1_eq_rd2 | rd1_lts_rd2);
assign rd1_gtu_rd2 = ~(rd1_eq_rd2 | rd1_ltu_rd2);
endmodule
