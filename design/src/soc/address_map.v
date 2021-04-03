module address_map(
    input [31:0] input_addr,       ///< Memory Access Address
    
    output reg [2:0] select,       ///< Memory Device Select
    output reg [5:0] write_enable, ///< Write Access Enable
    output reg out_of_range_error  ///< Address Range Error
    );

    initial begin
        select = 3'b000;           //default address is data mem
        out_of_range_error = 1'b0; //default to no error
        write_enable = 6'b0;       //clear control signals
    end
    
    always@(*)begin
        casex(input_addr)
            // data memory address x00000000 - x00000FFF
            // dm_we = 1, select = 000
            32'h0000_0xxx: begin
                write_enable <= 6'b000001;
                select <= 3'b000;
                out_of_range_error = 1'b0; // no error
            end                
            // interrupt controller address x00002000 - x00002FFF
            // intc_we = 1, select = 001
            32'h0000_2xxx: begin
                write_enable <= 6'b000010;
                select <= 3'b001;
                out_of_range_error = 1'b0; // no error
            end              
            // factorial accelerator 0 address x00003000 - x00003FFF
            // fact0_we = 1, select = 010
            32'h0000_3xxx: begin
                write_enable <= 6'b000100;
                select <= 3'b010;
                out_of_range_error = 1'b0; // no error
            end
            // factorial accelerator 1 address x00004000 - x00004FFF
            // fact1_we = 1, select = 011
            32'h0000_4xxx: begin
                write_enable <= 6'b001000;
                select <= 3'b011;
                out_of_range_error = 1'b0; // no error
            end
            // factorial accelerator 2 address x00005000 - x00005FFF
            // fact2_we = 1, select = 100
            32'h0000_5xxx: begin
                write_enable <= 6'b010000;
                select <= 3'b100;
                out_of_range_error = 1'b0; // no error
            end
            // factorial accelerator 3 address x00006000 - x00006FFF
            // fact3_we = 1, select = 101
            32'h0000_6xxx: begin
                write_enable <= 6'b100000;
                select <= 3'b101;
                out_of_range_error = 1'b0; // no error
            end  
            default: begin
                write_enable <= 6'b000000;
                select <= 3'b000;
                out_of_range_error = 1'b1;         
            end    
        endcase
    end    
endmodule
