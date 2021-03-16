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
        output wire [31:0] wd_mm0,
        output wire [31:0] wd_mm1,
        output wire [31:0] wd_mm2,
        output wire [31:0] wd_mm3,
        output wire [31:0] rd_mm0,
        output wire [31:0] rd_mm1,
        output wire [31:0] rd_mm2,
        output wire [31:0] rd_mm3,
        output wire [31:0] rd3,
        // fix for multM_reg/q_reg
        output wire multM_reg_fixme
    );


    wire [31:0] DMemData0, DMemData1, DMemData2, DMemData3;
    wire [31:0] FactData0, FactData1, FactData2, FactData3;
    wire [31:0] GPIOData0, GPIOData1, GPIOData2, GPIOData3;
    wire [31:0] ReadData0, ReadData1, ReadData2, ReadData3;
  
    wire [31:0] rd_dm0, rd_dm1, rd_dm2, rd_dm3;
    wire        WE1, WE2;
    wire        WEM0, WEM1, WEM2, WEM3;
    wire        we_dm0, we_dm1, we_dm2, we_dm3;
    wire [ 3:0] Done;             // Using vector for Done signals

    //wire [31:0] DMemData, FactData, GPIOData, ReadData, rd_dm;
    //wire        WE1, WE2, WEM, we_dm, done0;
    wire [ 1:0] RdSel;
  
    wire [31:0] instrP, instrE;
	  wire [31:0] irq_addr;
    wire irq_ack, irq; //move to mips output


    assign rd_mm0 = ReadData0;
    assign rd_mm1 = ReadData1;
    assign rd_mm2 = ReadData2;
    assign rd_mm3 = ReadData3;
    assign DMemData0 = rd_dm0;
    assign DMemData1 = rd_dm1;
    assign DMemData2 = rd_dm2;
    assign DMemData3 = rd_dm3;
    assign we_dm0 = WEM0;
    assign we_dm1 = WEM1;
    assign we_dm2 = WEM2;
    assign we_dm3 = WEM3;

    // -- assignment_3/mips_top
    // note: some _dm signals have been replaced with _mm signals
    wire [31:0] DONT_USE;

    mips4 mips4 (
        .clk          (clk),
        .rst          (rst),
        .ra3          (ra3),

        .rd_dm0       (rd_mm0),
        .rd_dm1       (rd_mm1),
        .rd_dm2       (rd_mm2),
        .rd_dm3       (rd_mm3),

        .wd_dm0       (wd_mm0),
        .wd_dm1       (wd_mm1),
        .wd_dm2       (wd_mm2),
        .wd_dm3       (wd_mm3),
 
      
        .instrP       (instrP),
		    .instrE       (instrE),
        //.rd_dm        (rd_mm),
        .we_dm        (we_mm),
        .pc_current   (pc_current),
        .alu_out      (alu_out),
        //.wd_dm        (wd_mm),
        .rd3          (rd3),
		    .irq          (irq),
        .irq_ack      (irq_ack),
        .irq_addr     (irq_addr)

    );

    imem imem (
        .a            (pc_current[7:2]),
        .y            (instrP)
    );
	
	imem emem (
        .a            (pc_current[7:2]),
        .y            (instrE)
	);

    dmem4 dmem4 (
        .clk          (clk),
        .we           (we_dm),
        .a            (alu_out[7:2]),
        .d0           (wd_mm0),
        .d1           (wd_mm1),
        .d2           (wd_mm2),
        .d3           (wd_mm3),
        .q0           (rd_dm0),
        .q1           (rd_dm1),
        .q2           (rd_dm2),
        .q3           (rd_dm3)
    );


    address_decoder addr_decoder4(
        .WE           (we_mm),
        .A            ({20'b0, alu_out[11:4], 4'b0}),
        .WE2          (WE2),
        .WE1          (WE1),
        .WEM0         (WEM0),
        .WEM1         (WEM1),
        .WEM2         (WEM2),
        .WEM3         (WEM3),
        .RdSel        (RdSel)
    );

    // Factorial Unit 0
    fact_top fact_top0(
        .clk          (clk),
        .rst          (rst),
        .A            (alu_out[3:2]),   // Todo - Different signal?
        .WE           (WE1),            // Todo - Different signal?
        .WD           (wd_mm0),
        .RD           (FactData0),
        .Done         (Done[0])
    );
    // Factorial Unit 1
    fact_top fact_top1(
        .clk          (clk),
        .rst          (rst),
        .A            (alu_out[3:2]),   // Todo - Different signal?
        .WE           (WE1),            // Todo - Different signal?
        .WD           (wd_mm1),
        .RD           (FactData1),
        .Done         (Done[1])
    );

    // Factorial Unit 2
    fact_top fact_top2(
        .clk          (clk),
        .rst          (rst),
        .A            (alu_out[3:2]),   // Todo - Different signal?
        .WE           (WE1),            // Todo - Different signal?
        .WD           (wd_mm2),
        .RD           (FactData2),
        .Done         (Done[2])
    );

    // Factorial Unit 3
    fact_top fact_top3(
        .clk          (clk),
        .rst          (rst),
        .A            (alu_out[3:2]),   // Todo - Different signal?
        .WE           (WE1),            // Todo - Different signal?
        .WD           (wd_mm3),
        .RD           (FactData3),
        .Done         (Done[3])
    );

    gpio_top4 gpio_top4(
        .clk          (clk),
        .rst          (rst),
        .A            (alu_out[3:2]),
        .WE           (WE2),
        .WD0          (wd_mm0),
        .WD1          (wd_mm1),
        .WD2          (wd_mm2),
        .WD3          (wd_mm3),
        .RD0          (GPIOData0),
        .RD1          (GPIOData1),
        .RD2          (GPIOData2),
        .RD3          (GPIOData3),
        .gpI1         (gpI1),
        .gpI2         (gpI2),
        .gpO1         (gpO1),
        .gpO2         (gpO2)
    );

    mux4 mux4_0(
        .sel          (RdSel),
        .a            (DMemData0),
        .b            (DMemData0),
        .c            (FactData0),
        .d            (GPIOData0),
        .y            (ReadData0)
    );
    
    mux4 mux4_1(
        .sel          (RdSel),
        .a            (DMemData1),
        .b            (DMemData1),
        .c            (FactData1),
        .d            (GPIOData1),
        .y            (ReadData1)
    );
    
    mux4 mux4_2(
        .sel          (RdSel),
        .a            (DMemData2),
        .b            (DMemData2),
        .c            (FactData2),
        .d            (GPIOData2),
        .y            (ReadData2)
    );
    
    mux4 mux4_3(
        .sel          (RdSel),
        .a            (DMemData3),
        .b            (DMemData3),
        .c            (FactData3),
        .d            (GPIOData3),
        .y            (ReadData3)
    );
    
    
    intc interrupt_controller(
      .interrupt_0_done (Done[0]),
      .interrupt_1_done (Done[1]),
      .interrupt_2_done (Done[2]),
      .interrupt_3_done (Done[3]),
        .IACK             (irq_ack), //ADD TO MIPS
        .clk              (clk),
        .IRQ              (irq),  //ADD TO MIPS
        .ADDR             (irq_addr) // ADD TO MIPS
    );

endmodule
