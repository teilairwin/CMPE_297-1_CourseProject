`timescale 1ns / 1ps

module dut_wrapper_v4 #
(
    parameter integer C_S_AXI_DATA_WIDTH	= 32
)
(
    // AXI-DUT interface ports
    input [C_S_AXI_DATA_WIDTH-1:0] read_from_slv_reg0, // Sys control
    input [C_S_AXI_DATA_WIDTH-1:0] read_from_slv_reg1, // RF_ADDR
    input [C_S_AXI_DATA_WIDTH-1:0] read_from_slv_reg2, // ROM_CTRL
    input [C_S_AXI_DATA_WIDTH-1:0] read_from_slv_reg3, // ROM_DATA
    input [C_S_AXI_DATA_WIDTH-1:0] read_from_slv_reg4, // TBD
    output [C_S_AXI_DATA_WIDTH-1:0] write_to_slv_reg5, // MIPS PC
    output [C_S_AXI_DATA_WIDTH-1:0] write_to_slv_reg6, // ROM
    output [C_S_AXI_DATA_WIDTH-1:0] write_to_slv_reg7, // RF
    
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

    wire rom_we;
    wire rom_select;
    wire [5:0] rom_addr;
    wire [31:0] rom_wd;
    wire [31:0] rom_rd;

    ///////////////////////////////////////////////////////////////////////////
    /// AXI-Wrapper Connections
    ///////////////////////////////////////////////////////////////////////////
    
    //Input: Reg0 AXI-Control 
    assign rst_host = read_from_slv_reg0[0];
    assign clk_host = read_from_slv_reg0[1];
    assign clk_select = read_from_slv_reg0[2];
    //Input: Reg1 AXI-RegFileAddr
    assign mips_rf_addr = read_from_slv_reg1[4:0];
    
    //TODO
    //Input: Reg2 AXI-RomControl
    assign rom_we = read_from_slv_reg2[0];
    assign rom_addr = read_from_slv_reg2[6:1];
    assign rom_select = read_from_slv_reg2[7];
    //Input: Reg3 AXI-RomData
    assign rom_wd = read_from_slv_reg3; 

    //Output: Reg5 Current PC
    assign write_to_slv_reg5 = mips_pc_current;
    //Output: Reg6 TBD
    assign write_to_slv_reg6 = rom_rd;
    //Output: Reg7 TBD
    assign write_to_slv_reg7 = mips_rf_data;

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
        .mips_rf_data(mips_rf_data),
        
        .rom_we(rom_we),
        .rom_select(rom_select),
        .rom_addr(rom_addr),
        .rom_wd(rom_wd),
        .rom_rd(rom_rd)
    );
    
endmodule
