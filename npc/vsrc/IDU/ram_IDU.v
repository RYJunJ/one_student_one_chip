module ram_IDU (
    input        clk,
    input [63:0] inst_addr,
    input [63:0] src_alu,
    input [63:0] src_reg_rdata2,
    input [3:0]  sel_mux_ram_wdata,
    input [4:0]  sel_mux_ram_imm,
    input [6:0]  sel_mux_ram_rdata,
    input        re,
    input        we,

    output [63:0] imm,
    output [31:0] inst,
    output [63:0] ram_rdata 
);
    wire[63:0] out_ram_wdata_mux;
    wire[63:0] out_ram_rdata;
    mux4_64b mux_ram_wdata (.sel(sel_mux_ram_wdata), .in0({{56'h0}, {src_reg_rdata2[7:0]}}), .in1({{48'h0}, {src_reg_rdata2[15:0]}}), .in2({{32'h0}, {src_reg_rdata2[31:0]}}), .in3(src_reg_rdata2), .out(out_ram_wdata_mux));
    ram ram_in_IDU (.clk(clk), .inst_addr(inst_addr), .raddr(src_alu), .waddr(src_alu), .wdata(out_ram_wdata_mux), .re(re), .we(we), .inst(inst), .rdata(out_ram_rdata));
    mux5_64b mux_ram_imm (.sel(sel_mux_ram_imm), .in0({{(40){inst[31]}}, {inst[31:20]}, {12'h0}}), .in1({{(43){inst[31]}}, inst[31], inst[19:12], inst[20], inst[30:21], {1'b0}}), .in2({{(52){inst[31]}}, {inst[31:20]}}), .in3({{(52){inst[31]}}, inst[31:25], inst[11:7]}), .in4({{(51){inst[31]}}, inst[31], inst[7], inst[30:25], inst[11:8], {1'b0}}), .out(imm));
    mux7_64b mux_ram_rdata (.sel(sel_mux_ram_rdata), .in0({{56'h0}, out_ram_rdata[7:0]}), .in1({{48'h0}, out_ram_rdata[15:0]}), .in2({{32'h0}, out_ram_rdata[31:0]}), .in3({{(56){out_ram_rdata[7]}}, out_ram_rdata[7:0]}), .in4({{(48){out_ram_rdata[15]}}, out_ram_rdata[15:0]}), .in5({{(32){out_ram_rdata[31]}}, out_ram_rdata[31:0]}), .in6(out_ram_rdata), .out(ram_rdata));
endmodule
