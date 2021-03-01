module fact(
  input wire clk,
  input wire rst,
  input wire go,
  input wire [3:0] in,
  output wire Done,
  output wire Error,
  output wire [1:0] CS,
  output wire [31:0] result
);
  wire  cnt_lt_2, in_gt_12;
  wire  [5:0] ctrl_signals;

  fact_controlunit CU(
    .clk   (clk),
    .rst   (rst),
    .go   (go),
    .Done (Done),
    .Error (Error),
    .CS   (CS),
    .cnt_lt_2 (cnt_lt_2),
    .in_gt_12 (in_gt_12),
    .control_signals   (ctrl_signals)
  );

  fact_datapath DP(
    .clk   (clk),
    .rst   (rst),
    .in   (in),
    .control_signals   (ctrl_signals),
    .cnt_out  (cnt_lt_2),
    .in_gt_12 (in_gt_12),
    .result (result)
  );
endmodule
