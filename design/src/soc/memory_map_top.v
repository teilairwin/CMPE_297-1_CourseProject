module memory_map_top(
        input wire write_enable,
        input wire [31:0] input_address,
        input wire [31:0] input_data,
        output reg [31:0] fact0_data, fact1_data, fact2_data, fact3_data, fact0_addr, fact1_addr, fact2_addr, fact3_addr,
        output wire dm_we, intc_we, fact0_we, fact1_we, fact2_we, fact3_we,
        output reg [31:0] dm_addr, intc_addr, dm_data, intc_data
    );
    
    reg [5:0] control_signals;
    reg [2:0] select;
    
    always@(*)begin
        // clear control signals
        assign control_signals = 6'b0;
        
        casex(input_address)
            // data memory address x00000000 - x0000FFFF
            // dm_we = 1, select = 000
            32'h0000xxxx: begin
                control_signals <= 6'b000001;
                select <= 3'b000;
                end                
            // interrupt controller address x00010000 - x0002FFFF
            // intc_we = 1, select = 001
            32'h0002xxxx: begin
                control_signals <= 6'b000010;
                select <= 3'b001;
                end              
            // factorial accelerator 0 address x00020000 - x0002FFFF
            // fact0_we = 1, select = 010
            32'h0002xxxx: begin
                control_signals <= 6'b000100;
                select <= 3'b010;
                end
            // factorial accelerator 1 address x00030000 - x0003FFFF
            // fact1_we = 1, select = 011
            32'h0003xxxx: begin
                control_signals <= 6'b001000;
                select <= 3'b011;
                end
            // factorial accelerator 1 address x00010000 - x0001FFFF
            // fact2_we = 1, select = 100
            32'h0004xxxx: begin
                control_signals <= 6'b010000;
                select <= 3'b100;
                end
            // factorial accelerator 1 address x00010000 - x0001FFFF
            // fact3_we = 1, select = 101
            32'h0005xxxx: begin
                control_signals <= 6'b100000;
                select <= 3'b101;
                end               
            endcase
        end
        
    // set the control signals
    assign {dm_we, intc_we, fact0_we, fact1_we, fact2_we, fact3_we} = {control_signals};
    
    // use select to mux to the right address and data lines
    mux8 #64 data_mux(
        .sel (select),
        .a   ({dm_addr,dm_data}),
        .b   ({intc_addr,intc_data}),
        .c   ({fact0_addr,fact0_data}),
        .d   ({fact1_addr,fact1_data}),
        .e   ({fact2_addr,fact2_data}),
        .f   ({fact3_addr,fact3_data}),
        .y   ({input_address,input_data})
    );
endmodule
