module system (
        input  wire        clk,
        input  wire        rst,
        input  wire [31:0] gpI1,
        input  wire [31:0] gpI2,
        output wire [31:0] gpO1,
        output wire [31:0] gpO2,
        // used for exposing system data sources
        input  wire [4:0]  ra3,
        output wire        we_mm,
        output wire [31:0] pc_current,
        output wire [31:0] instr,
        output wire [31:0] alu_out,
        output wire [31:0] wd_mm,
        output wire [31:0] rd_mm,
        output wire [31:0] rd3,
        // fix for multM_reg/q_reg
        output wire multM_reg_fixme
    );

    wire [31:0] DMemData, FactData0, FactData1, FactData2, FactData3, GPIOData, ReadData, rd_dm;
    wire        WE1, WE2, WEM, we_dm;
    wire [ 1:0] RdSel;
    wire [ 3:0] Done;
    wire        iack, irq, addr;

    assign rd_mm = ReadData;
    assign DMemData = rd_dm;
    assign we_dm = WEM;

    // -- assignment_3/mips_top
    // note: some _dm signals have been replaced with _mm signals
    wire [31:0] DONT_USE;

    mips mips (
        .clk          (clk),
        .rst          (rst),
        .ra3          (ra3),
        .instr        (instr),
        .rd_dm        (rd_mm),
        .we_dm        (we_mm),
        .pc_current   (pc_current),
        .alu_out      (alu_out),
        .wd_dm        (wd_mm),
        .rd3          (rd3)
    );

    imem imem (
        .a            (pc_current[7:2]),
        .y            (instr)
    );

    dmem dmem (
        .clk          (clk),
        .we           (we_dm),
        .a            (alu_out[7:2]),
        .d            (wd_mm),
        .q            (rd_dm)
    );
    // -- assignment_3/mips_top

    address_decoder addr_decoder(
        .WE           (we_mm),
        .A            ({20'b0, alu_out[11:4], 4'b0}),
        .WE2          (WE2),
        .WE1          (WE1),
        .WEM          (WEM),
        .RdSel        (RdSel)
    );


    fact_top fact_top0(
        .clk          (clk),
        .rst          (rst),
        .A            (alu_out[3:2]),
        .WE           (WE1),
        .WD           (wd_mm),
        .RD           (FactData0),
        .Done         (Done[0])
    );


    fact_top fact_top1(
        .clk          (clk),
        .rst          (rst),
        .A            (alu_out[3:2]),
        .WE           (WE1),
        .WD           (wd_mm),
        .RD           (FactData1),
        .Done         (Done[1])
    );


    fact_top fact_top2(
        .clk          (clk),
        .rst          (rst),
        .A            (alu_out[3:2]),
        .WE           (WE1),
        .WD           (wd_mm),
        .RD           (FactData2),
        .Done         (Done[2])
    );


    fact_top fact_top3(
        .clk          (clk),
        .rst          (rst),
        .A            (alu_out[3:2]),
        .WE           (WE1),
        .WD           (wd_mm),
        .RD           (FactData3),
        .Done         (Done[3])
    );

    gpio_top gpio_top(
        .clk          (clk),
        .rst          (rst),
        .A            (alu_out[3:2]),
        .WE           (WE2),
        .WD           (wd_mm),
        .RD           (GPIOData),
        .gpI1         (gpI1),
        .gpI2         (gpI2),
        .gpO1         (gpO1),
        .gpO2         (gpO2)
    );

    mux4 mux4(
        .sel          (RdSel),
        .a            (DMemData),
        .b            (DMemData),
        .c            (FactData),
        .d            (GPIOData),
        .y            (ReadData)
    );
    
    intc intc(
        .iack         (iack),
        .Done         (Done),
        .irq          (irq),
        .addr         (addr)
    );

endmodule
