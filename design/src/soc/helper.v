module iack_decoder(
    input wire [1:0] priority_select,
    input wire IACK,
    output reg [3:0] reset
);
always @ (IACK) begin
    case (priority_select)
        2'b00: begin
            if(IACK) begin
                reset <= 4'b0001;
                end 
            else begin
                reset <= 4'b0000;
                end
            end
        2'b01: begin
            if(IACK) begin
                reset <= 4'b0010;
                end
            else begin
                reset <= 4'b0000;
                end
            end
        2'b10: begin
            if(IACK) begin
                reset <= 4'b0100;
                end
            else begin
                reset <= 4'b0000;
                end
            end
        2'b11: begin
            if(IACK) begin
                reset <= 4'b1000;
                end
            else begin
                reset <= 4'b0000;
                end
            end
        default: reset <= 4'b0000;
    endcase
end
endmodule


module comparator_gt(
  input  wire [3:0] a,
  input  wire [3:0] b,
  output wire gt
);
  assign gt = (a > b) ? 1'b1 : 1'b0;
endmodule

module mux4 #(parameter WIDTH = 32) (
  input wire [1:0] sel,
  input wire [WIDTH-1:0] a,
  input wire [WIDTH-1:0] b,
  input wire [WIDTH-1:0] c,
  input wire [WIDTH-1:0] d,
  output reg [WIDTH-1:0] y
);
always @ (*)
begin
  case(sel)
    2'b00: y = a;
    2'b01: y = b;
    2'b10: y = c;
    default: y = d;
  endcase
end
endmodule

module demux4 #(parameter WIDTH = 32) (
  input wire [1:0] sel,
  input wire [WIDTH-1:0] y,
  output reg [WIDTH-1:0] a,
  output reg [WIDTH-1:0] b,
  output reg [WIDTH-1:0] c,
  output reg [WIDTH-1:0] d 
);
always @ (*)
begin
  case(sel)
    2'b00: a = y;
    2'b01: b = y;
    2'b10: c = y;
    default: d = y;
  endcase
end
endmodule

module mux8 #(parameter WIDTH = 32) (
  input wire [2:0] sel,
  input wire [WIDTH-1:0] a,
  input wire [WIDTH-1:0] b,
  input wire [WIDTH-1:0] c,
  input wire [WIDTH-1:0] d,
  input wire [WIDTH-1:0] e,
  input wire [WIDTH-1:0] f,
  input wire [WIDTH-1:0] g,
  input wire [WIDTH-1:0] h,
  output reg [WIDTH-1:0] y
);
always @ (*)
begin
  case(sel)
    3'b000: y = a;
    3'b001: y = b;
    3'b010: y = c;
    3'b011: y = d;
    3'b100: y = e;
    3'b101: y = f;
    3'b110: y = g;
    3'b111: y = h;
    default: y = h;
  endcase
end
endmodule

module multiplier_async (
    input  wire [31:0] A,
    input  wire [31:0] B,
    output wire [63:0] Y
);
    assign Y = A * B;
endmodule

module and_2_1 #(parameter w = 32)(
  input [w-1:0] in0, in1,
  output out
);
  assign out = in0 & in1;
endmodule

module dreg_enx # (parameter WIDTH = 32) (
  input wire clk,
  input wire rst,
  input wire enx,
  input wire [WIDTH-1:0] d,
  output reg [WIDTH-1:0] q
);
  always @ (posedge clk, posedge rst) begin
    if (rst) q <= 0;
    else if (enx) q <= q;
    else
    q <= d;
  end
endmodule

module dreg_en # (parameter WIDTH = 32) (
  input wire clk,
  input wire rst,
  input wire en,
  input wire [WIDTH-1:0] d,
  output reg [WIDTH-1:0] q
);

  initial begin
    q = 0;
  end
  always @ (posedge clk ) begin
    if (rst) q <= 0;
    else if (en) q <= d;
    else q <= q;
  end
endmodule

module dreg_clr # (parameter WIDTH = 32) (
  input wire clk,
  input wire rst,
  input wire clr,
  input wire [WIDTH-1:0] d,
  output reg [WIDTH-1:0] q
);
  always @ (posedge clk, posedge rst) begin
    if (rst)
    q <= 0;
    else if (clr) q <= 0;
    else
    q <= d;
  end
endmodule

module sr_reg(
  input set, rst, clk,
  output reg q
);

  initial begin
    q = 0;
  end

always @ (posedge clk, posedge rst)
  if (rst) q <= 1'b0;
  else if (set) q <= 1'b1;
  else q <= q;
endmodule

module UD_CNT_P(
  input  wire [3:0] D,
  input  wire       LD,
  input  wire       UD,
  input  wire       CE,
  input  wire       CLK,
  input  wire       RST,
  output reg  [3:0] Q
);
//  initial begin Q <= 4'b0; end
  always @ (posedge CLK, posedge RST) begin
         if  (RST)      Q <= 4'b0;
    else if  (LD & CE)  Q <= D;
    else if  (UD & CE)  Q <= Q + 1;
    else if (~UD & CE)  Q <= Q - 1;
    else                Q <= Q;
  end
endmodule
