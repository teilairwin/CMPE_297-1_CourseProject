module maindec (
        input  wire [5:0] opcode,
        output wire       branch,
        output wire       jump,
        output wire       jal,
        output wire       reg_dst,
        output wire       we_reg,
        output wire       alu_src,
        output wire       we_dm,
        output wire       dm2reg,
        output wire [1:0] alu_op,
        output wire       irq_resume
    );

    reg [10:0] ctrl;

    assign {irq_resume, branch, jump, reg_dst, we_reg, alu_src, we_dm, dm2reg, alu_op, jal} = ctrl;

    always @ (opcode) begin
        case (opcode)
            6'b00_0000: ctrl = 11'b0_0_0_1_1_0_0_0_10_0; // R-type
            6'b00_1000: ctrl = 11'b0_0_0_0_1_1_0_0_00_0; // ADDI
            6'b00_0100: ctrl = 11'b0_1_0_0_0_0_0_0_01_0; // BEQ
            6'b00_0010: ctrl = 11'b0_0_1_0_0_0_0_0_00_0; // J
            6'b00_0011: ctrl = 11'b0_0_1_0_1_0_0_0_00_1; // JAL
            6'b10_1011: ctrl = 11'b0_0_0_0_0_1_1_0_00_0; // SW
            6'b10_0011: ctrl = 11'b0_0_0_0_1_1_0_1_00_0; // LW
            6'b11_1111: ctrl = 11'b1_0_0_0_0_0_0_0_00_0; // RES
            default:    ctrl = 10'bx_x_x_x_x_x_x_xx_x;
        endcase
    end

endmodule
