module alu (
    input  [14:0] alu_control,
    input  [63:0] alu_src1,
    input  [63:0] alu_src2,

    output [63:0] alu_result
);

wire op_add;
wire op_sub;
wire op_slt;
wire op_sltu;
wire op_and;
wire op_or;
wire op_xor;
wire op_sll;
wire op_srl;
wire op_sra;
wire op_mul;
wire op_div;
wire op_divu;
wire op_mod;
wire op_modu;

assign op_add  = alu_control[0];
assign op_sub  = alu_control[1];
assign op_slt  = alu_control[2];
assign op_sltu = alu_control[3];
assign op_and  = alu_control[4];
assign op_or   = alu_control[5];
assign op_xor  = alu_control[6];
assign op_sll  = alu_control[7];
assign op_srl  = alu_control[8];
assign op_sra  = alu_control[9];
assign op_mul  = alu_control[10];
assign op_div  = alu_control[11];
assign op_divu = alu_control[12];
assign op_mod  = alu_control[13];
assign op_modu = alu_control[14];

wire [63:0] add_sub_result;
wire [63:0] slt_result;
wire [63:0] sltu_result;
wire [63:0] and_result;
wire [63:0] or_result;
wire [63:0] xor_result;
wire [63:0] sll_result;
wire [63:0] srl_result;
wire [63:0] sra_result;
wire [63:0] mul_result;
wire [63:0] div_result;
wire [63:0] divu_result;
wire [63:0] mod_result;
wire [63:0] modu_result;

assign and_result  = alu_src1 & alu_src2;
assign or_result   = alu_src1 | alu_src2;
assign xor_result  = alu_src1 ^ alu_src2;
assign mul_result  = alu_src1 * alu_src2;
assign div_result  = $signed(alu_src1) / $signed(alu_src2);
assign divu_result = alu_src1 / alu_src2;
assign mod_result  = $signed(alu_src1) % $signed(alu_src2);
assign modu_result = alu_src1 % alu_src2;

wire [63:0] adder_a;
wire [63:0] adder_b;
wire        adder_cin;
wire [63:0] adder_result;
wire        adder_cin;
wire        adder_cout;

assign adder_a   = alu_src1;
assign adder_b   = (op_sub | op_slt | op_sltu) ? ~alu_src2 : alu_src2;
assign adder_cin = (op_sub | op_slt | op_sltu) ?      1'b1 :     1'b0;
assign {adder_cout, adder_result} = adder_a + adder_b + {64'h0, adder_cin};

assign add_sub_result = adder_result;


assign slt_result[63:1] = 63'b0;
assign slt_result[0]    = (alu_src1[63] & ~alu_src2[63])
                        | (~(alu_src1[63] ^ alu_src2[63]) & adder_result[63]);

assign sltu_result[63:1] = 63'b0;
assign sltu_result[0]    = ~adder_cout;

assign sll_result = alu_src2 << alu_src1;

assign srl_result = alu_src2 >> alu_src1;

assign sra_result = ($signed(alu_src2)) >>> alu_src1;

assign alu_result = ({64{op_add | op_sub  }} & add_sub_result)
                  | ({64{op_slt           }} & slt_result)
                  | ({64{op_sltu          }} & sltu_result)
                  | ({64{op_and           }} & and_result)
                  | ({64{op_or            }} & or_result)
                  | ({64{op_xor           }} & xor_result)
                  | ({64{op_sll           }} & sll_result)
                  | ({64{op_srl           }} & srl_result)
                  | ({64{op_sra           }} & sra_result)
                  | ({64{op_mul           }} & mul_result)
                  | ({64{op_div           }} & div_result)
                  | ({64{op_divu          }} & divu_result)
                  | ({64{op_mod           }} & mod_result)
                  | ({64{op_modu          }} & modu_result);

endmodule
