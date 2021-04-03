`timescale 1ns / 1ps

module intc_dut_wrapper #
(
    parameter integer C_S_AXI_DATA_WIDTH	= 32
)
(
    // AXI-DUT interface ports
    input [C_S_AXI_DATA_WIDTH-1:0] read_from_slv_reg0, // done
    input [C_S_AXI_DATA_WIDTH-1:0] read_from_slv_reg1, // input_addr
    input [C_S_AXI_DATA_WIDTH-1:0] read_from_slv_reg2, // write_data
    input [C_S_AXI_DATA_WIDTH-1:0] read_from_slv_reg3, // write_enable
    input [C_S_AXI_DATA_WIDTH-1:0] read_from_slv_reg4, // TBD
    output [C_S_AXI_DATA_WIDTH-1:0] write_to_slv_reg5, // IRQ
    output [C_S_AXI_DATA_WIDTH-1:0] write_to_slv_reg6, // isr_address
    output [C_S_AXI_DATA_WIDTH-1:0] write_to_slv_reg7, // read_data
    
    // DUT ports
    input sysclk
);

    ///////////////////////////////////////////////////////////////////////////
    /// Wrapper Signals
    ///////////////////////////////////////////////////////////////////////////
    wire [3:0] done;
    wire [31:0] input_addr;
    wire [31:0] write_data;
    wire write_enable;
    wire iack;
    wire irq;
    wire [31:0] isr_addr;
    wire [31:0] read_data;
    
    reg [30:0] spare;
    
    ///////////////////////////////////////////////////////////////////////////
    /// AXI-Wrapper Connections
    ///////////////////////////////////////////////////////////////////////////
    // Input: Reg0 done
    assign done = read_from_slv_reg0[3:0];
    // Input: Reg1 input address
    assign input_addr = read_from_slv_reg1;
    // Input: Reg2 write data
    assign write_data = read_from_slv_reg2;    
    // Input: Reg3 write enable
    assign write_enable = read_from_slv_reg3[0]; 
    // Input: Reg4 TBD
    // assign write_enable = read_from_slv_reg3[0];   
    // Output: Reg5 IRQ
    assign write_to_slv_reg5 = {irq,spare};
    // Output: Reg6 ISR address
    assign write_to_slv_reg6 = isr_addr;
    // Output: Reg6 ISR address
    assign write_to_slv_reg7 = read_data;
        
    ///////////////////////////////////////////////////////////////////////////
    //DUT
    ///////////////////////////////////////////////////////////////////////////
    intc_top DUT(
        .done(done),
        .IACK(iack),
        .clk(sysclk),//TODO: update
        .input_addr(input_addr),
        .write_enable(write_enable),
        .write_data(write_data),
        .read_data(read_data),
        .IRQ(irq),
        .isr_addr(isr_addr)
    );
    
    initial begin
        spare = 30'b0;
    end
    
endmodule
