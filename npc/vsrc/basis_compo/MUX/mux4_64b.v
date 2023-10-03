module mux4_64b (
    input  [63:0] in0, in1, in2, in3,
    input  [3:0]  sel,
    output [63:0] out
);

assign out = ({64{sel[0]}} & in0)
           | ({64{sel[1]}} & in1)
           | ({64{sel[2]}} & in2)
           | ({64{sel[3]}} & in3);

endmodule
