module fact_datapath(
  input wire clk,
  input wire rst,
  input wire [3:0] in,
  input wire [5:0] control_signals,
  output wire cnt_out,
  output wire in_gt_12,
  output wire [31:0] result
);
  //control signals
  wire cnt_ld, cnt_ud, cnt_ce;
  wire mux_s0, mux_s1;
  wire en_D;

  assign en_D = control_signals[5],
       mux_s0 = control_signals[4],
       mux_s1 = control_signals[3],
       cnt_ld = control_signals[2],
       cnt_ud = control_signals[1],
       cnt_ce = control_signals[0];

  //internal wires
  wire [3:0] counter_out;
  wire [31:0] Dr;  //output from Mux_0
  wire [31:0] in2;  //output from D_reg
  wire [31:0] M_out; //output from Mult module

  //assign cnt_out = (counter_out == 4'b0001)? 1:0;
  assign cnt_out = (counter_out < 2)? 1:0;

  //counter
  UD_CNT_P COUNTER(
    .D (in),
    .LD (cnt_ld),
    .UD (cnt_ud),
    .CE (cnt_ce),
    .CLK (clk),
    .RST (rst),
    .Q (counter_out)
  );

  //Mux_0 inputting to D_reg
  mux2 #(32) MUX0(
    .sel  (mux_s0),
    .b  (M_out),
    .a  (1),
    .y  (Dr)
  );

  //Mux_1 controlling output
  mux2 #(32) MUX1(
    .sel  (mux_s1),
    .b  (in2),
    .a  (0),
    .y  (result)
  );

  //D_reg
  dreg_en dreg(
    .clk (clk),
    .rst (rst),
    .en (en_D),
    .d (Dr),
    .q (in2)
  );

  //Mult module
  multiplier_async mult_mod(
    .A ({28'b0, counter_out}),
    .B (in2),
    .Y (M_out)
  );

  //Comparator module
  comparator_gt cmp1(
    .a (in),
    .b (4'd12),
    .gt (in_gt_12)
  );
endmodule
