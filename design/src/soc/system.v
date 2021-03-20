module system (
        input  wire        clk,
        input  wire        rst,
        input  wire [4:0]  ra3,
        output wire        we_mm,
        output wire [31:0] pc_current,
        output wire [31:0] instrE,
        output wire [31:0] instrP,
        output wire [31:0] alu_out,
        output wire [31:0] wd_mm,
        output wire [31:0] rd_mm,
        output wire [31:0] rd3
    );


    wire [31:0] DMemData, ReadData;
    wire [31:0] FactData0, FactData1, FactData2, FactData3;
    wire [31:0] rd_dm;
    wire        WE1, WE2;
    wire        WEM;
    wire        we_dm;
    wire [ 3:0] Done;
    wire [ 2:0] RdSel;
    wire [31:0] instrP, instrE;
    wire [31:0] irq_addr;
    wire irq_ack, irq;

    assign rd_mm = ReadData;
    assign DMemData = rd_dm;
    assign we_dm = WEM;

    // note: some _dm signals have been replaced with _mm signals
    wire [31:0] DONT_USE;

    mips mips (
        .clk          (clk),
        .rst          (rst),
        .ra3          (ra3),
        .instrP       (instrP),
        .instrE       (instrE),
        .rd_dm        (rd_mm),
        .we_dm        (we_mm),
        .pc_current   (pc_current),
        .alu_out      (alu_out),
        .wd_dm        (wd_mm),
        .rd3          (rd3),
        .irq          (irq),
        .irq_ack      (irq_ack),
        .irq_addr     (irq_addr)
    );

    // Program Memory
    imem imem (
        .a            (pc_current[7:2]),
        .y            (instrP)
    );

    // External Memory
    imem emem (
        .a            (pc_current[7:2]),
        .y            (instrE)
    );

    dmem dmem (
        .clk          (clk),
        .we           (we_dm),
        .a            (alu_out[7:2]),
        .d            (wd_mm),
        .q            (rd_dm)
    );

    // // Swap out Address Decoder with Memory Map
    // address_decoder addr_decoder(
    //     .WE           (we_mm),
    //     .A            ({20'b0, alu_out[11:4], 4'b0}),
    //     .WE2          (WE2),
    //     .WE1          (WE1),
    //     .WEM0         (WEM0),
    //     .WEM1         (WEM1),
    //     .WEM2         (WEM2),
    //     .WEM3         (WEM3),
    //     .RdSel        (RdSel[1:0])   // Need this to be 3 bits.
    // );

    // mux6 mux6(
    //     .sel          (RdSel),
    //     .a            (DMemData),
    //     .b            (FactData0),
    //     .c            (FactData1),
    //     .d            (FactData2),
    //     .e            (FactData3),
    //     .f            (irq),        //TBD
    //     .y            (ReadData)
    // );

    memory_map_top memory_map_top(
        write_enable    (write_enable),
        input_address   (input_address),
        input_data      (input_data),
        fact0_data      (fact0_data),
        fact1_data      (fact1_data),
        fact2_data      (fact2_data),
        fact3_data      (fact3_data),
        fact0_addr      (fact0_addr),
        fact1_addr      (fact1_addr),
        fact2_addr      (fact2_addr),
        fact3_addr      (fact3_addr),
        dm_we           (dm_we),
        intc_we         (intc_we),
        fact0_we        (fact0_we),
        fact1_we        (fact1_we),
        fact2_we        (fact2_we),
        fact3_we        (fact3_we),
        dm_addr         (dm_addr),
        intc_addr       (intc_addr),
        dm_data         (dm_data),
        intc_data       (intc_data)
    );

    // Factorial Unit 0
    fact_top fact_top0(
        .clk          (clk),
        .rst          (rst),
        .A            (alu_out[3:2]),
        .WE           (WE1),
        .WD           (wd_mm0),
        .RD           (FactData0),
        .Done         (Done[0])
    );

    // Factorial Unit 1
    fact_top fact_top1(
        .clk          (clk),
        .rst          (rst),
        .A            (alu_out[3:2]),
        .WE           (WE1),
        .WD           (wd_mm1),
        .RD           (FactData1),
        .Done         (Done[1])
    );

    // Factorial Unit 2
    fact_top fact_top2(
        .clk          (clk),
        .rst          (rst),
        .A            (alu_out[3:2]),
        .WE           (WE1),
        .WD           (wd_mm2),
        .RD           (FactData2),
        .Done         (Done[2])
    );

    // Factorial Unit 3
    fact_top fact_top3(
        .clk          (clk),
        .rst          (rst),
        .A            (alu_out[3:2]),
        .WE           (WE1),
        .WD           (wd_mm3),
        .RD           (FactData3),
        .Done         (Done[3])
    );
    
    intc interrupt_controller(
        .clk              (clk),
        .interrupt_0_done (Done[0]),
        .interrupt_1_done (Done[1]),
        .interrupt_2_done (Done[2]),
        .interrupt_3_done (Done[3]),
        .IACK             (irq_ack),
        .IRQ              (irq),
        .ADDR             (irq_addr)
    );

endmodule
