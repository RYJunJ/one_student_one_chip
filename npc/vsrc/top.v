// Generator : SpinalHDL v1.8.0    git head : 4e3563a282582b41f4eaafc503787757251d23ea
// Component : top


module top (
  input               ps2_clk,
  input               ps2_data,
  output     [6:0]    ldo1,
  output     [6:0]    ldo2,
  output     [6:0]    ldo3,
  output     [6:0]    ldo4,
  output     [6:0]    ldo5,
  output     [6:0]    ldo6,
  input               reset,
  input               clk
);

  wire       [3:0]    led1_io_b;
  wire       [3:0]    led2_io_b;
  wire       [3:0]    led3_io_b;
  wire       [3:0]    led4_io_b;
  wire       [3:0]    led5_io_b;
  wire       [3:0]    led6_io_b;
  wire       [7:0]    keyboard_num;
  wire                keyboard_ena;
  wire       [6:0]    led1_io_h;
  wire       [6:0]    led2_io_h;
  wire       [6:0]    led3_io_h;
  wire       [6:0]    led4_io_h;
  wire       [6:0]    led5_io_h;
  wire       [6:0]    led6_io_h;
  wire       [7:0]    rom_data;
  wire       [7:0]    _zz_io_b;
  wire       [7:0]    _zz_io_b_1;
  reg        [7:0]    cnt;
  reg                 chnge;
  wire                when_top_l209;

  assign _zz_io_b = cnt;
  assign _zz_io_b_1 = cnt;
  ps2_keyboard keyboard (
    .ps2_clk  (ps2_clk          ), //i
    .ps2_data (ps2_data         ), //i
    .clk      (clk              ), //i
    .resetn   (reset            ), //i
    .num      (keyboard_num[7:0]), //o
    .ena      (keyboard_ena     )  //o
  );
  Bcd7seg_5 led1 (
    .io_b   (led1_io_b[3:0]), //i
    .io_ena (keyboard_ena  ), //i
    .io_h   (led1_io_h[6:0])  //o
  );
  Bcd7seg_5 led2 (
    .io_b   (led2_io_b[3:0]), //i
    .io_ena (keyboard_ena  ), //i
    .io_h   (led2_io_h[6:0])  //o
  );
  Bcd7seg_5 led3 (
    .io_b   (led3_io_b[3:0]), //i
    .io_ena (keyboard_ena  ), //i
    .io_h   (led3_io_h[6:0])  //o
  );
  Bcd7seg_5 led4 (
    .io_b   (led4_io_b[3:0]), //i
    .io_ena (keyboard_ena  ), //i
    .io_h   (led4_io_h[6:0])  //o
  );
  Bcd7seg_5 led5 (
    .io_b   (led5_io_b[3:0]), //i
    .io_ena (1'b1          ), //i
    .io_h   (led5_io_h[6:0])  //o
  );
  Bcd7seg_5 led6 (
    .io_b   (led6_io_b[3:0]), //i
    .io_ena (1'b1          ), //i
    .io_h   (led6_io_h[6:0])  //o
  );
  Myrom rom (
    .address (keyboard_num[7:0]), //i
    .data    (rom_data[7:0]    )  //o
  );
  assign when_top_l209 = ((chnge == 1'b1) && (keyboard_ena == 1'b0)); // @[BaseType.scala 305:24]
  assign led1_io_b = keyboard_num[3 : 0]; // @[top.scala 217:15]
  assign led2_io_b = keyboard_num[7 : 4]; // @[top.scala 219:15]
  assign led3_io_b = rom_data[3 : 0]; // @[top.scala 221:15]
  assign led4_io_b = rom_data[7 : 4]; // @[top.scala 223:15]
  assign led5_io_b = _zz_io_b[3 : 0]; // @[top.scala 225:15]
  assign led6_io_b = _zz_io_b_1[7 : 4]; // @[top.scala 227:15]
  assign ldo1 = led1_io_h; // @[top.scala 230:13]
  assign ldo2 = led2_io_h; // @[top.scala 231:13]
  assign ldo3 = led3_io_h; // @[top.scala 232:13]
  assign ldo4 = led4_io_h; // @[top.scala 233:13]
  assign ldo5 = led5_io_h; // @[top.scala 234:13]
  assign ldo6 = led6_io_h; // @[top.scala 235:13]
  always @(posedge clk or posedge reset) begin
    if(~reset) begin
      chnge <= 1'b0; // @[Data.scala 400:33]
    end else begin
      chnge <= keyboard_ena; // @[top.scala 208:11]
    end

    if(when_top_l209) begin
      cnt <= (cnt + 8'h01); // @[top.scala 210:13]
    end
  end

endmodule

module Myrom (
  input      [7:0]    address,
  output reg [7:0]    data
);


  always @(*) begin
    case(address)
      8'h45 : begin
        data = 8'h30; // @[top.scala 72:21]
      end
      8'h16 : begin
        data = 8'h31; // @[top.scala 75:21]
      end
      8'h1e : begin
        data = 8'h32; // @[top.scala 78:21]
      end
      8'h26 : begin
        data = 8'h33; // @[top.scala 81:21]
      end
      8'h25 : begin
        data = 8'h34; // @[top.scala 84:21]
      end
      8'h2e : begin
        data = 8'h35; // @[top.scala 87:21]
      end
      8'h36 : begin
        data = 8'h36; // @[top.scala 90:21]
      end
      8'h3d : begin
        data = 8'h37; // @[top.scala 93:21]
      end
      8'h3e : begin
        data = 8'h38; // @[top.scala 96:21]
      end
      8'h46 : begin
        data = 8'h39; // @[top.scala 99:21]
      end
      8'h15 : begin
        data = 8'h51; // @[top.scala 102:21]
      end
      8'h1d : begin
        data = 8'h57; // @[top.scala 105:21]
      end
      8'h24 : begin
        data = 8'h45; // @[top.scala 108:21]
      end
      8'h2d : begin
        data = 8'h52; // @[top.scala 111:21]
      end
      8'h2c : begin
        data = 8'h54; // @[top.scala 114:21]
      end
      8'h35 : begin
        data = 8'h59; // @[top.scala 117:21]
      end
      8'h3c : begin
        data = 8'h55; // @[top.scala 120:21]
      end
      8'h43 : begin
        data = 8'h49; // @[top.scala 123:21]
      end
      8'h44 : begin
        data = 8'h4f; // @[top.scala 126:21]
      end
      8'h4d : begin
        data = 8'h50; // @[top.scala 129:21]
      end
      8'h1c : begin
        data = 8'h41; // @[top.scala 132:21]
      end
      8'h1b : begin
        data = 8'h53; // @[top.scala 135:21]
      end
      8'h23 : begin
        data = 8'h44; // @[top.scala 138:21]
      end
      8'h2b : begin
        data = 8'h46; // @[top.scala 141:21]
      end
      8'h34 : begin
        data = 8'h47; // @[top.scala 144:21]
      end
      8'h33 : begin
        data = 8'h48; // @[top.scala 147:21]
      end
      8'h3b : begin
        data = 8'h4a; // @[top.scala 150:21]
      end
      8'h42 : begin
        data = 8'h4b; // @[top.scala 153:21]
      end
      8'h4b : begin
        data = 8'h4c; // @[top.scala 156:21]
      end
      8'h1a : begin
        data = 8'h5a; // @[top.scala 159:21]
      end
      8'h22 : begin
        data = 8'h58; // @[top.scala 162:21]
      end
      8'h21 : begin
        data = 8'h43; // @[top.scala 165:21]
      end
      8'h2a : begin
        data = 8'h56; // @[top.scala 168:21]
      end
      8'h32 : begin
        data = 8'h42; // @[top.scala 171:21]
      end
      8'h31 : begin
        data = 8'h4e; // @[top.scala 174:21]
      end
      8'h3a : begin
        data = 8'h4d; // @[top.scala 177:21]
      end
      default : begin
        data = 8'h0; // @[top.scala 180:21]
      end
    endcase
  end


endmodule

//Bcd7seg_5 replaced by Bcd7seg_5

//Bcd7seg_5 replaced by Bcd7seg_5

//Bcd7seg_5 replaced by Bcd7seg_5

//Bcd7seg_5 replaced by Bcd7seg_5

//Bcd7seg_5 replaced by Bcd7seg_5

module Bcd7seg_5 (
  input      [3:0]    io_b,
  input               io_ena,
  output reg [6:0]    io_h
);

  wire                when_top_l10;
  wire                when_top_l13;
  wire                when_top_l15;
  wire                when_top_l17;
  wire                when_top_l19;
  wire                when_top_l21;
  wire                when_top_l23;
  wire                when_top_l25;
  wire                when_top_l27;
  wire                when_top_l29;
  wire                when_top_l31;
  wire                when_top_l33;
  wire                when_top_l35;
  wire                when_top_l37;
  wire                when_top_l39;
  wire                when_top_l41;
  wire                when_top_l43;

  assign when_top_l10 = (io_ena == 1'b0); // @[BaseType.scala 305:24]
  always @(*) begin
    if(when_top_l10) begin
      io_h = 7'h7f; // @[top.scala 11:14]
    end else begin
      if(when_top_l13) begin
        io_h = 7'h40; // @[top.scala 14:18]
      end else begin
        if(when_top_l15) begin
          io_h = (~ 7'h06); // @[top.scala 16:18]
        end else begin
          if(when_top_l17) begin
            io_h = (~ 7'h5b); // @[top.scala 18:18]
          end else begin
            if(when_top_l19) begin
              io_h = (~ 7'h4f); // @[top.scala 20:18]
            end else begin
              if(when_top_l21) begin
                io_h = (~ 7'h66); // @[top.scala 22:18]
              end else begin
                if(when_top_l23) begin
                  io_h = (~ 7'h6d); // @[top.scala 24:18]
                end else begin
                  if(when_top_l25) begin
                    io_h = (~ 7'h7d); // @[top.scala 26:18]
                  end else begin
                    if(when_top_l27) begin
                      io_h = (~ 7'h07); // @[top.scala 28:18]
                    end else begin
                      if(when_top_l29) begin
                        io_h = (~ 7'h7f); // @[top.scala 30:18]
                      end else begin
                        if(when_top_l31) begin
                          io_h = (~ 7'h6f); // @[top.scala 32:18]
                        end else begin
                          if(when_top_l33) begin
                            io_h = (~ 7'h77); // @[top.scala 34:18]
                          end else begin
                            if(when_top_l35) begin
                              io_h = (~ 7'h7c); // @[top.scala 36:18]
                            end else begin
                              if(when_top_l37) begin
                                io_h = (~ 7'h39); // @[top.scala 38:18]
                              end else begin
                                if(when_top_l39) begin
                                  io_h = (~ 7'h5e); // @[top.scala 40:18]
                                end else begin
                                  if(when_top_l41) begin
                                    io_h = (~ 7'h79); // @[top.scala 42:18]
                                  end else begin
                                    if(when_top_l43) begin
                                      io_h = (~ 7'h71); // @[top.scala 44:18]
                                    end else begin
                                      io_h = 7'h7f; // @[top.scala 46:18]
                                    end
                                  end
                                end
                              end
                            end
                          end
                        end
                      end
                    end
                  end
                end
              end
            end
          end
        end
      end
    end
  end

  assign when_top_l13 = (io_b == 4'b0000); // @[BaseType.scala 305:24]
  assign when_top_l15 = (io_b == 4'b0001); // @[BaseType.scala 305:24]
  assign when_top_l17 = (io_b == 4'b0010); // @[BaseType.scala 305:24]
  assign when_top_l19 = (io_b == 4'b0011); // @[BaseType.scala 305:24]
  assign when_top_l21 = (io_b == 4'b0100); // @[BaseType.scala 305:24]
  assign when_top_l23 = (io_b == 4'b0101); // @[BaseType.scala 305:24]
  assign when_top_l25 = (io_b == 4'b0110); // @[BaseType.scala 305:24]
  assign when_top_l27 = (io_b == 4'b0111); // @[BaseType.scala 305:24]
  assign when_top_l29 = (io_b == 4'b1000); // @[BaseType.scala 305:24]
  assign when_top_l31 = (io_b == 4'b1001); // @[BaseType.scala 305:24]
  assign when_top_l33 = (io_b == 4'b1010); // @[BaseType.scala 305:24]
  assign when_top_l35 = (io_b == 4'b1011); // @[BaseType.scala 305:24]
  assign when_top_l37 = (io_b == 4'b1100); // @[BaseType.scala 305:24]
  assign when_top_l39 = (io_b == 4'b1101); // @[BaseType.scala 305:24]
  assign when_top_l41 = (io_b == 4'b1110); // @[BaseType.scala 305:24]
  assign when_top_l43 = (io_b == 4'b1111); // @[BaseType.scala 305:24]

endmodule
