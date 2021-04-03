`timescale 1ns / 1ps

module tb_mm_top();
    reg clk;
    
    // declare signals to stimulate system inputs
    reg write_enable;
    reg [31:0] input_addr, input_data;
    // declare signals to store system outputs
    wire  [31:0] output_data;
    wire data_valid;
    
    //Device I/O signals
    reg [31:0] dev_rdata [5:0];
    wire [5:0] dev_we;
    wire [31:0] dev_addr [5:0];
    wire [31:0] dev_wdata [5:0];
    
    //Test Variables
    integer ii = 0;
    integer errorCount = 0;
    reg [31:0] dev_baseAddr [5:0];
    
    //-- Cycle the simulation 
    task tick; 
    begin
        #10;  
    end endtask
    //-- Reset the simulation
    task reset;
    begin 
        write_enable = 0;
        input_addr = 32'b0;
        input_data = 32'b0;
        for(ii=0; ii<6; ii=ii+1) begin
            dev_rdata[ii] = 32'b0;
        end
        dev_baseAddr[0] = 32'h0000_0000;
        dev_baseAddr[1] = 32'h0000_2000;
        dev_baseAddr[2] = 32'h0000_3000;
        dev_baseAddr[3] = 32'h0000_4000;
        dev_baseAddr[4] = 32'h0000_5000;
        dev_baseAddr[5] = 32'h0000_6000;
        tick;
    end endtask
    
    //-- Check a 1b value
    task check1;
    input val;
    input exp;
    begin
        if(val != exp) begin
            $display("[%d]TestComp value[0x%h] != expected[0x%h]!",$time,val,exp);
            errorCount = errorCount +1;
        end
    end endtask
    //-- Check a 1b value
    task check3;
        input [2:0] val;
        input [2:0] exp;
        begin
            if(val != exp) begin
                $display("[%d]TestComp value[0x%h] != expected[0x%h]!",$time,val,exp);
                errorCount = errorCount +1;
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
    
    task test_dev_access;
    input [2:0] devN;
    begin
        $display("[%d]Checking Dev Access For: %d",$time,devN);
        reset;
        
        //Pre-Check
        $display("\tPRE_CONDITIONS");
        //Check the dev connections
        $display("\t\tChecking DevWE:0x%h",dev_we[devN]);
        check1(dev_we[devN], 1'b0);
        $display("\t\tChecking DevADDR:0x%h",dev_addr[devN]);
        check32(dev_addr[devN], 32'b0);
        $display("\t\tChecking DevWData:0x%h",dev_wdata[devN]);
        check32(dev_wdata[devN], 32'b0);
        //Check the host connections
        $display("\t\tChecking MmOutData:0x%h",output_data);
        check32(output_data, 32'b0);
        $display("\t\tChecking MmDataValid:0x%h",data_valid);
        check1(data_valid, 1'b1);
        
        //Check the base address select & read
        $display("\tBASE-ADDR-READ"); 
        input_addr = dev_baseAddr[devN];
        dev_rdata[devN] = $urandom();
        tick;
        $display("\t\tChecking BaseAddr Select:0x%h",DUT.select);
        check3(DUT.select,devN);
        $display("\t\tChecking DevAddr Exp:0x%h Got:0x%h",input_addr,dev_addr[devN]);
        check32(input_addr,dev_addr[devN]);
        $display("\t\tChecking BaseAddrRead Exp:0x%h Got:0x%h",dev_rdata[devN],output_data);
        check32(dev_rdata[devN],output_data);
        check1(dev_we[devN], 1'b0);
        
        //Check the address select & read 
        $display("\tOFFSET-READ");
        input_addr = dev_baseAddr[devN]+32'h8;
        dev_rdata[devN] = $urandom();
        tick;
        $display("\t\tChecking Addr Select:0x%h",DUT.select);
        check3(DUT.select,devN);
        $display("\t\tChecking DevAddr Exp:0x%h Got:0x%h",input_addr,dev_addr[devN]);
        check32(input_addr,dev_addr[devN]);
        $display("\t\tChecking BaseAddrRead Exp:0x%h Got:0x%h",dev_rdata[devN],output_data);
        check32(dev_rdata[devN],output_data);
        check1(dev_we[devN], 1'b0);
        
        //Write base address
        $display("\tBASE-ADDR-WRITE");
        input_addr = dev_baseAddr[devN];
        dev_rdata[devN] = $urandom();
        input_data = $urandom();
        write_enable = 1'b1;
        tick;
        $display("\t\tChecking Addr Select:0x%h",DUT.select);
        check3(DUT.select,devN);
        $display("\t\tChecking DevAddr Exp:0x%h Got:0x%h",input_addr,dev_addr[devN]);
        check32(input_addr,dev_addr[devN]);
        $display("\t\tChecking WriteData Exp:0x%h Got:0x%h",dev_wdata[devN],input_data);
        check32(dev_wdata[devN],input_data);
        $display("\t\tChecking WE:0x%h",dev_we[devN]);
        check1(dev_we[devN], 1'b1);
        $display("\t\tchecking Validity:0x%h",data_valid);
        check1(data_valid, 1'b1);
        
        //Write offset address
        $display("\tOFFSET-WRITE");
        input_addr = dev_baseAddr[devN]+32'hC;
        dev_rdata[devN] = $urandom();
        input_data = $urandom();
        write_enable = 1'b1;
        tick;
        $display("\t\tChecking Addr Select:0x%h",DUT.select);
        check3(DUT.select,devN);
        $display("\t\tChecking DevAddr Exp:0x%h Got:0x%h",input_addr,dev_addr[devN]);
        check32(input_addr,dev_addr[devN]);
        $display("\t\tChecking WriteData Exp:0x%h Got:0x%h",dev_wdata[devN],input_data);
        check32(dev_wdata[devN],input_data);
        $display("\t\tChecking WE:0x%h",dev_we[devN]);
        check1(dev_we[devN], 1'b1);
        $display("\t\tchecking Validity:0x%h",data_valid);
        check1(data_valid, 1'b1);    
        
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
    
    //Instantiate DUT
    memory_map_top DUT(
        //MIPS Processor connections
        .write_enable (write_enable),
        .input_addr (input_addr),
        .input_data (input_data),
        .output_data (output_data),
        .data_valid (data_valid),
        //DEV - DataMemory
        .dm_rdata(dev_rdata[0]),
        .dm_we   (dev_we[0]),
        .dm_addr (dev_addr[0]),
        .dm_wdata(dev_wdata[0]),
        //DEV - IntcMemory
        .intc_rdata(dev_rdata[1]),
        .intc_we   (dev_we[1]),
        .intc_addr (dev_addr[1]),
        .intc_wdata(dev_wdata[1]),
        //DEV - Fact0
        .fact0_rdata(dev_rdata[2]),
        .fact0_we   (dev_we[2]),
        .fact0_addr (dev_addr[2]),
        .fact0_wdata(dev_wdata[2]),
        //DEV - Fact1
        .fact1_rdata(dev_rdata[3]),
        .fact1_we   (dev_we[3]),
        .fact1_addr (dev_addr[3]),
        .fact1_wdata(dev_wdata[3]),
        //DEV - Fact2
        .fact2_rdata(dev_rdata[4]),
        .fact2_we   (dev_we[4]),
        .fact2_addr (dev_addr[4]),
        .fact2_wdata(dev_wdata[4]),
        //DEV - Fact3
        .fact3_rdata(dev_rdata[5]),
        .fact3_we   (dev_we[5]),
        .fact3_addr (dev_addr[5]),
        .fact3_wdata(dev_wdata[5])
    );

    //always begin
    //    #5 clk = ~clk;
    //end
    initial begin
        reset;
        
        test_dev_access(3'd0);
        test_dev_access(3'd1);
        test_dev_access(3'd2);
        test_dev_access(3'd3);
        test_dev_access(3'd4);
        test_dev_access(3'd5);
        
        exit;
    end

endmodule
