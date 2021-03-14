module dreg # (parameter WIDTH = 32) (
        input  wire             clk,
        input  wire             rst,
        input  wire [WIDTH-1:0] d,
        output reg  [WIDTH-1:0] q
    );

    always @ (posedge clk, posedge rst) begin
        if (rst) q <= 0;
        else     q <= d;
    end
endmodule

module dreg_we # (parameter WIDTH=32) (
        input wire clk,
        input wire rst,
        input wire we,
        input wire [WIDTH-1:0] d,
        output reg [WIDTH-1:0] q
    );
    
    always @ (posedge clk, posedge rst) begin
        if(rst) q <=0;
        else if(we) q <= d;
    end
endmodule

