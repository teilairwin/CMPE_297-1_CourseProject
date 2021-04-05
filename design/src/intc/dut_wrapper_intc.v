`timescale 1ns / 1ps

module dut_wrapper_intc #
(
    parameter integer C_S_AXI_DATA_WIDTH	= 32
)
(
    // AXI-DUT interface ports
    input [C_S_AXI_DATA_WIDTH-1:0] read_from_slv_reg0, // done,IACK
    input [C_S_AXI_DATA_WIDTH-1:0] read_from_slv_reg1, // input_addr
    input [C_S_AXI_DATA_WIDTH-1:0] read_from_slv_reg2, // write_data
    input [C_S_AXI_DATA_WIDTH-1:0] read_from_slv_reg3, // write_enable
    input [C_S_AXI_DATA_WIDTH-1:0] read_from_slv_reg4, // Control
    
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
    wire iack;
    
    wire [31:0] input_addr;
    wire [31:0] write_data;
    wire write_enable;
    
    wire rst_host;    //Host reset
    wire clk_host;    //Host clock source
    wire clk_select;  //Host clock select
    wire clk_sec; //Unused
    wire clk_5KHz;    //5KHz clock source
    wire clk_system;  //Selected System Clock
    
    wire irq;
    wire [31:0] isr_addr;
    wire [31:0] read_data;
    
    reg [31:0] spare;
    
    ///////////////////////////////////////////////////////////////////////////
    /// AXI-Wrapper Connections
    ///////////////////////////////////////////////////////////////////////////
    // Input: Reg0 done,iack
    assign done = read_from_slv_reg0[4:1];
    assign iack = read_from_slv_reg0[0];
    // Input: Reg1 input address
    assign input_addr = read_from_slv_reg1;
    // Input: Reg2 write data
    assign write_data = read_from_slv_reg2;    
    // Input: Reg3 write enable
    assign write_enable = read_from_slv_reg3[0]; 
    // Input: Reg4 Control
    assign clk_host = read_from_slv_reg4[0];
    assign clk_select = read_from_slv_reg4[1]; 
    assign rst_host = read_from_slv_reg4[2];
    
    // Output: Reg5 IRQ
    assign write_to_slv_reg5 = {spare[30:0],irq};
    // Output: Reg6 ISR address
    assign write_to_slv_reg6 = isr_addr;
    // Output: Reg7 read data
    assign write_to_slv_reg7 = read_data;
    
    //System Clock Gen
    clk_gen top_clk_gen (
        .clk100MHz(sysclk),
        .rst(rst_host),
        .clk_4sec(clk_sec),
        .clk_5KHz(clk_5KHz)
    );

    //System Clock Select
    mux2 #(1) mux_clk_select (
        .sel(clk_select),  ///< Host Select
        .a(clk_5KHz),      ///< Default Clock
        .b(clk_host),      ///< Host Clock
        .y(clk_system)     ///< Selected Clock Source
    );
    
        
    ///////////////////////////////////////////////////////////////////////////
    //DUT
    ///////////////////////////////////////////////////////////////////////////
    intc_top DUT(
        .done(done),
        .IACK(iack),
        .clk(clk_system),
        .rst(rst_host),
        .input_addr(input_addr),
        .write_enable(write_enable),
        .write_data(write_data),
        .read_data(read_data),
        .IRQ(irq),
        .isr_addr(isr_addr)
    );
    
    initial begin
        spare = 32'b0;
    end
    
endmodule
