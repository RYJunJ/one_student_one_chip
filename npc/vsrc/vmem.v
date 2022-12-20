module vmem (
	input [11:0] maddr,
	output [11:0] vga_data
);

reg [11:0] vga_mem [4095:0];

initial begin
	$readmemh("resource/vga_font.txt", vga_mem);
end

assign vga_data = vga_mem[maddr];

endmodule
