module fpga_top (
    //Core
    input wire rst,        ///< System Reset
    input wire clk_100MHz, ///< 100MHz Clock Source
    input wire clk_host,   ///< Host Clock Source
    input wire clk_select, ///< Clock Source Select
    //Test Control
    input wire [4:0] mips_rf_addr,       ///< MIPS RegFile Addr to Read
    //Test Data
    output wire [31:0] mips_pc_current,  ///< Current PC of MIPS
    output wire [31:0] mips_rf_data,     ///< MIPS RegFile Data Read
    
     input wire pmem_we,         ///< WriteEnable to Load IMEM
     input wire [5:0] pmem_addr, ///< Addr for R/W to IMEM
     input wire [31:0] pmem_wd,  ///< WriteData to IMEM
     output wire [31:0] pmem_rd  ///< ReadData from IMEM
);

    ///////////////////////////////////////////////////////////////////////////
    /// Component Interconnections
    ///////////////////////////////////////////////////////////////////////////

    wire clk_sec;
    wire clk_5KHz;
    wire clk_system;
    
    ///////////////////////////////////////////////////////////////////////////
    /// Components
    ///////////////////////////////////////////////////////////////////////////
    
    //System Clock Gen
    clk_gen top_clk_gen (
        .clk100MHz(clk_100MHz),
        .rst(rst),
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

    //System 
    system system (
        //Core
        .sys_clk(clk_system),
        .sys_rst(rst),
        //Test Data
        //--MIPS
        .pc_current(mips_pc_current),
        .mips_rf_addr(mips_rf_addr),
        .mips_rf_data(mips_rf_data),
        //--IMEM
        .pmem_we(pmem_we),
        .pmem_addr(pmem_addr),
        .pmem_wd(pmem_wd),
        .pmem_rd(pmem_rd)
    );

endmodule
