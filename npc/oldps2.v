module old_ps2_keyboard(clk,resetn,ps2_clk,ps2_data,num,ena);
	input clk,resetn,ps2_clk,ps2_data;
	output [7:0] num;
	output ena;
    reg [9:0] buffer;        // ps2_data bits
    reg [3:0] count;  // count ps2_data bits
    reg [2:0] ps2_clk_sync;
	//reg [7:0] lst;
	reg tmp;

    always @(posedge clk) begin
        ps2_clk_sync <=  {ps2_clk_sync[1:0],ps2_clk};
    end

    wire sampling = ps2_clk_sync[2] & ~ps2_clk_sync[1];
	assign ena = sampling;

    always @(posedge clk) begin
		/*if(lst == buffer[8:1]) begin
			tmp <= 0;
		end else begin
			tmp <= 1;
		end*/
        if (resetn == 0) begin // reset
            count <= 0;
        end
        else begin
            if (sampling) begin
				$display("ps2_data = %d",ps2_data);
              if (count == 4'd10) begin
                if ((buffer[0] == 0) &&  // start bit
                    (ps2_data)       &&  // stop bit
                    (^buffer[9:1])) begin      // odd  parity
                    $display("receive %x", buffer[8:1]);
					//lst <= buffer[8:1];
                end
                count <= 0;     // for next
              end else begin
                buffer[count] <= ps2_data;  // store ps2_data
                count <= count + 3'b1;
              end
            end
        end
    end
	assign num = buffer[8:1];
endmodule
