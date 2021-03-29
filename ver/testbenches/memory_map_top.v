module memory_map_top(
        // MIPS Inputs/Outputs
        input write_enable,
        input [31:0] input_addr,
        input [31:0] input_data,
        output wire [31:0] output_data,
        output wire data_valid,
        
        // Outputs to DM
        output dm_we,
        output wire [31:0] dm_addr, dm_data,
        
        // Outputs to Interrupt Controller
        output intc_we,
        output wire [31:0] intc_addr, intc_data,

        // Outputs to Factorial Unit0
        output fact0_we,
        output wire [31:0] fact0_addr, fact0_data,
        
        // Outputs to Factorial Unit1
        output fact1_we,
        output wire [31:0] fact1_addr, fact1_data,
        
        // Outputs to Factorial Unit2
        output fact2_we,
        output wire [31:0] fact2_addr, fact2_data,
        
        // Outputs to Factorial Unit3
        output fact3_we,
        output wire [31:0] fact3_addr, fact3_data
    );
    
      
    assign dm_addr = input_addr;
    assign intc_addr = input_addr;
    assign fact0_addr = input_addr;
    assign fact1_addr = input_addr;
    assign fact2_addr = input_addr;
    assign fact3_addr = input_addr;
    
    assign dm_data = input_data;
    assign intc_data = input_data;
    assign fact0_data = input_data;
    assign fact1_data = input_data;
    assign fact2_data = input_data;
    assign fact3_data = input_data;    
    //assign select = 
    wire [2:0] select;
    wire out_of_range_error;
    wire validity;
    
    address_map address_map(
        //input
        .input_addr     (input_addr),
        //outputs
        .select         (select),
        .control_signals    ({fact3_we,fact2_we,fact1_we,fact0_we,intc_we,dm_we}),
        .out_of_range_error (out_of_range_error)
    );
    
    // use select to mux to the right address and data lines
    mux8 #32 data_mux(
        .sel (select),
        .a   ({dm_data}),
        .b   ({intc_data}),
        .c   ({fact0_data}),
        .d   ({fact1_data}),
        .e   ({fact2_data}),
        .f   ({fact3_data}),
        .y   ({output_data})
    );
    
    assign data_valid = !out_of_range_error;
endmodule
