`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Description: Testbench for Top Level
//////////////////////////////////////////////////////////////////////////////////

module tb_fact_top();
    localparam WIDTH=4;

    reg         clk, rst, we;
    reg [1:0]   wa;
    reg [3:0]   wd;
    wire        Done;
    wire [31:0] rd;

    //Device under test
    fact_top #(.NWIDTH(WIDTH)) DUT (
        .clk    (clk),
        .rst    (rst),
        .WE     (we),
        .A      (wa),
        .WD     (wd),
        .RD     (rd),
        .Done   (Done)
    );

    //Test Data
    reg [31:0] rd_nf;
        
    //Test variables
    integer i = 0;
    integer w = 0;
    integer globalerr = 0;
    integer testerr = 0;
    integer countCycles = 0;
    integer cycleD = 0;
    integer n_check = 0;
    reg [31:0] product_check;

    /////////////////////////////////////////////////////////////////////////////
    // Utility
    /////////////////////////////////////////////////////////////////////////////
    //-- Cycle the simulation starting with falling edge
    task tick; 
    begin 
        clk = 1'b0; #5;
        clk = 1'b1; #5;
        cycleD = countCycles ? cycleD +1 : cycleD;
    end
    endtask

    //-- Reset the simulation
    task reset;
    begin 
        rst = 1'b1; #5;
        //tick;
        rst = 1'b0; #5;
    end
    endtask

    //-- Reset test vars
    task resettest;
    begin
        testerr = 0;
        cycleD = 0;
        countCycles = 1;
        we = 1'd0;
        wa = 3'd0;
        wd = 3'd0;
    end
    endtask

    //-- Check a 32b value
    task check32;
    input [31:0] val;
    input [31:0] exp;
    begin
        if(val != exp) begin
            $display("[%d]TestComp value[0x%h] != expected[0x%h]!",$time,val,exp);
            testerr = testerr +1;
            globalerr = globalerr +1;
        end
        else
        begin
            $display("[%d]TestComp value[0x%h] = expected[0x%h] :-)",$time,val,exp);
            testerr = testerr +1;
            globalerr = globalerr +1;
        end
    end
    endtask

    //--Output calculation time
    task timereport;
    input [WIDTH-1:0] n_in;
    begin
        $display("[%d]Factorial of: %d took cycles:%d",$time,n_in,cycleD);
    end
    endtask

    //-- Exit the simulation
    task exit;
    begin
        $display("[%d]Leaving simulation...",$time);
        $display("[%d]Total Errors: %d",$time,globalerr);
        $finish;
    end
    endtask

    ///////////////////////////////////////////////////////////////////////////
    // Tests
    ///////////////////////////////////////////////////////////////////////////
    task test_idle_reset;
    begin
        $display("[%d]Checking IDLE State on reset",$time);  
        resettest;
        reset;
        #5;
        
        for(i =0; i<8; i=i+1) begin
            wa = i;
            tick;
            check32(rd,32'b0);
        end
        $display("[%d]Done Checking IDLE State on reset",$time);
    end
    endtask
    
    task test_fact;
    input [WIDTH-1:0] n_in;
    begin
        $display("[%d]Computing factorial of:%d",$time,n_in);
        resettest;
        if(n_in == 0) begin
            reset;
            #5;
        end
        
        n_check = n_in;
        
        product_check = 32'd1;
        while(n_check > 1) begin
            product_check = product_check * n_check;
            n_check = n_check - 1;
        end 
        
        countCycles = 0;
        wa = 2'b00;      // n register write enable
        we = 1'd0;
        wd = 3'd0;
        tick;
        
        countCycles = 1;
        
        //Set N
        wa = 2'b00;      // n register write enable
        wd = n_in;
        we = 1'd1;
        $display("...Write     N=0x%h @0x%h",wd,wa); 
        tick;
        
        //Write Go
        wa = 2'b01;     // go register write enable
        wd = {2'd0,1'd1};
        we = 1'd1;
        $display("...Write    GO=0x%h @0x%h",wd,wa);
        tick;
        
        for(w = 0; w < ((n_in+1)*3); w = w+1) begin
            tick;
            $display("...Read Status=0x%h @0x%h Done=%h",rd,wa,Done);
            if(rd[0]) begin
                countCycles = 0;
            end
        end
        
        //Read n!
        countCycles = 1;
        wa = 2'd3;
        tick;
        $display("...Read  n!=0x%h @0x%h Done=%h",rd,wa,Done);
        rd_nf = rd;
        
        check32(rd_nf,product_check);
        timereport(n_in);
        
    end
    endtask

    ///////////////////////////////////////////////////////////////////////////
    // Run test sets
    ///////////////////////////////////////////////////////////////////////////
    initial begin
        clk = 1'b0;

        //test_idle_reset;

        for(i =0; i < 16; i=i+1) begin
            test_fact(i);
        end
        
        exit;
    end

endmodule
