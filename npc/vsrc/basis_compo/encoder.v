module encoder # (
    parameter A_WIDTH = 8,
    parameter B_WIDTH = 4
) (
    input  [A_WIDTH - 1 : 0] in,
    output [B_WIDTH - 1 : 0] out
);
    genvar i;
    generate
        for( i = 0 ; i < B_WIDTH ; i++ ) begin
            assign out[i] = (in == i);
        end
    endgenerate
endmodule
