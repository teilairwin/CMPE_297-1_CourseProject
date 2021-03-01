module auxdec (
        input  wire [1:0] alu_op,
        input  wire [5:0] funct,
        output wire [3:0] alu_ctrl,
        output wire       jr,
        output wire       shmux,
        output wire       mult_enable,
        output wire       sfmux_high,
        output wire       sf2reg
    );

    reg [8:0] ctrl;

    assign {alu_ctrl, shmux, mult_enable, sfmux_high, sf2reg, jr} = ctrl;

    always @ (alu_op, funct) begin
        case (alu_op)
            2'b00: ctrl = 9'b0010_0_0_0_0_0;          // ADD
            2'b01: ctrl = 9'b0110_0_0_0_0_0;          // SUB
            default: case (funct)
                6'b10_0100: ctrl = 9'b0000_0_0_0_0_0; // AND
                6'b10_0101: ctrl = 9'b0001_0_0_0_0_0; // OR
                6'b10_0000: ctrl = 9'b0010_0_0_0_0_0; // ADD
                6'b10_0010: ctrl = 9'b0110_0_0_0_0_0; // SUB
                6'b10_1010: ctrl = 9'b0111_0_0_0_0_0; // SLT
                6'b00_0000: ctrl = 9'b1000_1_0_0_0_0; // SLL
                6'b00_0010: ctrl = 9'b1010_1_0_0_0_0; // SRL
                6'b01_1001: ctrl = 9'bxxxx_0_1_0_0_0; // MULTU
                6'b01_0000: ctrl = 9'bxxxx_0_0_1_1_0; // MFHI
                6'b01_0010: ctrl = 9'bxxxx_0_0_0_1_0; // MFLO
                6'b00_1000: ctrl = 9'bxxxx_0_0_0_0_1; // JR
                default:    ctrl = 9'b1xxx_x_x_x_x_x;
            endcase
        endcase
    end

endmodule
