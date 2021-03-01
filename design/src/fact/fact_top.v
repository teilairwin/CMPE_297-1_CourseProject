module fact_top(
  input [1:0] A,
  input WE, rst, clk,
  input [3:0] WD,
  output [31:0] RD
);
  wire WE1, WE2, Go, GoPulseCmb, GoPulse, Err, Done, ResDone, ResErr;
  wire [1:0] RdSel;
  wire [3:0] n;
  wire [31:0] nf, Result;

  fact_ad fact_ad(
    .A(A),
    .WE(WE),
    .WE1(WE1),
    .WE2(WE2),
    .RdSel(RdSel)
  );

  fact_reg #4 n_reg(
    .clk(clk),
    .rst(rst),
    .load_reg(WE1),
    .d(WD),
    .q(n)
  );

  fact_reg #1 go_reg(
    .clk(clk),
    .rst(rst),
    .load_reg(WE2),
    .d(WD[0]),
    .q(Go)
  );

  and_2_1 #1 and_2_1(
    .in0(WD[0]),
    .in1(WE2),
    .out(GoPulseCmb)
  );

  fact_reg #1 go_pulse_reg(
    .clk(clk),
    .rst(rst),
    .load_reg(1'b1),
    .d(GoPulseCmb),
    .q(GoPulse)
  );

  wire [1:0] dont_use;

  fact fact(
    .go(GoPulse),
    .rst(rst),
    .clk(clk),
    .in(n),
    .Error(Err),
    .Done(Done),
    .CS(dont_use),
    .result(nf)
  );

  sr_reg res_done_reg(
    .set(Done),
    .rst(GoPulseCmb),
    .clk(clk),
    .q(ResDone)
  );

  sr_reg res_err_reg(
    .set(Err),
    .rst(GoPulseCmb),
    .clk(clk),
    .q(ResErr)
  );

  fact_reg nf_reg(
    .clk(clk),
    .rst(rst),
    .load_reg(Done),
    .d(nf),
    .q(Result)
  );

  mux4 #32 mux_4_1(
    .sel(RdSel),
    .a({28'b0, n}),
    .b({31'b0, Go}),
    .c({30'b0, ResErr, ResDone}),
    .d(Result),
    .y(RD)
  );

endmodule
