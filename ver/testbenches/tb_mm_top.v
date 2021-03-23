`timescale 1ns / 1ps

module tb_mm_top();
    reg clk;
    // declare signals to stimulate system inputs
    reg write_enable;
    reg [31:0] input_addr, input_data;
    // declare signals to store system outputs
    wire  [31:0] output_data;
    wire [5:0] control_signals;
    wire data_valid;
    
    wire [31:0] dm_addr, dm_data, intc_addr, intc_data, fact0_addr,fact0_data,fact1_addr,fact1_data,fact2_addr,fact2_data,fact3_addr,fact3_data;
    // instantiate DUT
    memory_map_top DUT(
        .write_enable (write_enable),
        .input_addr (input_addr),
        .input_data (input_data),
        .output_data (output_data),
        .data_valid (data_valid),
        .dm_we (control_signals[0]),
        .dm_addr (dm_addr),
        .dm_data (dm_data),
        .intc_we (control_signals[1]),
        .intc_addr (intc_addr),
        .intc_data (intc_data),
        .fact0_we (control_signals[2]),
        .fact0_addr (fact0_addr),
        .fact0_data (fact0_data),
        .fact1_we (control_signals[3]),
        .fact1_addr (fact1_addr),
        .fact1_data (fact1_data),
        .fact2_we (control_signals[4]),
        .fact2_addr (fact2_addr),
        .fact2_data (fact2_data),
        .fact3_we (control_signals[5]),
        .fact3_addr (fact3_addr),
        .fact3_data (fact3_data)
    );

    always begin
        #5 clk = ~clk;
    end
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
