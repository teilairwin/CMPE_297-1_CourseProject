module intc_top(
        input   wire [3:0] done,
        input   wire IACK,
        input   wire clk,
        input   wire rst,
        input   wire [31:0] input_addr,
        input   wire write_enable,
        input   wire [31:0] write_data,
        
        output  wire [31:0] read_data, 
        output  wire IRQ,
        output  wire [31:0] isr_addr,
        output  reg error
    ); 
    
    // This is really ugly and probably belongs somewhere else
       // Currently the interrupt controller is mapped to address x00020000 - x0002FFFF and isr address offset is 0
       // The interrupt controller as designed has 4 d registers which the isr addresses can be written to
       // These registers are memory mapped to the following addresses
       // reg 0: Base + offset + 0  = 0x00020000 
       // reg 1: Base + offset + 32 = 0x00020020
       // reg 2: Base + offset + 64 = 0x00020040
       // reg 3: Base + offset + 96 = 0x00020060
       wire [31:0] intc_base_address;
       wire [31:0] isr_address_offset;
       // these should come from the memory map?
       wire [31:0] address_of_reg0;
       wire [31:0] address_of_reg1;
       wire [31:0] address_of_reg2;
       wire [31:0] address_of_reg3;
       wire [1:0] isr_addr_config_select;
       
       // wires for read data capability
       wire [1:0] read_data_select;
       wire    [31:0] read_reg0,read_reg1,read_reg2,read_reg3;
       
             
       //connections from ISR address select mux to the ISR Address registers
       /*wire [31:0] mux_to_reg0;
       wire [31:0] mux_to_reg1;
       wire [31:0] mux_to_reg2;
       wire [31:0] mux_to_reg3;*/
       
       //write enables for isr address registers
       wire we0, we1, we2, we3;
             
       //connections from ISR address registers to the interrupt controller
       wire [31:0] isr_addr0;
       wire [31:0] isr_addr1;
       wire [31:0] isr_addr2;
       wire [31:0] isr_addr3;
            
       assign read_reg0 = isr_addr0;
       assign read_reg1 = isr_addr1;
       assign read_reg2 = isr_addr2;
       assign read_reg3 = isr_addr3;
       
       assign intc_base_address = 32'h00020000;
       assign isr_address_offset = 32'h0;
       assign address_of_reg0 = 32'h0;
       assign address_of_reg1 = 32'h4;
       assign address_of_reg2 = 32'h8;
       assign address_of_reg3 = 32'hC;
       
       intc_read_address_decoder read_data_decoder(
               .read_address (input_addr),
               .select (read_data_select)
       );
       
       mux4 read_data_mux(
               .sel    (read_data_select),
               .a      (read_reg0),
               .b      (read_reg1),
               .c      (read_reg2),
               .d      (read_reg3),
               .y      (read_data)
       );
       
    isr_address_config_decoder dec(
        //input
        .intc_write_address (input_addr),
        .write_enable (write_enable),
        //output
        .select (isr_addr_config_select)
    );
    
    demux4 #1 isr_write_select(
        .sel        (isr_addr_config_select),
        .y          (write_enable),
        .a          (we0),
        .b          (we1),
        .c          (we2),
        .d          (we3)
    );
    // d reg0 for isr address 0 of address table
    dreg_en addr_table_0(
        .clk (clk),
        .rst (rst),
        .en  (we0),
        .d   (write_data),
        .q   (isr_addr0)
    );
    
    // d reg1 for isr address 1 of address table
    dreg_en addr_table_1(
        .clk (clk),
        .rst (rst),
        .en  (we1),
        .d   (write_data),
        .q   (isr_addr1)
    );
        
    // d reg2 for isr address 2 of address table
    dreg_en addr_table_2(
        .clk (clk),
        .rst (rst),
        .en  (we2),
        .d   (write_data),
        .q   (isr_addr2)
    );
    
    // d reg3 for isr address 3 of address table
    dreg_en addr_table_3(
        .clk (clk),
        .rst (rst),
        .en  (we3),
        .d   (write_data),
        .q   (isr_addr3)
    );
    
    intc intc(
            //input
            .done    (done),
            .IACK    (IACK),
            .clk     (clk),
            .rst_ext (rst),
            .isr_addr0 (isr_addr0),
            .isr_addr1 (isr_addr1),
            .isr_addr2 (isr_addr2),
            .isr_addr3 (isr_addr3),
            //output
            .IRQ     (IRQ),
            .isr_addr    (isr_addr)
        );
        
    initial begin
        error = 1'b0;
    end
        
endmodule
