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

module maindec4 (
        input  wire [5:0] opcode,
        output wire       branch,
        output wire       jump,
        output wire       jal,
        output wire       reg_dst,
        output wire       we_reg,
        output wire       alu_src,
        output wire       we_dm0,
        output wire       we_dm1,
        output wire       we_dm2,
        output wire       we_dm3,
        output wire       dm2reg,
        output wire [1:0] alu_op
    );

    reg [9:0] ctrl0;
    reg [9:0] ctrl1;
    reg [9:0] ctrl2;
    reg [9:0] ctrl3;

    assign {branch, jump, reg_dst, we_reg, alu_src, we_dm0, dm2reg, alu_op, jal} = ctrl0;
    assign {branch, jump, reg_dst, we_reg, alu_src, we_dm1, dm2reg, alu_op, jal} = ctrl1;
    assign {branch, jump, reg_dst, we_reg, alu_src, we_dm2, dm2reg, alu_op, jal} = ctrl2;
    assign {branch, jump, reg_dst, we_reg, alu_src, we_dm3, dm2reg, alu_op, jal} = ctrl3;

    always @ (opcode) begin
        case (opcode)
            6'b00_0000: ctrl0 = 10'b0_0_1_1_0_0_0_10_0; // R-type
            6'b00_1000: ctrl0 = 10'b0_0_0_1_1_0_0_00_0; // ADDI
            6'b00_0100: ctrl0 = 10'b1_0_0_0_0_0_0_01_0; // BEQ
            6'b00_0010: ctrl0 = 10'b0_1_0_0_0_0_0_00_0; // J
            6'b00_0011: ctrl0 = 10'b0_1_0_1_0_0_0_00_1; // JAL
            6'b10_1011: ctrl0 = 10'b0_0_0_0_1_1_0_00_0; // SW
            6'b10_0011: ctrl0 = 10'b0_0_0_1_1_0_1_00_0; // LW
            default:    ctrl0 = 10'bx_x_x_x_x_x_x_xx_x;
        endcase
    end

    always @ (opcode) begin
        case (opcode)
            6'b00_0000: ctrl1 = 10'b0_0_1_1_0_0_0_10_0; // R-type
            6'b00_1000: ctrl1 = 10'b0_0_0_1_1_0_0_00_0; // ADDI
            6'b00_0100: ctrl1 = 10'b1_0_0_0_0_0_0_01_0; // BEQ
            6'b00_0010: ctrl1 = 10'b0_1_0_0_0_0_0_00_0; // J
            6'b00_0011: ctrl1 = 10'b0_1_0_1_0_0_0_00_1; // JAL
            6'b10_1011: ctrl1 = 10'b0_0_0_0_1_1_0_00_0; // SW
            6'b10_0011: ctrl1 = 10'b0_0_0_1_1_0_1_00_0; // LW
            default:    ctrl1 = 10'bx_x_x_x_x_x_x_xx_x;
        endcase
    end

    always @ (opcode) begin
        case (opcode)
            6'b00_0000: ctrl2 = 10'b0_0_1_1_0_0_0_10_0; // R-type
            6'b00_1000: ctrl2 = 10'b0_0_0_1_1_0_0_00_0; // ADDI
            6'b00_0100: ctrl2 = 10'b1_0_0_0_0_0_0_01_0; // BEQ
            6'b00_0010: ctrl2 = 10'b0_1_0_0_0_0_0_00_0; // J
            6'b00_0011: ctrl2 = 10'b0_1_0_1_0_0_0_00_1; // JAL
            6'b10_1011: ctrl2 = 10'b0_0_0_0_1_1_0_00_0; // SW
            6'b10_0011: ctrl2 = 10'b0_0_0_1_1_0_1_00_0; // LW
            default:    ctrl2 = 10'bx_x_x_x_x_x_x_xx_x;
        endcase
    end

    always @ (opcode) begin
        case (opcode)
            6'b00_0000: ctrl3 = 10'b0_0_1_1_0_0_0_10_0; // R-type
            6'b00_1000: ctrl3 = 10'b0_0_0_1_1_0_0_00_0; // ADDI
            6'b00_0100: ctrl3 = 10'b1_0_0_0_0_0_0_01_0; // BEQ
            6'b00_0010: ctrl3 = 10'b0_1_0_0_0_0_0_00_0; // J
            6'b00_0011: ctrl3 = 10'b0_1_0_1_0_0_0_00_1; // JAL
            6'b10_1011: ctrl3 = 10'b0_0_0_0_1_1_0_00_0; // SW
            6'b10_0011: ctrl3 = 10'b0_0_0_1_1_0_1_00_0; // LW
            default:    ctrl3 = 10'bx_x_x_x_x_x_x_xx_x;
        endcase
    end

endmodule