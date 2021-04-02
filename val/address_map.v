module address_map(
    input [31:0] input_addr,
    /* Implement later if we want to make mapping more configurable
    input [31:0] dm_base_addr,
    input [31:0] intc_base_addr,
    input [31:0] fact0_base_addr,
    input [31:0] fact1_base_addr,
    input [31:0] fact2_base_addr,
    input [31:0] fact3_base_addr,
    input [31:0] limit_addr,
    */
    
    output reg [2:0] select,
    output reg [5:0] control_signals,
    output reg out_of_range_error
    );

    //reg [5:0] control_signals;
    //reg [2:0] select;

    initial begin
        select = 3'b000; //default address is data mem
        out_of_range_error = 1'b0; // default to no error
        control_signals = 6'b0; //clear control signals
    end
    
    always@(*)begin
            casex(input_addr)
                // data memory address x00000000 - x0000FFFF
                // dm_we = 1, select = 000
                32'h0000xxxx: begin
                    control_signals <= 6'b000001;
                    select <= 3'b000;
                    out_of_range_error = 1'b0; // no error
                    end                
                // interrupt controller address x00020000 - x0002FFFF
                // intc_we = 1, select = 001
                32'h0002xxxx: begin
                    control_signals <= 6'b000010;
                    select <= 3'b001;
                    out_of_range_error = 1'b0; // no error
                    end              
                // factorial accelerator 0 address x00020000 - x0002FFFF
                // fact0_we = 1, select = 010
                32'h0003xxxx: begin
                    control_signals <= 6'b000100;
                    select <= 3'b010;
                    out_of_range_error = 1'b0; // no error
                    end
                // factorial accelerator 1 address x00030000 - x0003FFFF
                // fact1_we = 1, select = 011
                32'h0004xxxx: begin
                    control_signals <= 6'b001000;
                    select <= 3'b011;
                    out_of_range_error = 1'b0; // no error
                    end
                // factorial accelerator 2 address x00010000 - x0001FFFF
                // fact2_we = 1, select = 100
                32'h0005xxxx: begin
                    control_signals <= 6'b010000;
                    select <= 3'b100;
                    out_of_range_error = 1'b0; // no error
                    end
                // factorial accelerator 3 address x00010000 - x0001FFFF
                // fact3_we = 1, select = 101
                32'h0006xxxx: begin
                    control_signals <= 6'b100000;
                    select <= 3'b101;
                    out_of_range_error = 1'b0; // no error
                    end  
                default: begin
                    control_signals <= 6'b000000;
                    select <= 3'b000;
                    out_of_range_error = 1'b1;         
                    end    
                endcase
            end
            
        // set the control signals
        //assign {dm_we, intc_we, fact0_we, fact1_we, fact2_we, fact3_we} = {control_signals};
    
    endmodule