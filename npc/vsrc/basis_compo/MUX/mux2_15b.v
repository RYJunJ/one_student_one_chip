module mux2_15b (
    input  [14:0] in0, in1,
    input  [1:0]  sel,
    output [14:0] out
);

assign out = ({15{sel[0]}} & in0)
           | ({15{sel[1]}} & in1);

endmodule
