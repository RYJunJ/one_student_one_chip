module IFU (
    input   wire       clk,
    input   wire       rst,
    input   wire[2:0]  sel_mux_pc,
    input   wire[63:0] src_alu,

    output  reg[63:0]  pc_addr,
    output  wire[63:0] dnpc
);
    wire[63:0] out_pc_mux;
    wire[63:0] src_pc_reg;
    assign src_pc_reg = pc_addr + 64'h4;
    assign       dnpc = src_pc_reg;
    pc_reg pc_in_IFU (.clk(clk), .rst(rst), .din_pc(out_pc_mux), .pc_addr(pc_addr));
    mux3_64b mux3_64b_in_IFU (.in0(src_alu & 64'hfffffffffffffffe), .in1(src_alu), .in2(src_pc_reg), .sel(sel_mux_pc), .out(out_pc_mux));
endmodule
