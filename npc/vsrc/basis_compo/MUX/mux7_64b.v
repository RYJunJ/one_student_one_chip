module mux7_64b (
    input  [63:0] in0, in1, in2, in3, in4, in5, in6,
    input  [6:0]  sel,
    output [63:0] out
);

assign out = ({64{sel[0]}} & in0)
           | ({64{sel[1]}} & in1)
           | ({64{sel[2]}} & in2)
           | ({64{sel[3]}} & in3)
           | ({64{sel[4]}} & in4)
           | ({64{sel[5]}} & in5)
           | ({64{sel[6]}} & in6);

endmodule
