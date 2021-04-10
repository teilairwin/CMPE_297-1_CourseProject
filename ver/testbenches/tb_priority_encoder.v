`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Description: Testbench for Priority Encoder
//////////////////////////////////////////////////////////////////////////////////

module tb_priority_encoder();
    localparam WIDTH=4;

    reg         clk;
    reg   [3:0] interrupts_in;
    wire  [1:0] y_out;
    reg   [1:0] y_expected;
    wire        IRQ_out;
    reg         IRQ_expected;
    // reg         testPass;

    priority_encoder DUT(
      .interrupts (interrupts_in),
      .clk(clk),
      .y          (y_out),
      .IRQ        (IRQ_out)
    );

    //Test variables
    integer i = 0;
    integer w = 0;
    integer globalerr = 0;
    integer testerr = 0;
    integer countCycles = 0;
    integer cycleD = 0;
    // integer n_check = 0;
    // reg [31:0] product_check;

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

    //-- Reset test vars
    task resettest;
    begin
        testerr = 0;
        cycleD = 0;
        countCycles = 1;
    end
    endtask

    //-- Check Priority Encoder
    task check_priority_encoder;
    input [3:0] interrupts;
    output [1:0] y;
    output IRQ;
    begin
        casex(interrupts)
            // 0 is highest priority, 3 is lowest, IRQ is 1 when interrupt is active
            // Priority 0
            4'bxxx1 : begin
                        y = 2'b00;
                        IRQ = 1;
                      end
            // Priority 1
            4'bxx10 : begin
                        y = 2'b01;
                        IRQ = 1;
                      end
            // Priority 2
            4'bx100 : begin
                        y = 2'b10;
                        IRQ = 1;
                      end
            // Priority 3
            4'b1000 : begin
                        y = 2'b11;
                        IRQ = 1;
                      end
            // No interrupt
            default:  begin 
                        y = 2'b00;
                        IRQ = 0;
                      end
        endcase
        
    end
    endtask

    //-- Check a 4b value
    task check4;
    input [31:0] val;
    input [31:0] exp;
    begin
        if(val != exp) begin
            $display("[%d]TestComp value[0b%b] != expected[0b%b]!",$time,val,exp);
            testerr = testerr +1;
            globalerr = globalerr +1;
        end
        else
        begin
            $display("[%d]TestComp value[0b%b] = expected[0b%b]",$time,val,exp);
            //testerr = testerr +1;
            //globalerr = globalerr +1;
        end
    end
    endtask

    //-- Check a 1b value
    task check1;
    input val;
    input exp;
    begin
        if(val != exp) begin
            $display("[%d]TestComp value[0b%b] != expected[0b%b]!",$time,val,exp);
            testerr = testerr +1;
            globalerr = globalerr +1;
        end
        else
        begin
            $display("[%d]TestComp value[0b%b] = expected[0b%b]",$time,val,exp);
            //testerr = testerr +1;
            //globalerr = globalerr +1;
        end
    end
    endtask

    //--Output calculation time
    task timereport;
    input [WIDTH-1:0] n_in;
    begin
        $display("[%d]Priority Encoder of: %d took cycles:%d",$time,n_in,cycleD);
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
    task test_priority_encoder;
    input [3:0] interrupts_in;
    begin
        countCycles = 0;
        tick;
        $display("[%d]Testing of priority encoder:%d",$time,interrupts_in);
        resettest;
        
        countCycles = 1;
        check_priority_encoder(interrupts_in,y_expected,IRQ_expected);
        tick;
        $display("[%d]...Read  y_out=0b%b IRQ_out=0b%b",$time,y_out,IRQ_out);
        check4(y_out,y_expected);
        check1(IRQ_out,IRQ_expected);
        
        timereport(interrupts_in);
    end
    endtask

    ///////////////////////////////////////////////////////////////////////////
    // Run test sets
    ///////////////////////////////////////////////////////////////////////////
    initial begin
        clk = 1'b0;

        for(i =0; i < 16; i=i+1) begin
            interrupts_in = i;
            test_priority_encoder(interrupts_in);

            tick;
            interrupts_in = 0;
            tick;
        end
        
        exit;
    end

endmodule
