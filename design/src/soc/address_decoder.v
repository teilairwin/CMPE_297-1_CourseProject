`timescale 1ns / 1ps
module address_decoder(
  input WE,
  input [31:0] A,
  output wire WE1, WE2, WEM,
  output wire [1:0] RdSel
);
// WE1, WE2, WEM, RdSel
reg [4:0] ctrl_signals;

  always @ (*) begin
    casex (A[11:8])
      // select factorial accelerator
      4'h8:    ctrl_signals = WE ? 5'b1_0_0_10 : 5'b0_0_0_10;
      // select gpio
      4'h9:    ctrl_signals = WE ? 5'b0_1_0_11 : 5'b0_0_0_11;
      // select data memory
      default: ctrl_signals = (A[8:4] >= 5'b0_0000
                                && A[8:4] < 5'b1_0000
                                && WE) ? 5'b0_0_1_00 : 5'b0_0_0_00;
    endcase
  end

  assign {WE1, WE2, WEM, RdSel} = ctrl_signals;

endmodule

module address_decoder4(
  input WE,
  input [31:0] A,
  output wire WE1, WE2, WEM0, WEM1, WEM2, WEM3,
  output wire [1:0] RdSel
);
// WE1, WE2, WEM, RdSel
reg [4:0] ctrl_signals;

  always @ (*) begin
    casex (A[11:8])
      // select factorial accelerator
      4'h8:    ctrl_signals = WE ? 5'b1_0_0_10 : 5'b0_0_0_10;
      // select gpio
      4'h9:    ctrl_signals = WE ? 5'b0_1_0_11 : 5'b0_0_0_11;
      // select data memory
      default: ctrl_signals = (A[8:4] >= 5'b0_0000
                                && A[8:4] < 5'b1_0000
                                && WE) ? 5'b0_0_1_00 : 5'b0_0_0_00;
    endcase
  end

  assign {WE1, WE2, WEM, RdSel} = ctrl_signals;

endmodule
