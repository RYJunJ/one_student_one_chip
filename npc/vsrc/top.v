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
  output              VGA_VSYNC,
  output              VGA_HSYNC,
  output              VGA_BLANK_N,
  output     [7:0]    VGA_R,
  output     [7:0]    VGA_G,
  output     [7:0]    VGA_B,
  input               reset,
  input               clk
);

  wire       [3:0]    led1_io_b;
  wire       [3:0]    led2_io_b;
  wire       [3:0]    led3_io_b;
  wire       [3:0]    led4_io_b;
  wire       [3:0]    led5_io_b;
  wire       [3:0]    led6_io_b;
  wire       [8:0]    vmem_1_v_addr;
  wire       [7:0]    keyboard_num;
  wire                keyboard_ena;
  wire       [6:0]    led1_io_h;
  wire       [6:0]    led2_io_h;
  wire       [6:0]    led3_io_h;
  wire       [6:0]    led4_io_h;
  wire       [6:0]    led5_io_h;
  wire       [6:0]    led6_io_h;
  wire       [7:0]    rom_data;
  wire       [9:0]    vga_h_addr;
  wire       [9:0]    vga_v_addr;
  wire                vga_hsync_1;
  wire                vga_vsync_1;
  wire                vga_valid;
  wire       [7:0]    vga_vga_r;
  wire       [7:0]    vga_vga_g;
  wire       [7:0]    vga_vga_b;
  wire       [23:0]   vmem_1_vga_data;
  wire       [7:0]    _zz_io_b;
  wire       [7:0]    _zz_io_b_1;
  reg        [7:0]    cnt;
  reg                 chnge;
  wire       [9:0]    h_addr;
  wire       [9:0]    v_addr;
  wire       [23:0]   vga_data;
  wire                when_top_l249;

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
  vga_ctrl vga (
    .pclk     (clk            ), //i
    .reset    (reset          ), //i
    .vga_data (vga_data[23:0] ), //i
    .h_addr   (vga_h_addr[9:0]), //o
    .v_addr   (vga_v_addr[9:0]), //o
    .hsync    (vga_hsync_1    ), //o
    .vsync    (vga_vsync_1    ), //o
    .valid    (vga_valid      ), //o
    .vga_r    (vga_vga_r[7:0] ), //o
    .vga_g    (vga_vga_g[7:0] ), //o
    .vga_b    (vga_vga_b[7:0] )  //o
  );
  vmem vmem_1 (
    .h_addr   (h_addr[9:0]          ), //i
    .v_addr   (vmem_1_v_addr[8:0]   ), //i
    .vga_data (vmem_1_vga_data[23:0])  //o
  );
  assign when_top_l249 = ((chnge == 1'b1) && (keyboard_ena == 1'b0)); // @[BaseType.scala 305:24]
  assign led1_io_b = keyboard_num[3 : 0]; // @[top.scala 257:15]
  assign led2_io_b = keyboard_num[7 : 4]; // @[top.scala 259:15]
  assign led3_io_b = rom_data[3 : 0]; // @[top.scala 261:15]
  assign led4_io_b = rom_data[7 : 4]; // @[top.scala 263:15]
  assign led5_io_b = _zz_io_b[3 : 0]; // @[top.scala 265:15]
  assign led6_io_b = _zz_io_b_1[7 : 4]; // @[top.scala 267:15]
  assign ldo1 = led1_io_h; // @[top.scala 270:13]
  assign ldo2 = led2_io_h; // @[top.scala 271:13]
  assign ldo3 = led3_io_h; // @[top.scala 272:13]
  assign ldo4 = led4_io_h; // @[top.scala 273:13]
  assign ldo5 = led5_io_h; // @[top.scala 274:13]
  assign ldo6 = led6_io_h; // @[top.scala 275:13]
  assign h_addr = vga_h_addr; // @[top.scala 278:12]
  assign v_addr = vga_v_addr; // @[top.scala 279:12]
  assign VGA_HSYNC = vga_hsync_1; // @[top.scala 280:18]
  assign VGA_VSYNC = vga_vsync_1; // @[top.scala 281:18]
  assign VGA_BLANK_N = vga_valid; // @[top.scala 282:20]
  assign VGA_R = vga_vga_r; // @[top.scala 283:14]
  assign VGA_G = vga_vga_g; // @[top.scala 284:14]
  assign VGA_B = vga_vga_b; // @[top.scala 285:14]
  assign vmem_1_v_addr = v_addr[8 : 0]; // @[top.scala 287:20]
  assign vga_data = vmem_1_vga_data; // @[top.scala 288:14]
  always @(posedge clk) begin
    chnge <= keyboard_ena; // @[top.scala 248:11]
    if(when_top_l249) begin
      cnt <= (cnt + 8'h01); // @[top.scala 250:13]
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
        data = 8'h30; // @[top.scala 101:21]
      end
      8'h16 : begin
        data = 8'h31; // @[top.scala 104:21]
      end
      8'h1e : begin
        data = 8'h32; // @[top.scala 107:21]
      end
      8'h26 : begin
        data = 8'h33; // @[top.scala 110:21]
      end
      8'h25 : begin
        data = 8'h34; // @[top.scala 113:21]
      end
      8'h2e : begin
        data = 8'h35; // @[top.scala 116:21]
      end
      8'h36 : begin
        data = 8'h36; // @[top.scala 119:21]
      end
      8'h3d : begin
        data = 8'h37; // @[top.scala 122:21]
      end
      8'h3e : begin
        data = 8'h38; // @[top.scala 125:21]
      end
      8'h46 : begin
        data = 8'h39; // @[top.scala 128:21]
      end
      8'h15 : begin
        data = 8'h51; // @[top.scala 131:21]
      end
      8'h1d : begin
        data = 8'h57; // @[top.scala 134:21]
      end
      8'h24 : begin
        data = 8'h45; // @[top.scala 137:21]
      end
      8'h2d : begin
        data = 8'h52; // @[top.scala 140:21]
      end
      8'h2c : begin
        data = 8'h54; // @[top.scala 143:21]
      end
      8'h35 : begin
        data = 8'h59; // @[top.scala 146:21]
      end
      8'h3c : begin
        data = 8'h55; // @[top.scala 149:21]
      end
      8'h43 : begin
        data = 8'h49; // @[top.scala 152:21]
      end
      8'h44 : begin
        data = 8'h4f; // @[top.scala 155:21]
      end
      8'h4d : begin
        data = 8'h50; // @[top.scala 158:21]
      end
      8'h1c : begin
        data = 8'h41; // @[top.scala 161:21]
      end
      8'h1b : begin
        data = 8'h53; // @[top.scala 164:21]
      end
      8'h23 : begin
        data = 8'h44; // @[top.scala 167:21]
      end
      8'h2b : begin
        data = 8'h46; // @[top.scala 170:21]
      end
      8'h34 : begin
        data = 8'h47; // @[top.scala 173:21]
      end
      8'h33 : begin
        data = 8'h48; // @[top.scala 176:21]
      end
      8'h3b : begin
        data = 8'h4a; // @[top.scala 179:21]
      end
      8'h42 : begin
        data = 8'h4b; // @[top.scala 182:21]
      end
      8'h4b : begin
        data = 8'h4c; // @[top.scala 185:21]
      end
      8'h1a : begin
        data = 8'h5a; // @[top.scala 188:21]
      end
      8'h22 : begin
        data = 8'h58; // @[top.scala 191:21]
      end
      8'h21 : begin
        data = 8'h43; // @[top.scala 194:21]
      end
      8'h2a : begin
        data = 8'h56; // @[top.scala 197:21]
      end
      8'h32 : begin
        data = 8'h42; // @[top.scala 200:21]
      end
      8'h31 : begin
        data = 8'h4e; // @[top.scala 203:21]
      end
      8'h3a : begin
        data = 8'h4d; // @[top.scala 206:21]
      end
      default : begin
        data = 8'h0; // @[top.scala 209:21]
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

  wire                when_top_l12;
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
  wire                when_top_l45;

  assign when_top_l12 = (io_ena == 1'b0); // @[BaseType.scala 305:24]
  always @(*) begin
    if(when_top_l12) begin
      io_h = 7'h7f; // @[top.scala 13:14]
    end else begin
      if(when_top_l15) begin
        io_h = 7'h40; // @[top.scala 16:18]
      end else begin
        if(when_top_l17) begin
          io_h = (~ 7'h06); // @[top.scala 18:18]
        end else begin
          if(when_top_l19) begin
            io_h = (~ 7'h5b); // @[top.scala 20:18]
          end else begin
            if(when_top_l21) begin
              io_h = (~ 7'h4f); // @[top.scala 22:18]
            end else begin
              if(when_top_l23) begin
                io_h = (~ 7'h66); // @[top.scala 24:18]
              end else begin
                if(when_top_l25) begin
                  io_h = (~ 7'h6d); // @[top.scala 26:18]
                end else begin
                  if(when_top_l27) begin
                    io_h = (~ 7'h7d); // @[top.scala 28:18]
                  end else begin
                    if(when_top_l29) begin
                      io_h = (~ 7'h07); // @[top.scala 30:18]
                    end else begin
                      if(when_top_l31) begin
                        io_h = (~ 7'h7f); // @[top.scala 32:18]
                      end else begin
                        if(when_top_l33) begin
                          io_h = (~ 7'h6f); // @[top.scala 34:18]
                        end else begin
                          if(when_top_l35) begin
                            io_h = (~ 7'h77); // @[top.scala 36:18]
                          end else begin
                            if(when_top_l37) begin
                              io_h = (~ 7'h7c); // @[top.scala 38:18]
                            end else begin
                              if(when_top_l39) begin
                                io_h = (~ 7'h39); // @[top.scala 40:18]
                              end else begin
                                if(when_top_l41) begin
                                  io_h = (~ 7'h5e); // @[top.scala 42:18]
                                end else begin
                                  if(when_top_l43) begin
                                    io_h = (~ 7'h79); // @[top.scala 44:18]
                                  end else begin
                                    if(when_top_l45) begin
                                      io_h = (~ 7'h71); // @[top.scala 46:18]
                                    end else begin
                                      io_h = 7'h7f; // @[top.scala 48:18]
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

  assign when_top_l15 = (io_b == 4'b0000); // @[BaseType.scala 305:24]
  assign when_top_l17 = (io_b == 4'b0001); // @[BaseType.scala 305:24]
  assign when_top_l19 = (io_b == 4'b0010); // @[BaseType.scala 305:24]
  assign when_top_l21 = (io_b == 4'b0011); // @[BaseType.scala 305:24]
  assign when_top_l23 = (io_b == 4'b0100); // @[BaseType.scala 305:24]
  assign when_top_l25 = (io_b == 4'b0101); // @[BaseType.scala 305:24]
  assign when_top_l27 = (io_b == 4'b0110); // @[BaseType.scala 305:24]
  assign when_top_l29 = (io_b == 4'b0111); // @[BaseType.scala 305:24]
  assign when_top_l31 = (io_b == 4'b1000); // @[BaseType.scala 305:24]
  assign when_top_l33 = (io_b == 4'b1001); // @[BaseType.scala 305:24]
  assign when_top_l35 = (io_b == 4'b1010); // @[BaseType.scala 305:24]
  assign when_top_l37 = (io_b == 4'b1011); // @[BaseType.scala 305:24]
  assign when_top_l39 = (io_b == 4'b1100); // @[BaseType.scala 305:24]
  assign when_top_l41 = (io_b == 4'b1101); // @[BaseType.scala 305:24]
  assign when_top_l43 = (io_b == 4'b1110); // @[BaseType.scala 305:24]
  assign when_top_l45 = (io_b == 4'b1111); // @[BaseType.scala 305:24]

endmodule
