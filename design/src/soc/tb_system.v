`timescale 1ns / 1ps

module tb_system();
    reg clk, rst;
    reg Sel;
    reg [3:0] n;
    wire dispSe;
    wire factErr;
    
    wire [31:0] gpI1;
    wire [31:0] gpO1;
    wire [31:0] gpO2;
    
    assign gpI1 = {27'b0, Sel, n[3:0]};
    assign dispSe = gpO1[1];
    assign factErr = gpO1[0];

    system system (
        .clk(clk),
        .rst(rst),
        .gpI1(gpI1),
        .gpI2(gpO1),
        .gpO1(gpO1),
        .gpO2(gpO2)
    );
    
    always begin
        #5 clk = ~clk;
    end
    initial begin
        clk = 0; rst = 1;
        n = 5; Sel = 0;
        #20 rst = 0;
        #300 n = 3;
        #500 $finish;
    end
endmodule
