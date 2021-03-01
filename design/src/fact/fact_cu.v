module fact_controlunit(
  input wire clk,
  input wire rst,
  input wire go,
  output reg Done,
  output reg Error,
  output reg [1:0] CS,
  /* 5 KHz clock */
  // status signals (OUTPUT)
  input wire cnt_lt_2,
  input wire in_gt_12,
  // control signals (INPUT)
  output reg [5:0] control_signals
);
  parameter
  S0 = 3'b00, // IDLE
  S1 = 3'b01, // LOAD
  S2 = 3'b10, // MULTIPLICATION
  S3 = 3'b11, // DONE

  // output code en_D, mux_s0, mux_s1, cnt_ld, cnt_ud, cnt_ce
  OUT0   = 6'b000000,
  OUT1   = 6'b100101,
  OUT2_T = 6'b000000,
  OUT2_F = 6'b110001,
  OUT3   = 6'b001000;
  reg [1:0] NS;

  initial
  begin
    CS = S0;
    Error = 0;
    control_signals = OUT0;
  end
  // NEXT-STATE LOGIC (Combinational)
  always @(CS, go, cnt_lt_2, in_gt_12)
  begin
    case(CS)
      S0: begin
        control_signals = OUT0;
        Done = 0;
        Error = 0;
        if (!go) NS = S0;
        else NS = S1;
      end
      S1: begin
        control_signals = OUT1;
        if (in_gt_12)
        begin
          Error = 1;
          Done = 0;
          NS = S0;
        end
        else
        begin
          NS = S2;
        end
      end
      S2: begin
        if (cnt_lt_2)
        begin
          Done = 0;
          Error = 0;
          control_signals = OUT2_T;
          NS = S3;
        end
        else
        begin
          Done = 0;
          Error = 0;
          control_signals = OUT2_F;
          NS = S2;
        end
      end
      S3: begin
        control_signals = OUT3;
        Done = 1;
        NS = S0;
      end
    endcase
  end
  // STATE REGISTER (Sequential)
  always @(posedge clk, posedge rst)
  begin
    if(rst) CS <= S0;
    else CS <= NS;
  end
endmodule
