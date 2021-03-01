module gpio_ad(
  input  [1:0] A,
  input   wire WE,
  output  wire WE1,
  output  wire WE2,
  output [1:0] RdSel
);
  assign WE1 = (A[1] == 0)? 0 : WE & (A[0]==0);
  assign WE2 = (A[1] == 0)? 0 : WE & (A[0]==1);
  assign RdSel = A;
endmodule
