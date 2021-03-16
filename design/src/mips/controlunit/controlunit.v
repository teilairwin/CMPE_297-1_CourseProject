module controlunit (
        input  wire [5:0]  opcode,
        input  wire [5:0]  funct,
        output wire        branch,
        output wire        jump,
        output wire        reg_dst,
        output wire        we_reg,
        output wire        alu_src,
        output wire        we_dm,
        output wire        dm2reg,
        output wire [3:0]  alu_ctrl,
        output wire        jr,
        output wire        jal,
        output wire        shmux,
        output wire        mult_enable,
        output wire        sfmux_high,
        output wire        sf2reg,
        
        //Interrupt Handling
        //--Control
        input wire irq,         //External Interrupt Signal
        input wire irq_active,  //Whether ISR is current active
        output wire irq_entry,  //Whether we need to enter ISR context
        output wire irq_resume  //Whether we need to return to program context
    );

    wire [1:0] alu_op;

    //If an IRQ ISR is not active and external IRQ is high; 
    //Then signal for IRQ entry
    assign irq_entry = irq & ~irq_active;

    //Main CU MainDecoder
    maindec md (
        .opcode         (opcode),
        .branch         (branch),
        .jump           (jump),
        .jal            (jal),
        .reg_dst        (reg_dst),
        .we_reg         (we_reg),
        .alu_src        (alu_src),
        .we_dm          (we_dm),
        .dm2reg         (dm2reg),
        .alu_op         (alu_op),
        .irq_resume     (irq_resume)
    );

    //Main CU AuxDecoder
    auxdec ad (
        .alu_op         (alu_op),
        .funct          (funct),
        .alu_ctrl       (alu_ctrl),
        .jr             (jr),
        .shmux          (shmux),
        .mult_enable    (mult_enable),
        .sfmux_high     (sfmux_high),
        .sf2reg         (sf2reg)
    );

endmodule



module controlunit4 (
        input  wire [5:0]  opcode,
        input  wire [5:0]  funct,
        output wire        branch,
        output wire        jump,
        output wire        reg_dst,
        output wire        we_reg,
        output wire        alu_src,
        output wire        we_dm0,
        output wire        we_dm1,
        output wire        we_dm2,
        output wire        we_dm3,
        output wire        dm2reg,
        output wire [3:0]  alu_ctrl,
        output wire        jr,
        output wire        jal,
        output wire        shmux,
        output wire        mult_enable,
        output wire        sfmux_high,
        output wire        sf2reg
    );

    wire [1:0] alu_op;

    maindec4 md (
        .opcode         (opcode),
        .branch         (branch),
        .jump           (jump),
        .jal            (jal),
        .reg_dst        (reg_dst),
        .we_reg         (we_reg),
        .alu_src        (alu_src),
        .we_dm0         (we_dm0),
        .we_dm1         (we_dm1),
        .we_dm2         (we_dm2),
        .we_dm3         (we_dm3),
        .dm2reg         (dm2reg),
        .alu_op         (alu_op)
    );

    auxdec ad (
        .alu_op         (alu_op),
        .funct          (funct),
        .alu_ctrl       (alu_ctrl),
        .jr             (jr),
        .shmux          (shmux),
        .mult_enable    (mult_enable),
        .sfmux_high     (sfmux_high),
        .sf2reg         (sf2reg)
    );

endmodule
