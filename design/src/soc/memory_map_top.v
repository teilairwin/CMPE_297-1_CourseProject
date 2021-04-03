module memory_map_top(
        // MIPS Inputs/Outputs
        input write_enable,
        input [31:0] input_addr,
        input [31:0] input_data,
        output wire [31:0] output_data,
        output wire data_valid,
        
        // Inputs/Outputs to DM
        input wire [31:0] dm_rdata,
        output dm_we,
        output wire [31:0] dm_addr, dm_wdata,
        
        // Inputs/Outputs to Interrupt Controller
        input wire [31:0] intc_rdata,
        output intc_we,
        output wire [31:0] intc_addr, intc_wdata,

        // Inputs/Outputs to Factorial Unit0
        input wire [31:0] fact0_rdata,
        output fact0_we,
        output wire [31:0] fact0_addr, fact0_wdata,
        
        // Inputs/Outputs to Factorial Unit1
        input wire [31:0] fact1_rdata,
        output fact1_we,
        output wire [31:0] fact1_addr, fact1_wdata,
        
        // Inputs/Outputs to Factorial Unit2
        input wire [31:0] fact2_rdata,
        output fact2_we,
        output wire [31:0] fact2_addr, fact2_wdata,
        
        // Inputs/Outputs to Factorial Unit3
        input wire [31:0] fact3_rdata,
        output fact3_we,
        output wire [31:0] fact3_addr, fact3_wdata
    );
    
    //Pass through the access address to device 
    assign dm_addr = input_addr;
    assign intc_addr = input_addr;
    assign fact0_addr = input_addr;
    assign fact1_addr = input_addr;
    assign fact2_addr = input_addr;
    assign fact3_addr = input_addr;
    
    //Pass through the write data to device
    assign dm_wdata = input_data;
    assign intc_wdata = input_data;
    assign fact0_wdata = input_data;
    assign fact1_wdata = input_data;
    assign fact2_wdata = input_data;
    assign fact3_wdata = input_data;    
    
    //assign select = 
    wire [2:0] select;
    wire out_of_range_error;
    wire validity;
    wire [5:0] mm_we;
    
    address_map address_map(
        //input
        .input_addr     (input_addr),
        //outputs
        .select         (select),
        .write_enable   (mm_we),
        .out_of_range_error (out_of_range_error)
    );
    
    assign dm_we = write_enable & mm_we[0];
    assign intc_we = write_enable & mm_we[1];
    assign fact0_we = write_enable & mm_we[2];
    assign fact1_we = write_enable & mm_we[3];
    assign fact2_we = write_enable & mm_we[4];
    assign fact3_we = write_enable & mm_we[5];
    
    // use select to mux to the right address and data lines
    mux8 #32 data_mux(
        .sel (select),
        .a   ({dm_rdata}),
        .b   ({intc_rdata}),
        .c   ({fact0_rdata}),
        .d   ({fact1_rdata}),
        .e   ({fact2_rdata}),
        .f   ({fact3_rdata}),
        .g   (32'b0),
        .h   (32'b0),
        .y   ({output_data})
    );
    
    assign data_valid = !out_of_range_error;
endmodule
