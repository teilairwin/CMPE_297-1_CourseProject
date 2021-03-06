module system (
        //Core Signals
        //--Control
        input  wire        sys_clk,   ///< System Clock
        input  wire        sys_rst,   ///< System Reset
        
        //External/Test Component Access
        //--MIPS
        output wire [31:0] pc_current,  
        input  wire [4:0]  mips_rf_addr,   ///< RegFile Addr
        output wire [31:0] mips_rf_data,   ///< RegFile Data
        //--ROM - PMEM/EMEM
        input wire rom_we,          ///< WriteEnable to Load ROM
        input wire rom_select,      ///< ROM Select
        input wire [5:0] rom_addr,  ///< Addr for R/W to IMEM
        input wire [31:0] rom_wd,   ///< WriteData to IMEM
        output wire [31:0] rom_rd,  ///< ReadData from IMEM
        //--INTC - Unused
        input wire [31:0] intc_test
    );

    ///////////////////////////////////////////////////////////////////////////
    /// Component Interconnections
    ///////////////////////////////////////////////////////////////////////////

    //MIPS-IMEM/EMEM connections
    wire [31:0] instrP, instrE;    ///< Program,Exception Instruction Data
    //TEST-IMEM/EMEM connections
    wire rom_pmem_we, rom_emem_we; ///< ROM Write Enables
    wire [31:0] rom_pmem_rd;       ///< Program ROM Read
    wire [31:0] rom_emem_rd;       ///< Excetion ROM Read

    //MIPS-INTC connections
    wire [31:0] irq_addr;   ///< IRQ Address
    wire irq_ack;           ///< IRQ ACK Mips->Intc       
    wire irq;               ///< IRQ Intc->Mips

    //MIPS-MM connections
    wire mm_write_enable;       ///< MMDevice WriteEnable
    wire [31:0] mm_input_addr;  ///< MMDevice Address
    wire [31:0] mm_input_data;  ///< MMDevice Write Data
    wire [31:0] mm_output_data; ///< MMDevice Read Data
    wire mm_data_valid;         ///< MMDEvice Data Valid [TODO]

    //MM-DMEM connections
    wire dm_we;            ///< DataMem WriteEnable
    wire [31:0] dm_addr;   ///< DataMem Addr
    wire [31:0] dm_wdata;  ///< DataMem WriteData
    wire [31:0] dm_rdata;  ///< DataMem ReadData
    //MM-INTC Connections
    wire intc_we;            ///< INTC WriteEnable
    wire [31:0] intc_addr;   ///< INTC Addr
    wire [31:0] intc_wdata;  ///< INTC WriteData
    wire [31:0] intc_rdata;  ///< INTC ReadData
    //MM-FACT Connections
    wire [3:0] fact_we;           ///< FACT WriteEnable
    wire [31:0] fact_addr [3:0];  ///< FACT Addr 
    wire [31:0] fact_wdata [3:0]; ///< FACT WriteData
    wire [31:0] fact_rdata [3:0]; ///< FACT ReadData

    //INTC-FACT Connections
    wire [3:0] fact_done;

    ///////////////////////////////////////////////////////////////////////////
    /// System Components
    ///////////////////////////////////////////////////////////////////////////

    //System MIPS Processor
    mips mips (
        //Core
        .clk          (sys_clk),    ///< MIPS clock
        .rst          (sys_rst),    ///< MIPS reset
        .pc_current   (pc_current), ///< Current PC
        .instrP       (instrP),     ///< ProgramMem Instruction
        .instrE       (instrE),     ///< ExceptionMem Instruction
        //MemoryMapped Device Access
        .rd_dm        (mm_output_data),     ///< MMDevice ReadData    
        .we_dm        (mm_write_enable),    ///< MMDevice WriteEnable
        .alu_out      (mm_input_addr),      ///< MMDevice Address
        .wd_dm        (mm_input_data),      ///< MMDevice WriteData
        //External/Test
        .ra3          (mips_rf_addr),      ///< RegFile Addr     
        .rd3          (mips_rf_data),      ///< RegFile Data
        //Interrupt Handling
        .irq          (irq),       ///< External interrupt request
        .irq_addr     (irq_addr),  ///< Interrupt routine address
        .irq_ack      (irq_ack)    ///< Interrupt ack 
    );

    //ROM Access Select
    assign rom_pmem_we = rom_we & ~rom_select; //Sel=0
    assign rom_emem_we = rom_we & rom_select;  //Sel=1
    mux2 #32 mux_rom_read(
        .sel(rom_select),
        .a(rom_pmem_rd),  //Sel=0
        .b(rom_emem_rd),  //Sel=1
        .y(rom_rd)
    );
    
    //Program Memory
    rom_loadable pmem (
        .clk(sys_clk),
        .read_addr(pc_current[7:2]),
        .read_data(instrP),
        .write_enable(rom_pmem_we),
        .write_addr(rom_addr),
        .write_data(rom_wd),
        .read_data2(rom_pmem_rd)
    );

    //Exception Memory
    rom_loadable emem (
        .clk(sys_clk),
        .read_addr(pc_current[7:2]),
        .read_data(instrE),
        .write_enable(rom_emem_we),
        .write_addr(rom_addr),
        .write_data(rom_wd),
        .read_data2(rom_emem_rd)
    );

    //System Device Memory Map
    memory_map_top memory_map(
        //MIPS
        .write_enable    (mm_write_enable),
        .input_addr      (mm_input_addr),
        .input_data      (mm_input_data),
        .output_data     (mm_output_data),
        .data_valid      (mm_data_valid),
        //Device0 [DataMemory]
        .dm_we           (dm_we),
        .dm_addr         (dm_addr),
        .dm_wdata        (dm_wdata),
        .dm_rdata        (dm_rdata),                 
        //Device1 [InterruptController]
        .intc_we         (intc_we),
        .intc_addr       (intc_addr),
        .intc_wdata      (intc_wdata),
        .intc_rdata      (intc_rdata),
        //Device2 [Factorial0]
        .fact0_we        (fact_we[0]),
        .fact0_addr      (fact_addr[0]),
        .fact0_wdata     (fact_wdata[0]),
        .fact0_rdata     (fact_rdata[0]),
        //Device3 [Factorial1]
        .fact1_we        (fact_we[1]),
        .fact1_addr      (fact_addr[1]),
        .fact1_wdata     (fact_wdata[1]),
        .fact1_rdata     (fact_rdata[1]),
        //Device4 [Factorial2]
        .fact2_we        (fact_we[2]),
        .fact2_addr      (fact_addr[2]),
        .fact2_wdata     (fact_wdata[2]),
        .fact2_rdata     (fact_rdata[2]),        
        //Device5 [Factorial3]
        .fact3_we        (fact_we[3]),
        .fact3_addr      (fact_addr[3]),
        .fact3_wdata     (fact_wdata[3]),
        .fact3_rdata     (fact_rdata[3])   
    );

    //DataMemory [Device0]
    dmem dmem (
        .clk          (sys_clk),
        .we           (dm_we),
        .a            (dm_addr[7:2]),
        .d            (dm_wdata),
        .q            (dm_rdata) 
    );


    //InterruptController [Device1]
    intc_top intc(
        .clk(sys_clk),
        .rst(sys_rst),
        .done(fact_done),    ///< Factorial Device Interrupts
        .IRQ(irq),           ///< Processot Interrupt 
        .IACK(irq_ack),      ///< Processor Interrupt ACK
        .isr_addr(irq_addr), ///< Processor Interrupt Addr
        .input_addr(intc_addr),  ///< MMDevice Addr
        .write_enable(intc_we),  ///< MMDevice WriteEnable
        .write_data(intc_wdata), ///< MMDeivce WriteData
        .read_data(intc_rdata),  ///< MMDevice ReadData
        .test(intc_test) 
    ); 

    //Factorials [Device2,3,4,5]
    genvar ii;
    generate
        for(ii = 0; ii < 4; ii=ii+1) begin: fact_gen_loop
        fact_top fact(
            .clk(sys_clk),
            .rst(sys_rst),
            .A(fact_addr[ii][3:2]),
            .WE(fact_we[ii]),
            .WD(fact_wdata[ii]),
            .RD(fact_rdata[ii]),
            .Done(fact_done[ii])
        );
        end
    endgenerate
    
endmodule
