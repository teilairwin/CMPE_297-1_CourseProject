`timescale 1ns / 1ps

module dut_wrapper_v4 #
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
    wire       Sel;
    wire [3:0] n;
    assign {Sel, n[3:0]} = read_from_slv_reg2[4:0];

    // define button usage: use read_from_slv_reg3
    wire rst;
    assign rst = read_from_slv_reg3[0];

    // // define led usage: use write_to_slv_reg5
    // wire dispSe, factErr;
    // assign write_to_slv_reg5[ 4: 0] = {dispSe, factErr, factErr, factErr, factErr};
    // assign write_to_slv_reg5[31:5] = 27'b0;

    // // define 7seg usage
    // wire [3:0] LEDSEL;
    // wire [7:0] LEDOUT;
    // wire [31:0] LEDOUT_all;
    // assign write_to_slv_reg6 = LEDOUT_all; // 7seg
 
    fpga_top DUT(
        .clk100MHz(sysclk),
        //--
        // switches
        .Sel(Sel),
        .n(n),
        // buttons
        .rst(rst)
    );
    
endmodule
