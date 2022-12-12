// Generator : SpinalHDL v1.8.0    git head : 4e3563a282582b41f4eaafc503787757251d23ea
// Component : top

`timescale 1ns/1ps

module top (
  output     [6:0]    ldo1,
  output     [6:0]    ldo2,
  input               clk,
  input               reset
);

  wire       [3:0]    led1_io_b;
  wire       [3:0]    led2_io_b;
  wire       [6:0]    led1_io_h;
  wire       [6:0]    led2_io_h;
  reg        [7:0]    data;
  wire                x;

  Bcd7seg_1 led1 (
    .io_b (led1_io_b[3:0]), //i
    .io_h (led1_io_h[6:0])  //o
  );
  Bcd7seg_1 led2 (
    .io_b (led2_io_b[3:0]), //i
    .io_h (led2_io_h[6:0])  //o
  );
  assign x = (((data[4] || data[3]) || data[2]) || data[0]); // @[BaseType.scala 305:24]
  assign led1_io_b = data[3 : 0]; // @[top.scala 64:15]
  assign led2_io_b = data[7 : 4]; // @[top.scala 65:15]
  assign ldo1 = led1_io_h; // @[top.scala 66:13]
  assign ldo2 = led2_io_h; // @[top.scala 67:13]
  always @(posedge clk or posedge reset) begin
    if(reset) begin
      data <= 8'h01; // @[Data.scala 400:33]
    end else begin
      data <= (data >>> 1); // @[top.scala 58:10]
      data[7] <= x; // @[top.scala 59:13]
    end
  end


endmodule

//Bcd7seg_1 replaced by Bcd7seg_1

module Bcd7seg_1 (
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
  wire                when_top_l29;
  wire                when_top_l31;
  wire                when_top_l33;
  wire                when_top_l35;
  wire                when_top_l37;
  wire                when_top_l39;

  assign when_top_l9 = (io_b == 4'b0000); // @[BaseType.scala 305:24]
  always @(*) begin
    if(when_top_l9) begin
      io_h = 7'h40; // @[top.scala 10:14]
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
                        if(when_top_l29) begin
                          io_h = (~ 7'h77); // @[top.scala 30:14]
                        end else begin
                          if(when_top_l31) begin
                            io_h = (~ 7'h7c); // @[top.scala 32:14]
                          end else begin
                            if(when_top_l33) begin
                              io_h = (~ 7'h39); // @[top.scala 34:14]
                            end else begin
                              if(when_top_l35) begin
                                io_h = (~ 7'h5e); // @[top.scala 36:14]
                              end else begin
                                if(when_top_l37) begin
                                  io_h = (~ 7'h79); // @[top.scala 38:14]
                                end else begin
                                  if(when_top_l39) begin
                                    io_h = (~ 7'h71); // @[top.scala 40:14]
                                  end else begin
                                    io_h = 7'h7f; // @[top.scala 42:14]
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

  assign when_top_l11 = (io_b == 4'b0001); // @[BaseType.scala 305:24]
  assign when_top_l13 = (io_b == 4'b0010); // @[BaseType.scala 305:24]
  assign when_top_l15 = (io_b == 4'b0011); // @[BaseType.scala 305:24]
  assign when_top_l17 = (io_b == 4'b0100); // @[BaseType.scala 305:24]
  assign when_top_l19 = (io_b == 4'b0101); // @[BaseType.scala 305:24]
  assign when_top_l21 = (io_b == 4'b0110); // @[BaseType.scala 305:24]
  assign when_top_l23 = (io_b == 4'b0111); // @[BaseType.scala 305:24]
  assign when_top_l25 = (io_b == 4'b1000); // @[BaseType.scala 305:24]
  assign when_top_l27 = (io_b == 4'b1001); // @[BaseType.scala 305:24]
  assign when_top_l29 = (io_b == 4'b1010); // @[BaseType.scala 305:24]
  assign when_top_l31 = (io_b == 4'b1011); // @[BaseType.scala 305:24]
  assign when_top_l33 = (io_b == 4'b1100); // @[BaseType.scala 305:24]
  assign when_top_l35 = (io_b == 4'b1101); // @[BaseType.scala 305:24]
  assign when_top_l37 = (io_b == 4'b1110); // @[BaseType.scala 305:24]
  assign when_top_l39 = (io_b == 4'b1111); // @[BaseType.scala 305:24]

endmodule
