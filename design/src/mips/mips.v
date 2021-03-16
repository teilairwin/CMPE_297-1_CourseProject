module mips (
        input  wire        clk,
        input  wire        rst,
        input  wire [4:0]  ra3,
        input  wire [31:0] instrP,      //Program/I-MEM instruction
        input  wire [31:0] instrE,      //Exception/E-MEM instruction
        input  wire [31:0] rd_dm,
        output wire        we_dm,
        output wire [31:0] pc_current,
        output wire [31:0] alu_out,
        output wire [31:0] wd_dm,
        output wire [31:0] rd3,
        
        //Interrupt Handling
        //--Control
        input wire irq,             //External Interrupt Signal
        output wire irq_ack,        //ACK/Clear for the External Interrupt
        //--Data
        input wire [31:0] irq_addr  //Address of the Interrupt ISR
    );

    wire       branch;
    wire       jump;
    wire       reg_dst;
    wire       we_reg;
    wire       alu_src;
    wire       dm2reg;
    wire [3:0] alu_ctrl;
    wire       jal;
    wire       jr;
    wire       shmux;
    wire       mult_enable;
    wire       sfmux_high;
    wire       sf2reg;

    wire [31:0] instr;        //Final instruction selection
    wire irq_active;          //Whether interrupt context is active
    wire irq_entry;           //Whether about to handle interrupt
    wire irq_resume;          //Whether about to resume program
    assign irq_ack = irq_resume;

    //Select the source of the next instruction
    mux2 #(32) instr_select(
        .sel(irq_active),
        .a(instrP),    //By default use I-MEM
        .b(instrE),    //If in interrupt ctx, use E-MEM
        .y(instr)
    );

    //MIPS datapath
    datapath dp (
            .clk            (clk),
            .rst            (rst),
            .branch         (branch),
            .jump           (jump),
            .reg_dst        (reg_dst),
            .we_reg         (we_reg),
            .alu_src        (alu_src),
            .dm2reg         (dm2reg),
            .alu_ctrl       (alu_ctrl),
            .ra3            (ra3),
            .instr          (instr),
            .rd_dm          (rd_dm),
            .pc_current     (pc_current),
            .alu_out        (alu_out),
            .wd_dm          (wd_dm),
            .rd3            (rd3),
            .jal            (jal),
            .jr             (jr),
            .shmux          (shmux),
            .mult_enable    (mult_enable),
            .sfmux_high     (sfmux_high),
            .sf2reg         (sf2reg),
            //Interrupt Handling
            .irq_entry(irq_entry),
            .irq_resume(irq_resume),
            .irq_addr(irq_addr),
            .irq_active(irq_active)
        );

    //MIPS control unit
    controlunit cu (
            .opcode         (instr[31:26]),
            .funct          (instr[5:0]),
            .branch         (branch),
            .jump           (jump),
            .reg_dst        (reg_dst),
            .we_reg         (we_reg),
            .alu_src        (alu_src),
            .we_dm          (we_dm),
            .dm2reg         (dm2reg),
            .alu_ctrl       (alu_ctrl),
            .jal            (jal),
            .jr             (jr),
            .shmux          (shmux),
            .mult_enable    (mult_enable),
            .sfmux_high     (sfmux_high),
            .sf2reg         (sf2reg),
            //Interrupt Handling
            .irq(irq),
            .irq_active(irq_active),
            .irq_entry(irq_entry),
            .irq_resume(irq_resume)
        );

endmodule



module mips4 (
        input  wire        clk,
        input  wire        rst,
        input  wire [4:0]  ra3,
        input  wire [31:0] instr,
        input  wire [31:0] rd_dm0,
        input  wire [31:0] rd_dm1,
        input  wire [31:0] rd_dm2,
        input  wire [31:0] rd_dm3,
        output wire        we_dm,
        output wire [31:0] pc_current,
        output wire [31:0] alu_out,
        output wire [31:0] wd_dm0,
        output wire [31:0] wd_dm1,
        output wire [31:0] wd_dm2,
        output wire [31:0] wd_dm3,
        output wire [31:0] rd3
    );

    wire       branch;
    wire       jump;
    wire       reg_dst;
    wire       we_reg;
    wire       alu_src;
    wire       dm2reg;
    wire [3:0] alu_ctrl;
    wire       jal;
    wire       jr;
    wire       shmux;
    wire       mult_enable;
    wire       sfmux_high;
    wire       sf2reg;

    datapath4 dp4 (
            .clk            (clk),
            .rst            (rst),
            .branch         (branch),
            .jump           (jump),
            .reg_dst        (reg_dst),
            .we_reg         (we_reg),
            .alu_src        (alu_src),
            .dm2reg         (dm2reg),
            .alu_ctrl       (alu_ctrl),
            .ra3            (ra3),
            .instr          (instr),
            .rd_dm0         (rd_dm0),
            .rd_dm1         (rd_dm1),
            .rd_dm2         (rd_dm2),
            .rd_dm3         (rd_dm3),
            .pc_current     (pc_current),
            .alu_out        (alu_out),
            .wd_dm0         (wd_dm0),
            .wd_dm1         (wd_dm1),
            .wd_dm2         (wd_dm2),
            .wd_dm3         (wd_dm3),
            .rd3            (rd3),
            .jal            (jal),
            .jr             (jr),
            .shmux          (shmux),
            .mult_enable    (mult_enable),
            .sfmux_high     (sfmux_high),
            .sf2reg         (sf2reg)
        );

    controlunit4 cu4 (
            .opcode         (instr[31:26]),
            .funct          (instr[5:0]),
            .branch         (branch),
            .jump           (jump),
            .reg_dst        (reg_dst),
            .we_reg         (we_reg),
            .alu_src        (alu_src),
            .we_dm0         (we_dm0),
            .we_dm1         (we_dm1),
            .we_dm2         (we_dm2),
            .we_dm3         (we_dm3),
            .dm2reg         (dm2reg),
            .alu_ctrl       (alu_ctrl),
            .jal            (jal),
            .jr             (jr),
            .shmux          (shmux),
            .mult_enable    (mult_enable),
            .sfmux_high     (sfmux_high),
            .sf2reg         (sf2reg)
        );

endmodule
