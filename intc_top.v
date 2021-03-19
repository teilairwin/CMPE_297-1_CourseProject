module intc_top(
        input   wire [3:0] done,
        input   wire IACK,
        input   wire clk,
        input   wire [31:0] input_addr,
        input   wire write_enable,
        input   wire [31:0] write_data,
        output  wire [31:0] read_data, 
        output  wire IRQ,
        output  wire [31:0] isr_addr
    ); 
    
    //priority select
    wire    [1:0]  priority_select;

    // hardwire data and address lines
    assign read_data = write_data;
    
    // assign vector_table_starting_addr = 32'h0;
    reg [31:0] addr0_reg = 32'h00030000;
    reg [31:0] addr1_reg = 32'h00040000;
    reg [31:0] addr2_reg = 32'h00050000;
    reg [31:0] addr3_reg = 32'h00060000;
    // wire [31:0] vector_table_starting_addr;
        
    intc intc(
        .done    (done),
        .input_addr (input_addr),
        .write_data (write_data),
        .write_enable (write_enable),
        .IACK    (IACK),
        .clk     (clk),
        .addr0  (addr0_reg),
        .addr1  (addr1_reg),
        .addr2  (addr2_reg),
        .addr3  (addr3_reg),
        .IRQ     (IRQ),
        .isr_addr    (isr_addr),
        .read_data (read_data),
        .priority_select (priority_select)
    );
    
    // address vector table
    //assign starting_address = read_write_addr;
    //assign address0_reg = write_data;
    
    mux4 vector_table_address_mux(
        .sel        (priority_select),
        .a          (addr0_reg),
        .b          (addr1_reg),
        .c          (addr2_reg),
        .d          (addr3_reg),
        .y          (isr_addr)
    );
    
    

endmodule
