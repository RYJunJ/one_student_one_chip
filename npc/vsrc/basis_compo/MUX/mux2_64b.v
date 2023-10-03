module mux2_64b (
    input  [63:0] in0, in1,
    input  [1:0]  sel,
    output [63:0] out
);

assign out = ({64{sel[0]}} & in0)
           | ({64{sel[1]}} & in1);

endmodule
