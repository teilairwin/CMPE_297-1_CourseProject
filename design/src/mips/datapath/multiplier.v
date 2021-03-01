module multiplier (
  input wire  [31:0]  A,
  input wire  [31:0]  B,
  input wire          en,
  output reg  [63:0]  Y
);
  always @ (A, B, en)
  begin
    if (en) Y = A * B;
  end
endmodule
