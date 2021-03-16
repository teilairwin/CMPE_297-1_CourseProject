module intc_top(
        input   wire [3:0] done,
        input   wire IACK,
        input   wire clk,
        input   wire [31:0] read_write_addr,
        input   wire write_enable,
        input   wire [31:0] write_data,
        output  wire [31:0] read_data, 
        output  wire IRQ,
        output  wire [31:0] isr_addr
    );
    
    
    intc intc(
        .done    (done),
        .input_addr (read_write_addr),
        .write_data (write_data),
        .write_enable (write_enable),
        .IACK    (IACK),
        .clk     (clk),
        .IRQ     (IRQ),
        .isr_addr    (isr_addr),
        .read_data (read_data)
    );
    
    // address vector table
    
    
    

endmodule
