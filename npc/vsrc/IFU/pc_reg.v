module pc_reg (
    input   wire       clk,
    input   wire       rst,
    input   wire[63:0] din_pc,

    output  reg[63:0]  pc_addr
);
    always @ (posedge clk) begin
        if(rst) pc_addr <= 64'h80000000;
        else    pc_addr <= din_pc;
    end
endmodule
