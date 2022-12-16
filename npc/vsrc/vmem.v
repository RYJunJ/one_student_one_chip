module vmem (
	input [9:0] h_addr,
	input [8:0] v_addr,
	output [23:0] vga_data
);

reg [23:0] vga_mem [524287:0];

initial begin
	$readmemh("resource/picture.hex", vga_mem);
end

assign vga_data = vga_mem[{h_addr, v_addr}];

endmodule
