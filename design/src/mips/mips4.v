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
