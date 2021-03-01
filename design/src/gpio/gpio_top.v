module gpio_top(
  input         clk,
  input         rst,
  input   [1:0] A,
  input         WE,
  input  [31:0] gpI1,
  input  [31:0] gpI2,
  input  [31:0] WD,
  output [31:0] RD,
  output [31:0] gpO1,
  output [31:0] gpO2
);
  wire WE1, WE2;
  wire [1:0] RdSel;

  gpio_ad decoder(
    .A     (A),
    .WE    (WE),
    .WE1   (WE1),
    .WE2   (WE2),
    .RdSel (RdSel)
  );

  dreg_en gpO1_reg (
    .clk  (clk),
    .rst   (rst),
    .d   (WD),
    .q   (gpO1),
    .en   (WE1)
  );

  dreg_en gpO2_reg (
    .clk  (clk),
    .rst  (rst),
    .d    (WD),
    .q    (gpO2),
    .en   (WE2)
  );

  mux4 #32 r_mux (
    .a   (gpI1),
    .b   (gpI2),
    .c   (gpO1),
    .d   (gpO2),
    .sel (RdSel),
    .y   (RD)
  );

endmodule
