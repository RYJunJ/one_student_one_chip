module reg_file (
    input         clk,
    input  [4:0]  waddr,
    input  [4:0]  raddr1,
    input  [4:0]  raddr2,
    input  [63:0] wdata,
    input         re,
    input         we,

    output [63:0] rdata1,
    output [63:0] rdata2
);
reg [63:0] reg_array[31:0];
//WRITE
always @(posedge clk) begin
    if(we) reg_array[waddr] <= wdata;
end
//READ OUT 1
assign rdata1 = (raddr1 == 5'b0) ? 64'h0 : reg_array[raddr1];
//READ OUT 2
assign rdata2 = (raddr2 == 5'b0) ? 64'h0 : reg_array[raddr2];
endmodule
