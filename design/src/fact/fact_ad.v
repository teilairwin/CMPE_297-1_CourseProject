module fact_ad(
  input wire [1:0] A,
  input wire WE,
  output reg WE1, WE2,
  output wire [1:0] RdSel
);
  always @ (*) begin
    case (A)
      // n register write enable
      2'b00: begin
      WE1 = WE;
      WE2 = 1'b0;
      end
      // go register write enable
      2'b01: begin
      WE1 = 1'b0;
      WE2 = WE;
      end
      default: begin
      WE1 = 1'b0;
      WE2 = 1'b0;
      end
    endcase
  end
  assign RdSel = A;
endmodule
