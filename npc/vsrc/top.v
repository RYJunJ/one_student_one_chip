// Generator : SpinalHDL v1.7.3    git head : aeaeece704fe43c766e0d36a93f2ecbb8a9f2003
// Component : MyTopLevel
// Git hash  : 7334c130a3a82f478a87ff2dd22b0fae99c8e78c

`timescale 1ns/1ps

module top (
  input      [7:0]    min,
  output reg [2:0]    mout,
  output     [6:0]    ldo
);

  wire       [3:0]    led_io_b;
  wire       [6:0]    led_io_h;
  wire       [2:0]    _zz_io_b;
  wire                when_MyTopLevel_l46;
  wire                when_MyTopLevel_l46_1;
  wire                when_MyTopLevel_l46_2;
  wire                when_MyTopLevel_l46_3;
  wire                when_MyTopLevel_l46_4;
  wire                when_MyTopLevel_l46_5;
  wire                when_MyTopLevel_l46_6;
  wire                when_MyTopLevel_l46_7;

  assign _zz_io_b = mout;
  Bcd7seg led (
    .io_b (led_io_b[3:0]), //i
    .io_h (led_io_h[6:0])  //o
  );
  always @(*) begin
    mout = 3'b000;
    if(when_MyTopLevel_l46) begin
      mout = 3'b111;
    end
    if(when_MyTopLevel_l46_1) begin
      mout = 3'b110;
    end
    if(when_MyTopLevel_l46_2) begin
      mout = 3'b101;
    end
    if(when_MyTopLevel_l46_3) begin
      mout = 3'b100;
    end
    if(when_MyTopLevel_l46_4) begin
      mout = 3'b011;
    end
    if(when_MyTopLevel_l46_5) begin
      mout = 3'b010;
    end
    if(when_MyTopLevel_l46_6) begin
      mout = 3'b001;
    end
    if(when_MyTopLevel_l46_7) begin
      mout = 3'b000;
    end
  end

  assign when_MyTopLevel_l46 = min[7];
  assign when_MyTopLevel_l46_1 = min[6];
  assign when_MyTopLevel_l46_2 = min[5];
  assign when_MyTopLevel_l46_3 = min[4];
  assign when_MyTopLevel_l46_4 = min[3];
  assign when_MyTopLevel_l46_5 = min[2];
  assign when_MyTopLevel_l46_6 = min[1];
  assign when_MyTopLevel_l46_7 = min[0];
  assign led_io_b = {1'd0, _zz_io_b};
  assign ldo = led_io_h;

endmodule

module Bcd7seg (
  input      [3:0]    io_b,
  output reg [6:0]    io_h
);

  wire                when_MyTopLevel_l11;
  wire                when_MyTopLevel_l13;
  wire                when_MyTopLevel_l15;
  wire                when_MyTopLevel_l17;
  wire                when_MyTopLevel_l19;
  wire                when_MyTopLevel_l21;
  wire                when_MyTopLevel_l23;
  wire                when_MyTopLevel_l25;
  wire                when_MyTopLevel_l27;
  wire                when_MyTopLevel_l29;

  assign when_MyTopLevel_l11 = (io_b == 4'b0000);
  always @(*) begin
    if(when_MyTopLevel_l11) begin
      io_h = 7'h0;
    end else begin
      if(when_MyTopLevel_l13) begin
        io_h = 7'h06;
      end else begin
        if(when_MyTopLevel_l15) begin
          io_h = 7'h5b;
        end else begin
          if(when_MyTopLevel_l17) begin
            io_h = 7'h4f;
          end else begin
            if(when_MyTopLevel_l19) begin
              io_h = 7'h66;
            end else begin
              if(when_MyTopLevel_l21) begin
                io_h = 7'h6d;
              end else begin
                if(when_MyTopLevel_l23) begin
                  io_h = 7'h7d;
                end else begin
                  if(when_MyTopLevel_l25) begin
                    io_h = 7'h07;
                  end else begin
                    if(when_MyTopLevel_l27) begin
                      io_h = 7'h7f;
                    end else begin
                      if(when_MyTopLevel_l29) begin
                        io_h = 7'h6f;
                      end else begin
                        io_h = 7'h3f;
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

  assign when_MyTopLevel_l13 = (io_b == 4'b0001);
  assign when_MyTopLevel_l15 = (io_b == 4'b0010);
  assign when_MyTopLevel_l17 = (io_b == 4'b0011);
  assign when_MyTopLevel_l19 = (io_b == 4'b0100);
  assign when_MyTopLevel_l21 = (io_b == 4'b0101);
  assign when_MyTopLevel_l23 = (io_b == 4'b0110);
  assign when_MyTopLevel_l25 = (io_b == 4'b0111);
  assign when_MyTopLevel_l27 = (io_b == 4'b1000);
  assign when_MyTopLevel_l29 = (io_b == 4'b1001);

endmodule
