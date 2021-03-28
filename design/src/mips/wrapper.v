/*
`timescale 1ns / 1ps

module dut_wrapper #
(
    parameter integer C_S_AXI_DATA_WIDTH	= 32
)
(
    // AXI-DUT interface ports
    input [C_S_AXI_DATA_WIDTH-1:0] read_from_slv_reg0, // config
    input [C_S_AXI_DATA_WIDTH-1:0] read_from_slv_reg1, // control
    input [C_S_AXI_DATA_WIDTH-1:0] read_from_slv_reg2, // switches
    input [C_S_AXI_DATA_WIDTH-1:0] read_from_slv_reg3, // buttons
    input [C_S_AXI_DATA_WIDTH-1:0] read_from_slv_reg4, // button behavior
    output [C_S_AXI_DATA_WIDTH-1:0] write_to_slv_reg5, // leds
    output [C_S_AXI_DATA_WIDTH-1:0] write_to_slv_reg6, // 7seg
    output [C_S_AXI_DATA_WIDTH-1:0] write_to_slv_reg7, // status
    
    // DUT ports
    input sysclk
);
    // assign write_to_slv_reg5 = 0; // leds
//    assign write_to_slv_reg6 = 0; // 7seg
    assign write_to_slv_reg7 = 0;
    
    // define switch usage: use read_from_slv_reg2
    wire [8:0] switches;
    assign switches = read_from_slv_reg2[8:0];

    // define button usage: use read_from_slv_reg3
    wire rst, button;
    assign {rst, button} = read_from_slv_reg3[1:0];

    // define led usage: use write_to_slv_reg5
    wire we_dm;
    assign write_to_slv_reg5[0] = we_dm;
    assign write_to_slv_reg5[31:1] = 0;

    // define 7seg usage
    wire [3:0] LEDSEL;
    wire [7:0] LEDOUT;
    wire [31:0] LEDOUT_all;
    assign write_to_slv_reg6 = LEDOUT_all; // 7seg
	 
    mips_fpga DUT(
        .clk100MHz(sysclk),
        //--
        .rst(rst),
        .button(button),
        .switches(switches),
        .we_dm(we_dm),
        //--
        .LEDSEL(LEDSEL),
        .LEDOUT(LEDOUT)
    );
    
    _7seg_cap _7seg_cap(
        .sysclk(sysclk),
        .LEDOUT(LEDOUT),
        .LEDSEL(LEDSEL),
        .LEDOUT_all(LEDOUT_all)
    );
endmodule
*/
