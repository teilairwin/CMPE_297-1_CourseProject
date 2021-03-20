`timescale 1ns / 1ps

module tb_system();
    reg         clk, rst;
    reg         Sel;
    reg [3:0]   n;

    wire        we_mm;
    wire [31:0] pc_current;
    wire [31:0] instrE;
    wire [31:0] instrP;
    wire [31:0] alu_out;
    wire [31:0] wd_mm;
    wire [31:0] rd_mm;
    wire [31:0] rd3;

    system system (
        .clk        (clk),
        .rst        (rst),
        .ra3        (ra3),
        .we_mm      (we_mm),
        .pc_current (pc_current),
        .instrE     (instrE),
        .instrP     (instrP),
        .alu_out    (alu_out),
        .wd_mm      (wd_mm),
        .rd_mm      (rd_mm),
        .rd3        (rd3)
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
