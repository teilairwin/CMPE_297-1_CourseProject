/* 
`timescale 1ns / 1ps

module _7seg_cap(
    input sysclk,
    input  [ 7:0] LEDOUT,
    input  [ 3:0] LEDSEL,
    output [31:0] LEDOUT_all
);
    
reg  [31:0] x, y1, y2, running_reg;
wire [31:0] LEDOUT_all;
reg   [1:0] LEDSEL_bin;
wire  [4:0] sh_amt;

initial begin
    x = 0;
    y1 = 0;
    y2 = 0;
    running_reg = 0;
    LEDSEL_bin = 0;
end

always@ (posedge sysclk)
begin
    x = LEDOUT << sh_amt;
    y1 = ~(8'hff << sh_amt);
    y2 = running_reg & y1;
    running_reg = x | y2;
end


// one_hot_to_bin
always@ (LEDSEL)
begin
case (LEDSEL)
    4'b1110: LEDSEL_bin = 2'd0;
    4'b1101: LEDSEL_bin = 2'd1;
    4'b1011: LEDSEL_bin = 2'd2;
    4'b0111: LEDSEL_bin = 2'd3;
    default: LEDSEL_bin = 2'd0;
endcase
end

assign sh_amt = LEDSEL_bin << 3;
assign LEDOUT_all = ~running_reg;

endmodule
*/
