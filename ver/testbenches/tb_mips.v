`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/30/2021 11:43:02 PM
// Design Name: 
// Module Name: tb_mips
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module tb_mips();
    reg clk,rst;
    
    //Instruction Signals
    wire [5:0] instrAddr;   //O
    wire [31:0] instrDataP; //I
    wire [31:0] instrDataE; //I
    wire [31:0] mipsPC;     //O
    assign instrAddr = mipsPC[7:2];
    
    //Device Memory Signals
    wire we_dm;          //O
    reg [31:0] rd_dm;    //I
    wire [31:0] addr_dm; //O
    wire [31:0] wd_dm;   //O
    
    //Register File Signals
    reg [4:0] rf_addr3;   //I
    wire [31:0] rf_data3; //O
    
    //Interrupt Signals
    reg irq;             //I
    reg [31:0] irq_addr; //I
    wire irq_ack;        //O
    
    //Test Variables
    integer ii = 0;
    
    
    //-- Cycle the simulation starting with rising edge
    task tick; 
    begin 
    clk = 1'b0; #5;
            clk = 1'b1; #5;
            
    end endtask
    //-- Reset the simulation
    task reset;
    begin 
        rst = 1'b1; #5;
        tick;
        rst = 1'b0; #5;
    end endtask
    //-- Clear regfile
    task resetregfile;
    begin
        for(ii =1; ii<32; ii=ii+1) begin
            DUT.dp.rf.rf[ii] = 32'd0;
        end
    end endtask
    //-- Clear rom
    task clearrom;
    input [31:0] count;
    begin
        for(ii =0; ii<count; ii=ii+1) begin
            pmem.rom[ii] = 32'd0;
            emem.rom[ii] = 32'd0;
        end
    end endtask
    
    //Program/Exception Memory
    imem pmem(.a(instrAddr), .y(instrDataP));
    imem emem(.a(instrAddr), .y(instrDataE));
    
    mips DUT(
        .clk(clk),
        .rst(rst),
        .instrP(instrDataP),
        .instrE(instrDataE),
        .pc_current(mipsPC),
        .we_dm(we_dm),
        .rd_dm(rd_dm),
        .alu_out(addr_dm),
        .wd_dm(wd_dm),
        .ra3(rf_addr3),
        .rd3(rf_data3),
        .irq(irq),
        .irq_ack(irq_ack),
        .irq_addr(irq_addr)
    );
    
    reg [31:0] pc_p_original;
    reg [31:0] pc_e_start;
    reg [31:0] pc_p_restored;
    
    task test_contextSwitch;
    begin
        $display("[%d]Begin test_contextSwitch",$time);
        reset; resetregfile; clearrom(64);
        
        //Load Program mem with a noop loop
        pmem.rom[0] = 32'h0;
        pmem.rom[1] = 32'h0;
        pmem.rom[2] = 32'h0;
        pmem.rom[3] = 32'h0;
        pmem.rom[4] = 32'h0;
        pmem.rom[5] = 32'h0800_0000;
        
        //Load Exception mem with actions to load regfile
        $readmemh("mipstest-contextswitch.dat",emem.rom);
        #5;
        
        for(ii=0; ii<7; ii=ii+1) tick;
        
        //Save the current PC
        pc_p_original = mipsPC;
        $display("PC[%x] Before IRQ",pc_p_original);
        //Set the irq_addr,irq
        irq_addr = 32'd32; 
        irq = 1'd1;
        
        tick; //Finish current program instr
        
        pc_e_start = mipsPC;
        $display("PC[%x] 1Cycle After IRQ",pc_e_start);
        irq = 1'd0;
        
        tick; //PC is isr #1 ADDI
        $display("PC[%x] 2Cycle After IRQ",mipsPC);
        tick; //PC is isr #2 ADDI
        $display("PC[%x] 3Cycle After IRQ",mipsPC);
        tick; //PC is isr #3 ADDI
        $display("PC[%x] 4Cycle After IRQ",mipsPC);
        tick; //PC is isr #4 RES
        
        pc_p_restored = mipsPC;
        $display("PC[%x] 1Cycle After Restore",mipsPC);
        
        tick;
        $display("PC[%x] 2Cycle After Restore",mipsPC);
        
    end endtask
    
    initial begin
        clk = 1'b0;
        rd_dm = 32'd0; rf_addr3 = 5'd0;
        irq = 1'd0; irq_addr = 32'd0;
        reset;
        #5;
        
        test_contextSwitch;
    
    end



endmodule
