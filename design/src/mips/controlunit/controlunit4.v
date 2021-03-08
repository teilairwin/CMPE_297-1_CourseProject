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
