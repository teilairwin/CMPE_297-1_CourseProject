`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Description: Testbench for SOC
//////////////////////////////////////////////////////////////////////////////////

module tb_soc();
    
    //System Signals
    reg clk,rst;            //I
    wire [31:0] mipsPC;     //O
    reg [4:0] mipsRfAddr;   //I
    wire [31:0] mipsRfData; //O
    reg romWe,romSelect;    //I
    reg [5:0] romAddr;      //I
    reg [31:0] romWd;       //I
    wire [31:0] romRd;      //O            
    wire [31:0] testdata;   //O
    
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
            DUT.mips.dp.rf.rf[ii] = 32'd0;
        end
    end endtask
    
    /* /-- Clear rom
    task clearrom;
    input [31:0] count;
    begin
        for(ii =0; ii<count; ii=ii+1) begin
            pmem.rom[ii] = 32'd0;
            emem.rom[ii] = 32'd0;
        end
    end endtask */
    
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
    
    system DUT(
        .sys_clk(clk),
        .sys_rst(rst),
        .pc_current(mipsPC),
        .mips_rf_addr(mipsRfAddr),
        .mips_rf_data(mipsRfData),
        .rom_we(romWe),
        .rom_select(romSelect),
        .rom_addr(romAddr),
        .rom_wd(romWd),
        .rom_rd(romRd),
        .intc_test(testdata)
    );
    
    reg [31:0] rfS0,rfS1;
    reg [31:0] rfT0,rfT1,rfT2,rfT3,rfT4,rfT5;
    
    task test_fact0;
    begin
        $display("[%d]Begin test_fact0",$time);
        reset; resetregfile;
        
        //Load Program mem with a counter loop
        $readmemh("testsoc-fact0.dat",DUT.pmem.rom);
        #5;
        //Load Exception mem with actions to load regfile
        $readmemh("testsoc-fact-isrs.dat",DUT.emem.rom);
        #5;
        
        for(ii=0; ii<120; ii=ii+1) tick;
        
        $display("Ran Program for 120 cycles");
        
        mipsRfAddr = 5'd16;
        #5
        rfS0 = mipsRfData;
        $display("\tRead[S0] Data=0x%h",rfS0);
        check32(rfS0,32'd1);
        
        mipsRfAddr = 5'd17;
        #5
        rfS1 = mipsRfData;
        $display("\tRead[S1] Data=0x%h",rfS1);
        check32(rfS1,32'd120);
        
        mipsRfAddr = 5'd10;
        #5
        rfT2 = mipsRfData;
        $display("\tRead[T2] Data=0x%h",rfT2);
        check32(rfT2,32'd20);
        
        mipsRfAddr = 5'd11;
        #5
        rfT3 = mipsRfData;
        $display("\tRead[T3] Data=0x%h",rfT3);
        check32(rfT3,32'd20);
        
        mipsRfAddr = 5'd12;
        #5
        rfT4 = mipsRfData;
        $display("\tRead[T4] Data=0x%h",rfT4);
        check32(rfT4,32'd1);
        
        mipsRfAddr = 5'd13;
        #5
        rfT5 = mipsRfData;
        $display("\tRead[T5] Data=0x%h",rfT5);
        check32(rfT5,32'd120);
    
    end endtask
    
    initial begin
        clk = 1'b0;
        rst = 1'b0;
        mipsRfAddr = 5'b0;
        romWe = 1'b0;
        romSelect = 1'b0;
        romAddr = 6'b0;
        romWd = 32'b0;
        reset;
        #5;
        
        test_fact0;
    
        exit;
    end



endmodule
