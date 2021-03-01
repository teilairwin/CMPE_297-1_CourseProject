module fpga_top (
        input  wire        rst,
        input  wire        clk100MHz,
        input  wire        Sel,
        input  wire  [3:0] n,
        output wire  [3:0] LEDSEL,
        output wire  [7:0] LEDOUT,
        output wire        dispSe, // indicate selection of upper halfword
        output wire        factErr
    );
    wire  [15:0] hex;
    wire        clk_sec;
    wire        clk_5KHz;
    wire        clk_pb;
    
    wire [31:0] gpI1;
    wire [31:0] gpO1;
    wire [31:0] gpO2;

    assign gpI1    = {27'b0, Sel, n[3:0]};
    assign dispSe  = gpO1[4];
    assign factErr = gpO1[0];

    clk_gen top_clk_gen (
            .clk100MHz          (clk100MHz),
            .rst                (rst),
            .clk_4sec           (clk_sec),
            .clk_5KHz           (clk_5KHz)
        );

    system system (
            .clk                (clk_5KHz),
            .rst                (rst),
            .gpI1               (gpI1), // sel and n[3:0]
            .gpI2               (gpO1),
            .gpO1               (gpO1),
            .gpO2               (gpO2)
        );

    assign hex = dispSe ? gpO2[31:16] : gpO2[15:0];

    // -- this is disp_hex_mux
    wire [7:0]  digit0;
    wire [7:0]  digit1;
    wire [7:0]  digit2;
    wire [7:0]  digit3;

    hex_to_7seg hex3 (
            .HEX                (hex[15:12]),
            .s                  (digit3)
        );

    hex_to_7seg hex2 (
            .HEX                (hex[11:8]),
            .s                  (digit2)
        );

    hex_to_7seg hex1 (
            .HEX                (hex[7:4]),
            .s                  (digit1)
        );

    hex_to_7seg hex0 (
            .HEX                (hex[3:0]),
            .s                  (digit0)
        );

    led_mux led_mux (
            .clk                (clk_5KHz),
            .rst                (rst),
            .LED3               (digit3),
            .LED2               (digit2),
            .LED1               (digit1),
            .LED0               (digit0),
            .LEDSEL             (LEDSEL),
            .LEDOUT             (LEDOUT)
        );
    // -- disp_hex_mux

endmodule
