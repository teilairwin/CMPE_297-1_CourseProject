module fact_reg #(parameter w = 32) (
  input wire clk, rst, load_reg,
  input wire [w-1:0] d,
  output reg [w-1:0] q
);
  always @ (posedge clk, posedge rst) begin
    if (rst) q <= 0;
    else if (load_reg) q <= d;
    else q <= q;
  end
endmodule
