module ps2_keyboard(clk,resetn,ps2_clk,ps2_data,num,ena,dnclk);
	input clk,resetn,ps2_clk,ps2_data;
	output [7:0] num;
	output reg ena;
	output reg dnclk;
    reg [9:0] buffer;        // ps2_data bits
    reg [3:0] count;  // count ps2_data bits
    reg [2:0] ps2_clk_sync;
	reg [7:0] lst;

    always @(posedge clk) begin
        ps2_clk_sync <=  {ps2_clk_sync[1:0],ps2_clk};
    end

    wire sampling = ps2_clk_sync[2] & ~ps2_clk_sync[1];

    always @(posedge clk) begin
		/*if(lst == buffer[8:1]) begin
			tmp <= 0;
		end else begin
			tmp <= 1;
		end*/
		if (resetn == 1) begin // reset
			count <= 0;
			lst <= 8'd0;
			ena <= 0;
        end
        else begin
			if (sampling) begin
				if (count == 4'd10) begin
					if ((buffer[0] == 0) && (ps2_data) && (^buffer[9:1])) begin      // odd  parity
						$display("receive %x", buffer[8:1]);
					end
					if(lst == 8'hf0) ena <= 0;
					else			 ena <= 1;
					lst   <= buffer[8:1];
					count <= 0;
					if(buffer[8:1] != 8'hf0) begin
						dnclk <= 0;     // for next
					end
				end
				else begin
					dnclk <= 1;
					buffer[count] <= ps2_data;  // store ps2_data
					count <= count + 3'b1;
				end
			end
        end
    end
	assign num = buffer[8:1];
endmodule
