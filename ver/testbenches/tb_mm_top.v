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
        clk = 0;
        write_enable <= 1'b0;
        
        // test case 1: send data to the DM
        #20
        input_addr <= 32'h00000000;
        input_data <= 32'h0000000A;
        #20
        write_enable <= 1'b1;
        #20
        input_data <= 32'h0; 
        #20
        write_enable <= 1'b0;
        #20
        // test case 2: send data to the interrupt controller
        input_addr <= 32'h00010000;
        input_data <= 32'h0000000B;
        #20
        write_enable <= 1'b1;;
        #20
        input_data <= 32'h0; 
        #20
        write_enable <= 1'b0;
        #20
        // test case 3: send data to factorial unit 0
        input_addr <= 32'h00020000;
        input_data <= 32'h0000000C;
        #20
        write_enable <= 1'b1;
        #20
        input_data <= 32'h0; 
        #20
        write_enable <= 1'b0;
    // test case 3: send data to factorial unit 0
        input_addr <= 32'h00030000;
        input_data <= 32'h0000000D;
        #20
        write_enable <= 1'b1;
        #20
        input_data <= 32'h0; 
        #20
        write_enable <= 1'b0;    
        $finish;
        
    end

endmodule
