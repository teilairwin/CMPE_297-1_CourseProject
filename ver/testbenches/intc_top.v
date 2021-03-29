module intc_top(
        input   wire [3:0] done,
        input   wire IACK,
        input   wire clk,
        input   wire [31:0] input_addr,
        input   wire write_enable,
        input   wire [31:0] write_data,
        
        output  wire [31:0] read_data, 
        output  wire IRQ,
        output  wire [31:0] isr_addr,
        output  wire error
    ); 
    
    // This is really ugly and probably belongs somewhere else
       // Currently the interrupt controller is mapped to address x00020000 - x0002FFFF and isr address offset is 0
       // The interrupt controller as designed has 4 d registers which the isr addresses can be written to
       // These registers are memory mapped to the following addresses
       // isr_addr0: Base + offset + 0  = 0x00020000 
       // isr_addr1: Base + offset + 32 = 0x00020020
       // isr_addr2: Base + offset + 64 = 0x00020040
       // isr_addr3: Base + offset + 96 = 0x00020060
       wire [31:0] intc_base_address;
       wire [31:0] isr_address_offset;
       // these should come from the memory map?
       wire [31:0] address_of_reg0;
       wire [31:0] address_of_reg1;
       wire [31:0] address_of_reg2;
       wire [31:0] address_of_reg3;
       wire rst;
       assign rst = 0;
       wire [1:0] isr_addr_config_select;
             
       //connections from ISR address select mux to the ISR Address registers
       wire [31:0] mux_to_reg0;
       wire [31:0] mux_to_reg1;
       wire [31:0] mux_to_reg2;
       wire [31:0] mux_to_reg3;      
       
       //connections from ISR address registers to the interrupt controller
       wire [31:0] isr_addr0;
       wire [31:0] isr_addr1;
       wire [31:0] isr_addr2;
       wire [31:0] isr_addr3;
       
       assign intc_base_address = 32'h00020000;
       assign isr_address_offset = 32'h0;
       assign address_of_reg0 = intc_base_address + isr_address_offset + 32'h0;
       assign address_of_reg1 = intc_base_address + isr_address_offset + 32'h20;
       assign address_of_reg2 = intc_base_address + isr_address_offset + 32'h40;
       assign address_of_reg3 = intc_base_address + isr_address_offset + 32'h60;
   
    isr_address_config_decoder dec(
        //input
        .intc_write_address (input_addr),
        .write_enable (write_enable),
        //output
        .select (isr_addr_config_select),
        .error (error)
    );
    
    mux4 isr_write_select(
        .sel        (isr_addr_config_select),
        .a          (mux_to_reg0),
        .b          (mux_to_reg1),
        .c          (mux_to_reg2),
        .d          (mux_to_reg3),
        .y          (write_data)
    );
    // d reg0 for isr address 0 of address table
    dreg_en addr_table_0(
        .clk (clk),
        .rst (rst),
        .en  (write_enable),
        .d   (mux_to_reg0),
        .q   (isr_addr0)
    );
    
    // d reg1 for isr address 1 of address table
    dreg_en addr_table_1(
        .clk (clk),
        .rst (rst),
        .en  (write_enable),
        .d   (mux_to_reg1),
        .q   (isr_addr1)
    );
        
    // d reg2 for isr address 2 of address table
    dreg_en addr_table_2(
        .clk (clk),
        .rst (rst),
        .en  (write_enable),
        .d   (mux_to_reg2),
        .q   (isr_addr2)
    );
    
    // d reg3 for isr address 3 of address table
    dreg_en addr_table_3(
        .clk (clk),
        .rst (rst),
        .en  (write_enable),
        .d   (mux_to_reg3),
        .q   (isr_addr3)
    );
    
    intc intc(
            //input
            .done    (done),
            .input_addr (input_addr),
            .IACK    (IACK),
            .clk     (clk),
            .isr_addr0 (isr_addr0),
            .isr_addr1 (isr_addr1),
            .isr_addr2 (isr_addr2),
            .isr_addr3 (isr_addr3),
            //output
            .IRQ     (IRQ),
            .isr_addr    (isr_addr),
            .read_data (read_data)
        );
endmodule
