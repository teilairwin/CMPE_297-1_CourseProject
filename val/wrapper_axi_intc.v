module wrapper_axi_intc #(parameter integer C_S_AXI_DATA_WIDTH	= 32)(
    // AXI-DUT interface ports
    input [C_S_AXI_DATA_WIDTH-1:0] read_from_slv_reg0, // config
    input [C_S_AXI_DATA_WIDTH-1:0] read_from_slv_reg1, // control
    input [C_S_AXI_DATA_WIDTH-1:0] read_from_slv_reg2, // switches
    input [C_S_AXI_DATA_WIDTH-1:0] read_from_slv_reg3, // buttons
    input [C_S_AXI_DATA_WIDTH-1:0] read_from_slv_reg4, // button behavior
    output [C_S_AXI_DATA_WIDTH-1:0] write_to_slv_reg5, // leds
    output [C_S_AXI_DATA_WIDTH-1:0] write_to_slv_reg6, // 7seg
    output [C_S_AXI_DATA_WIDTH-1:0] write_to_slv_reg7 // status
    
    );
    
    
    intc_top DUT (
    .done       (done),
    .IACK       (IACK),
    .clk        (sysclk),
    .input_addr (input_addr),
    .write_enable (write_enable),
    .write_data (write_data),
    .read_data  (read_data), 
    .IRQ        (IRQ),
    .isr_addr   (isr_addr)
    ); 
endmodule
