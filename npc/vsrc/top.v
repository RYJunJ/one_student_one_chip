module top(
	input clk,
	input rst,
	output reg [15:0] led
);
	reg [31:0] count;
	always @(posedge clk) begin
		if(rst) begin led <= 1; count <= 0; end
		else begin
			if(count == 0) led <= {led[14:0], led[15]};
			count <= (count >= 5000000 ? 32'b0 : count + 1);
		end
	end

//	initial begin
//		if ($test$plusargs("trace") != 0) begin
//			$display("[%0t] Tracing to logs/vlt_dump.vcd...\n", $time);
//			$dumpfile("logs/vlt_dump.vcd");
//			$dumpvars();
//		end
//		$display("[%0t] Model running...\n", $time);
//	end

endmodule
