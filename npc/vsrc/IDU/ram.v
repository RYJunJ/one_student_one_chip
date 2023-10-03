module ram (
    input         clk,
    input  [63:0] inst_addr,
    input  [63:0] raddr,
    input  [63:0] waddr,
    input  [63:0] wdata,
    input         re,
    input         we,

    output [31:0] inst,
    output [63:0] rdata
);
    import "DPI-C" function void npc_pmem_read(
        input longint addr, output longint rdata);
    import "DPI-C" function void pmem_write(
        input longint addr, input  longint wdata, input byte wmask);
    import "DPI-C" function void test_out_put(input longint addr);

    /* verilator lint_off UNOPTFLAT */
    wire[63:0] tp_inst;

    assign inst = tp_inst[31:0];
 
    /* verilator lint_off LATCH */
    always @(inst_addr, raddr) begin
        npc_pmem_read(inst_addr, tp_inst);
        if(re)  npc_pmem_read(raddr, rdata);
    end

    always @ (posedge clk) begin
        if(we)  pmem_write(waddr, wdata, 1);
    end
endmodule
