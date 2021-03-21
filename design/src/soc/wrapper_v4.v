`timescale 1ns / 1ps

module dut_wrapper_v4 #
(
    parameter integer C_S_AXI_DATA_WIDTH	= 32
)
(
    // AXI-DUT interface ports
    input [C_S_AXI_DATA_WIDTH-1:0] read_from_slv_reg0, // control
    input [C_S_AXI_DATA_WIDTH-1:0] read_from_slv_reg1, // RF_ADDR
    input [C_S_AXI_DATA_WIDTH-1:0] read_from_slv_reg2, // TBD
    input [C_S_AXI_DATA_WIDTH-1:0] read_from_slv_reg3, // TBD
    input [C_S_AXI_DATA_WIDTH-1:0] read_from_slv_reg4, // TBD
    output [C_S_AXI_DATA_WIDTH-1:0] write_to_slv_reg5, // MIPS PC
    output [C_S_AXI_DATA_WIDTH-1:0] write_to_slv_reg6, // RF_DATA
    output [C_S_AXI_DATA_WIDTH-1:0] write_to_slv_reg7, // TBD
    
    // DUT ports
    input sysclk
);

    ///////////////////////////////////////////////////////////////////////////
    /// Wrapper Signals
    ///////////////////////////////////////////////////////////////////////////
    wire rst_host;
    wire clk_host;
    wire clk_select;
    
    wire [31:0] mips_pc_current;
    wire [4:0] mips_rf_addr;
    wire [31:0] mips_rf_data;

    ///////////////////////////////////////////////////////////////////////////
    /// AXI-Wrapper Connections
    ///////////////////////////////////////////////////////////////////////////
    
    //Input: Reg0 AXI-Control 
    assign rst_host = read_from_slv_reg0[0];
    assign clk_host = read_from_slv_reg0[1];
    assign clk_select = read_from_slv_reg0[2];
    //Input: Reg1 AXI-RegFileAddr
    assign mips_rf_addr = read_from_slv_reg1[4:0];

    //Output: Reg5 Current PC
    assign write_to_slv_reg5 = mips_pc_current;
    //Output: Reg6 TBD
    assign write_to_slv_reg6 = mips_rf_data;
    //Output: Reg7 TBD
    assign write_to_slv_reg7 = 0;

    ///////////////////////////////////////////////////////////////////////////
    //DUT
    ///////////////////////////////////////////////////////////////////////////
    fpga_top DUT(
        //Core
        .rst(rst_host),
        .clk_100MHz(sysclk),
        .clk_host(clk_host),
        .clk_select(clk_select),
        //Test Control
        .mips_rf_addr(mips_rf_addr),
        //Test Data
        .mips_pc_current(mips_pc_current),
        .mips_rf_data(mips_rf_data)
    );
    
endmodule
