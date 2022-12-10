// Generator : SpinalHDL v1.8.0    git head : 4e3563a282582b41f4eaafc503787757251d23ea
// Component : top

`timescale 1ns/1ps

module top (
  input      [7:0]    min,
  output reg [2:0]    mout,
  output     [6:0]    ldo
);

  wire       [3:0]    led_io_b;
  wire       [6:0]    led_io_h;
  wire       [2:0]    _zz_io_b;
  wire                when_top_l44;
  wire                when_top_l44_1;
  wire                when_top_l44_2;
  wire                when_top_l44_3;
  wire                when_top_l44_4;
  wire                when_top_l44_5;
  wire                when_top_l44_6;
  wire                when_top_l44_7;

  assign _zz_io_b = mout;
  Bcd7seg led (
    .io_b (led_io_b[3:0]), //i
    .io_h (led_io_h[6:0])  //o
  );
  always @(*) begin
    mout = 3'b000; // @[top.scala 42:13]
    if(when_top_l44) begin
      mout = 3'b000; // @[top.scala 45:21]
    end
    if(when_top_l44_1) begin
      mout = 3'b001; // @[top.scala 45:21]
    end
    if(when_top_l44_2) begin
      mout = 3'b010; // @[top.scala 45:21]
    end
    if(when_top_l44_3) begin
      mout = 3'b011; // @[top.scala 45:21]
    end
    if(when_top_l44_4) begin
      mout = 3'b100; // @[top.scala 45:21]
    end
    if(when_top_l44_5) begin
      mout = 3'b101; // @[top.scala 45:21]
    end
    if(when_top_l44_6) begin
      mout = 3'b110; // @[top.scala 45:21]
    end
    if(when_top_l44_7) begin
      mout = 3'b111; // @[top.scala 45:21]
    end
  end

  assign when_top_l44 = min[0]; // @[BaseType.scala 305:24]
  assign when_top_l44_1 = min[1]; // @[BaseType.scala 305:24]
  assign when_top_l44_2 = min[2]; // @[BaseType.scala 305:24]
  assign when_top_l44_3 = min[3]; // @[BaseType.scala 305:24]
  assign when_top_l44_4 = min[4]; // @[BaseType.scala 305:24]
  assign when_top_l44_5 = min[5]; // @[BaseType.scala 305:24]
  assign when_top_l44_6 = min[6]; // @[BaseType.scala 305:24]
  assign when_top_l44_7 = min[7]; // @[BaseType.scala 305:24]
  assign led_io_b = {1'd0, _zz_io_b}; // @[top.scala 50:28]
  assign ldo = led_io_h; // @[top.scala 51:12]

endmodule

module Bcd7seg (
  input      [3:0]    io_b,
  output reg [6:0]    io_h
);

  wire                when_top_l9;
  wire                when_top_l11;
  wire                when_top_l13;
  wire                when_top_l15;
  wire                when_top_l17;
  wire                when_top_l19;
  wire                when_top_l21;
  wire                when_top_l23;
  wire                when_top_l25;
  wire                when_top_l27;

  assign when_top_l9 = (io_b == 4'b0000); // @[BaseType.scala 305:24]
  always @(*) begin
    if(when_top_l9) begin
      io_h = 7'h7f; // @[top.scala 10:14]
    end else begin
      if(when_top_l11) begin
        io_h = (~ 7'h06); // @[top.scala 12:14]
      end else begin
        if(when_top_l13) begin
          io_h = (~ 7'h5b); // @[top.scala 14:14]
        end else begin
          if(when_top_l15) begin
            io_h = (~ 7'h4f); // @[top.scala 16:14]
          end else begin
            if(when_top_l17) begin
              io_h = (~ 7'h66); // @[top.scala 18:14]
            end else begin
              if(when_top_l19) begin
                io_h = (~ 7'h6d); // @[top.scala 20:14]
              end else begin
                if(when_top_l21) begin
                  io_h = (~ 7'h7d); // @[top.scala 22:14]
                end else begin
                  if(when_top_l23) begin
                    io_h = (~ 7'h07); // @[top.scala 24:14]
                  end else begin
                    if(when_top_l25) begin
                      io_h = (~ 7'h7f); // @[top.scala 26:14]
                    end else begin
                      if(when_top_l27) begin
                        io_h = (~ 7'h6f); // @[top.scala 28:14]
                      end else begin
                        io_h = 7'h7f; // @[top.scala 30:14]
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

  assign when_top_l11 = (io_b == 4'b0001); // @[BaseType.scala 305:24]
  assign when_top_l13 = (io_b == 4'b0010); // @[BaseType.scala 305:24]
  assign when_top_l15 = (io_b == 4'b0011); // @[BaseType.scala 305:24]
  assign when_top_l17 = (io_b == 4'b0100); // @[BaseType.scala 305:24]
  assign when_top_l19 = (io_b == 4'b0101); // @[BaseType.scala 305:24]
  assign when_top_l21 = (io_b == 4'b0110); // @[BaseType.scala 305:24]
  assign when_top_l23 = (io_b == 4'b0111); // @[BaseType.scala 305:24]
  assign when_top_l25 = (io_b == 4'b1000); // @[BaseType.scala 305:24]
  assign when_top_l27 = (io_b == 4'b1001); // @[BaseType.scala 305:24]

endmodule
