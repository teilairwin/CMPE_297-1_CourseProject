module gpio_top4(
  input         clk,
  input         rst,
  input   [1:0] A,
  input         WE,
  input  [31:0] gpI1,
  input  [31:0] gpI2,
  input  [31:0] WD0,
  input  [31:0] WD1,
  input  [31:0] WD2,
  input  [31:0] WD3,
  output [31:0] RD0,
  output [31:0] RD1,
  output [31:0] RD2,
  output [31:0] RD3,
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

  dreg_en gpO1_reg0 (
    .clk  (clk),
    .rst  (rst),
    .d    (WD0),
    .q    (gpO1),
    .en   (WE1)
  );

  dreg_en gpO1_reg1 (
    .clk  (clk),
    .rst  (rst),
    .d    (WD1),
    .q    (gpO1),
    .en   (WE1)
  );

  dreg_en gpO1_reg2 (
    .clk  (clk),
    .rst  (rst),
    .d    (WD2),
    .q    (gpO1),
    .en   (WE1)
  );

  dreg_en gpO1_reg3 (
    .clk  (clk),
    .rst  (rst),
    .d    (WD3),
    .q    (gpO1),
    .en   (WE1)
  );

  dreg_en gpO2_reg0 (
    .clk  (clk),
    .rst  (rst),
    .d    (WD0),
    .q    (gpO2),
    .en   (WE2)
  );

  dreg_en gpO2_reg1 (
    .clk  (clk),
    .rst  (rst),
    .d    (WD1),
    .q    (gpO2),
    .en   (WE2)
  );

  dreg_en gpO2_reg2 (
    .clk  (clk),
    .rst  (rst),
    .d    (WD2),
    .q    (gpO2),
    .en   (WE2)
  );

  dreg_en gpO2_reg3 (
    .clk  (clk),
    .rst  (rst),
    .d    (WD3),
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
