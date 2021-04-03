`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Description: Testbench for MIPS context switching
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
    integer errorCount = 0;
    
    //-- Cycle the simulation 
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
    
    //-- Check a 32b value
    task check32;
    input [31:0] val;
    input [31:0] exp;
    begin
        if(val != exp) begin
            $display("[%d]TestComp value[0x%h] != expected[0x%h]!",$time,val,exp);
            errorCount = errorCount +1;
        end
    end endtask
    
    //-- Exit the simulation
    task exit;
    begin
        $display("\nExit");
        $display("[%d]Leaving simulation...",$time);
        $display("[%d]Total Errors: %d",$time,errorCount);
        $finish;
    end
    endtask
    
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
        
        //Load Program mem with a counter loop
        $readmemh("mipstest-counterloop.dat",pmem.rom);
        #5;
        //Load Exception mem with actions to load regfile
        $readmemh("mipstest-contextswitch.dat",emem.rom);
        #5;
        
        for(ii=0; ii<5; ii=ii+1) tick;
        
        ///////////////////////////////////////////////////////////////////////
        //Set the irq_addr,irq
        $display("Triggering ISR1");
        //Save the current PC
        pc_p_original = mipsPC;
        $display("PC[%x] Before IRQ",pc_p_original);
        irq_addr = 32'h20; 
        irq = 1'd1;
        tick; //Finish current program instr
        
        pc_e_start = mipsPC;
        $display("PC[%x] 1Cycle After IRQ",pc_e_start);
        check32(pc_e_start, irq_addr);
        irq = 1'd0;
        
        tick; //PC is isr #1 ADDI
        $display("PC[%x] 2Cycle After IRQ",mipsPC);
        check32(mipsPC, pc_e_start+32'd4);
        tick; //PC is isr #2 ADDI
        $display("PC[%x] 3Cycle After IRQ",mipsPC);
        check32(mipsPC, pc_e_start+32'd8);
        tick; //PC is isr #3 ADDI
        $display("PC[%x] 4Cycle After IRQ",mipsPC);
        check32(mipsPC, pc_e_start+32'd12);
        tick; //PC is isr #4 RES
        
        pc_p_restored = mipsPC;
        $display("PC[%x] 1Cycle After Restore",mipsPC);
        check32(pc_p_restored, pc_p_original+32'd4);
        
        tick;
        $display("PC[%x] 2Cycle After Restore",mipsPC);
        check32(mipsPC, 32'd4);
        
        //Check our exp program ran
        $display("Checking ISR written data");
        check32(DUT.dp.rf.rf[11],32'd200);
        check32(DUT.dp.rf.rf[12],32'd201);
        check32(DUT.dp.rf.rf[13],32'd202);
 
        ///////////////////////////////////////////////////////////////////////
        $display("Triggering ISR2");
        pc_p_original = mipsPC;
        $display("PC[%x] Before IRQ",pc_p_original);
        irq_addr = 32'h40; 
        irq = 1'd1;
        tick; //Finish current program instr
        
        pc_e_start = mipsPC;
        $display("PC[%x] 1Cycle After IRQ",pc_e_start);
        check32(pc_e_start, irq_addr);
        irq = 1'd0;
        
        tick; //PC is isr #1 ADDI
        $display("PC[%x] 2Cycle After IRQ",mipsPC);
        check32(mipsPC, pc_e_start+32'd4);
        tick; //PC is isr #2 ADDI
        $display("PC[%x] 3Cycle After IRQ",mipsPC);
        check32(mipsPC, pc_e_start+32'd8);
        tick; //PC is isr #3 ADDI
        $display("PC[%x] 4Cycle After IRQ",mipsPC);
        check32(mipsPC, pc_e_start+32'd12);
        tick; //PC is isr #4 RES
        
        pc_p_restored = mipsPC;
        $display("PC[%x] 1Cycle After Restore",mipsPC);
        check32(pc_p_restored, pc_p_original+32'd4);
        
        tick;
        $display("PC[%x] 2Cycle After Restore",mipsPC);
        check32(mipsPC, 32'hC);
        
        //Check our exp program ran
        $display("Checking ISR written data");
        check32(DUT.dp.rf.rf[14],32'd300);
        check32(DUT.dp.rf.rf[15],32'd301);
        check32(DUT.dp.rf.rf[24],32'd302);
    
        ///////////////////////////////////////////////////////////////////////
        $display("Triggering ISR0");
        pc_p_original = mipsPC;
        $display("PC[%x] Before IRQ",pc_p_original);
        irq_addr = 32'h0; 
        irq = 1'd1;
        tick; //Finish current program instr
        
        pc_e_start = mipsPC;
        $display("PC[%x] 1Cycle After IRQ",pc_e_start);
        check32(pc_e_start, irq_addr);
        irq = 1'd0;
        
        tick; //PC is isr #1 ADDI
        $display("PC[%x] 2Cycle After IRQ",mipsPC);
        check32(mipsPC, pc_e_start+32'd4);
        tick; //PC is isr #2 ADDI
        $display("PC[%x] 3Cycle After IRQ",mipsPC);
        check32(mipsPC, pc_e_start+32'd8);
        tick; //PC is isr #3 ADDI
        $display("PC[%x] 4Cycle After IRQ",mipsPC);
        check32(mipsPC, pc_e_start+32'd12);
        tick; //PC is isr #4 RES
        
        pc_p_restored = mipsPC;
        $display("PC[%x] 1Cycle After Restore",mipsPC);
        check32(pc_p_restored, 32'd4);
        
        tick;
        $display("PC[%x] 2Cycle After Restore",mipsPC);
        check32(mipsPC, 32'h8);
        
        //Check our exp program ran
        $display("Checking ISR written data");
        check32(DUT.dp.rf.rf[8], 32'd100);
        check32(DUT.dp.rf.rf[9], 32'd101);
        check32(DUT.dp.rf.rf[10],32'd102);
    
            ///////////////////////////////////////////////////////////////////////
        $display("Triggering ISR3 - That does not resume");
        pc_p_original = mipsPC;
        $display("PC[%x] Before IRQ",pc_p_original);
        irq_addr = 32'h60; 
        irq = 1'd1;
        tick; //Finish current program instr
        
        pc_e_start = mipsPC;
        $display("PC[%x] 1Cycle After IRQ",pc_e_start);
        check32(pc_e_start, irq_addr);
        irq = 1'd0;
        
        tick; //PC is isr #1 ADDI
        $display("PC[%x] 2Cycle After IRQ",mipsPC);
        check32(mipsPC, pc_e_start+32'd4);
        tick; //PC is isr #2 NOP
        $display("PC[%x] 3Cycle After IRQ",mipsPC);
        check32(mipsPC, pc_e_start+32'd8);
        tick; //PC is isr #3 NOP
        $display("PC[%x] 4Cycle After IRQ",mipsPC);
        check32(mipsPC, pc_e_start+32'd12);
        tick; //PC is isr #4 J
        $display("PC[%x] 5Cycle After IRQ",mipsPC);
        check32(mipsPC, pc_e_start);  
        tick;
        $display("PC[%x] 6Cycle After IRQ",mipsPC);
        check32(mipsPC, pc_e_start+32'd4);
        
        //Check our exp program ran
        $display("Checking ISR written data");
        check32(DUT.dp.rf.rf[25], 32'd400);
    
    end endtask
    
    initial begin
        clk = 1'b0;
        rd_dm = 32'd0; rf_addr3 = 5'd0;
        irq = 1'd0; irq_addr = 32'd0;
        reset;
        #5;
        
        test_contextSwitch;
    
        exit;
    end



endmodule
