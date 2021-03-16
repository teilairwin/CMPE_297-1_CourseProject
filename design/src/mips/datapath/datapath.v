module datapath (
        input  wire        clk,
        input  wire        rst,
        input  wire        branch,
        input  wire        jump,
        input  wire        jal,
        input  wire        jr,
        input  wire        shmux,
        input  wire        reg_dst,
        input  wire        we_reg,
        input  wire        alu_src,
        input  wire        dm2reg,
        input  wire        mult_enable,
        input  wire        sfmux_high,
        input  wire        sf2reg,
        input  wire [3:0]  alu_ctrl,
        input  wire [4:0]  ra3,
        input  wire [31:0] instr,
        input  wire [31:0] rd_dm,
        output wire [31:0] pc_current,
        output wire [31:0] alu_out,
        output wire [31:0] wd_dm,
        output wire [31:0] rd3,
        
        //Interrupt Handling
        //--Control
        input wire irq_entry,       //Whether we need to switch PC context to Exception
        input wire irq_resume,      //Whether we need to switch PC context to Program
        //--Data
        input wire [31:0] irq_addr, //ISR Address for the external interrupt 
        output wire irq_active      //Whether PC context is currently Exception
    );

    wire [31:0] shamt_in;
    wire [4:0]  rf_wa;
    wire [4:0]  rf_wa_rdt;
    wire [4:0]  rf_wa_ra;
    wire        pc_src;
    wire [31:0] pc_plus4;
    wire [31:0] pc_pre;
    wire [31:0] pc_next;
    wire [31:0] pc_next_irq;
    wire [31:0] pc_next_mips;
    wire [31:0] pc_next_pre;
    wire [31:0] pc_resume;
    wire [31:0] sext_imm;
    wire [31:0] ba;
    wire [31:0] bta;
    wire [31:0] jta;
    wire [31:0] alu_pa;
    wire [31:0] alu_pb;
    wire [31:0] wd_rf;
    wire [31:0] high_in;
    wire [31:0] low_in;
    wire [31:0] sfmux_in0;
    wire [31:0] sfmux_in1;
    wire [31:0] sfmux_out;
    wire [31:0] wd_aludm;
    wire [31:0] wd_sfhl;
    wire [31:0] rs;

    wire        zero;

    assign pc_src = branch & zero;
    assign ba = {sext_imm[29:0], 2'b00};
    assign jta = {pc_plus4[31:28], instr[25:0], 2'b00};
    assign shamt_in = {27'd0, instr[10:6]};

    //////////////////////////////////////////////////////////////////////////
    //
    // --- PC Logic --- //
    //
    //////////////////////////////////////////////////////////////////////////

    //////////////////////////////////////////////////////////////////////////
    //PC REGISTERS
    //@details Final PC Register
    dreg pc_reg (
            .clk            (clk),
            .rst            (rst),
            .d              (pc_next),
            .q              (pc_current)
        );
    //@details Saved Program PC Register
    dreg_we pc_saved(
        .clk(clk),
        .rst(rst),
        .we(irq_entry),
        .d(pc_next_mips),
        .q(pc_resume)
    ); 
    //@details State of whether IRQ is active
    dreg_we #(1) irq_state(
        .clk(clk),
        .rst(rst),
        .we(irq_entry),
        .d(irq_entry),
        .q(irq_active)
    );    

    //////////////////////////////////////////////////////////////////////////
    //Next PC Computation
    //@details NPC = PC +4
    adder pc_plus_4 (
            .a              (pc_current),
            .b              (32'd4),
            .y              (pc_plus4)
        );
    //@details NPC = BTA = BA + PC+4
    adder pc_plus_br (
            .a              (pc_plus4),
            .b              (ba),
            .y              (bta)
        );

    //////////////////////////////////////////////////////////////////////////
    //PC Selection
    //@details 1 - Optional Select [BranchToAddr]
    mux2 #(32) pc_src_mux (
            .sel            (pc_src),
            .a              (pc_plus4),
            .b              (bta),
            .y              (pc_pre)
        );
    //@details 2 - Optional Select [JumpToAddr]
    mux2 #(32) pc_jmp_mux (
            .sel            (jump),
            .a              (pc_pre),
            .b              (jta),
            .y              (pc_next_pre)
        );
    //@details 3 - Optional Select [RetrunAddr]
    mux2 #(32)  pcjr_mux (
            .sel            (jr),
            .a              (pc_next_pre),
            .b              (rs),
            .y              (pc_next_mips)
    );
    //@details 4 - Optional Select [IRQ_ADDRESS]
    mux2 #(32) pc_switch2irq_mux (
            .sel(irq_entry),
            .a(pc_next_mips),
            .b(irq_addr),
            .y(pc_next_irq)
    );
    //@details 5 - Optional Select [IRQ_RESUME]
    mux2 #(32) pc_resume_progam_mux (
            .sel(irq_resume),
            .a(pc_next_irq),
            .b(pc_resume),
            .y(pc_next) 
    );




    ///////////////////////////////////////////////////////////////////////////
    // MISC

    // --- jal & jr Support --- //
    mux2 #(32) rfwd_jal_mux (
            .sel            (jal),
            .a              (wd_sfhl),
            .b              (pc_plus4),
            .y              (wd_rf)
    );

    mux2 #(32)  rfwa_jal_mux (
            .sel            (jal),
            .a              (rf_wa_rdt),
            .b              (5'd31),
            .y              (rf_wa_ra)
    );



    mux2 #(5)   rfjr_mux (
            .sel            (jr),
            .a              (rf_wa_ra),
            .b              (5'd0),
            .y              (rf_wa)
    );

    // --- sll, srl Support --- //
    mux2 #(32) shift_mux (
            .sel            (shmux),
            .a              (rs),
            .b              (shamt_in),
            .y              (alu_pa)
    );

    // --- RF Logic --- //
    mux2 #(5) rf_wa_mux (
            .sel            (reg_dst),
            .a              (instr[20:16]),
            .b              (instr[15:11]),
            .y              (rf_wa_rdt)
        );

    regfile rf (
            .clk            (clk),
            .we             (we_reg),
            .ra1            (instr[25:21]),
            .ra2            (instr[20:16]),
            .ra3            (ra3),
            .wa             (rf_wa),
            .wd             (wd_rf),
            .rd1            (rs),
            .rd2            (wd_dm),
            .rd3            (rd3)
        );

    signext se (
            .a              (instr[15:0]),
            .y              (sext_imm)
        );

    // --- ALU Logic --- //
    mux2 #(32) alu_pb_mux (
            .sel            (alu_src),
            .a              (wd_dm),
            .b              (sext_imm),
            .y              (alu_pb)
        );

    alu alu (
            .op             (alu_ctrl),
            .a              (alu_pa),
            .b              (alu_pb),
            .zero           (zero),
            .y              (alu_out)
        );

    // --- MULTIPLIER --- //
    multiplier mult(
            .A            (rs),
            .B            (wd_dm),
            .en           (mult_enable),
            .Y            ({high_in, low_in})
    );

    dreg low_reg(
            .clk          (clk),
            .rst          (rst),
            .d            (low_in),
            .q            (sfmux_in0)
    );

    dreg high_reg(
            .clk          (clk),
            .rst          (rst),
            .d            (high_in),
            .q            (sfmux_in1)
    );

    mux2 #(32) sfmux (
            .sel          (sfmux_high),
            .a            (sfmux_in0),
            .b            (sfmux_in1),
            .y            (sfmux_out)
    );

    mux2 #(32) rf_sfhl_mux (
            .sel          (sf2reg),
            .a            (wd_aludm),
            .b            (sfmux_out),
            .y            (wd_sfhl)
    );

    // --- MEM Logic --- //
    mux2 #(32) rf_wd_mux (
            .sel            (dm2reg),
            .a              (alu_out),
            .b              (rd_dm),
            .y              (wd_aludm)
        );

endmodule



module datapath4 (
        input  wire        clk,
        input  wire        rst,
        input  wire        branch,
        input  wire        jump,
        input  wire        jal,
        input  wire        jr,
        input  wire        shmux,
        input  wire        reg_dst,
        input  wire        we_reg,
        input  wire        alu_src,
        input  wire        dm2reg,
        input  wire        mult_enable,
        input  wire        sfmux_high,
        input  wire        sf2reg,
        input  wire [3:0]  alu_ctrl,
        input  wire [4:0]  ra3,
        input  wire [31:0] instr,
        input  wire [31:0] rd_dm0,
        input  wire [31:0] rd_dm1,
        input  wire [31:0] rd_dm2,
        input  wire [31:0] rd_dm3,
        output wire [31:0] pc_current,
        output wire [31:0] alu_out,
        output wire [31:0] wd_dm0,
        output wire [31:0] wd_dm1,
        output wire [31:0] wd_dm2,
        output wire [31:0] wd_dm3,
        output wire [31:0] rd3
    );

    wire [31:0] shamt_in;
    wire [4:0]  rf_wa;
    wire [4:0]  rf_wa_rdt;
    wire [4:0]  rf_wa_ra;
    wire        pc_src;
    wire [31:0] pc_plus4;
    wire [31:0] pc_pre;
    wire [31:0] pc_next;
    wire [31:0] pc_next_pre;
    wire [31:0] sext_imm;
    wire [31:0] ba;
    wire [31:0] bta;
    wire [31:0] jta;
    wire [31:0] alu_pa;
    wire [31:0] alu_pb;
    wire [31:0] wd_rf;
    wire [31:0] high_in;
    wire [31:0] low_in;
    wire [31:0] sfmux_in0;
    wire [31:0] sfmux_in1;
    wire [31:0] sfmux_out;
    wire [31:0] wd_aludm;
    wire [31:0] wd_sfhl;
    wire [31:0] rs;

    wire        zero;

    assign pc_src = branch & zero;
    assign ba = {sext_imm[29:0], 2'b00};
    assign jta = {pc_plus4[31:28], instr[25:0], 2'b00};
    assign shamt_in = {27'd0, instr[10:6]};

    // --- PC Logic --- //
    dreg pc_reg (
            .clk            (clk),
            .rst            (rst),
            .d              (pc_next),
            .q              (pc_current)
        );

    adder pc_plus_4 (
            .a              (pc_current),
            .b              (32'd4),
            .y              (pc_plus4)
        );

    adder pc_plus_br (
            .a              (pc_plus4),
            .b              (ba),
            .y              (bta)
        );

    mux2 #(32) pc_src_mux (
            .sel            (pc_src),
            .a              (pc_plus4),
            .b              (bta),
            .y              (pc_pre)
        );

    mux2 #(32) pc_jmp_mux (
            .sel            (jump),
            .a              (pc_pre),
            .b              (jta),
            .y              (pc_next_pre)
        );

    // --- jal & jr Support --- //
    mux2 #(32) rfwd_jal_mux (
            .sel            (jal),
            .a              (wd_sfhl),
            .b              (pc_plus4),
            .y              (wd_rf)
    );

    mux2 #(32)  rfwa_jal_mux (
            .sel            (jal),
            .a              (rf_wa_rdt),
            .b              (5'd31),
            .y              (rf_wa_ra)
    );

    mux2 #(32)  pcjr_mux (
            .sel            (jr),
            .a              (pc_next_pre),
            .b              (rs),
            .y              (pc_next)
    );

    mux2 #(5)   rfjr_mux (
            .sel            (jr),
            .a              (rf_wa_ra),
            .b              (5'd0),
            .y              (rf_wa)
    );

    // --- sll, srl Support --- //
    mux2 #(32) shift_mux (
            .sel            (shmux),
            .a              (rs),
            .b              (shamt_in),
            .y              (alu_pa)
    );

    // --- RF Logic --- //
    mux2 #(5) rf_wa_mux (
            .sel            (reg_dst),
            .a              (instr[20:16]),
            .b              (instr[15:11]),
            .y              (rf_wa_rdt)
        );

    regfile rf0 (
            .clk            (clk),
            .we             (we_reg),
            .ra1            (instr[25:21]),
            .ra2            (instr[20:16]),
            .ra3            (ra3),
            .wa             (rf_wa),
            .wd             (wd_rf),
            .rd1            (rs),
            .rd2            (wd_dm0),
            .rd3            (rd3)
        );

    regfile rf1 (
            .clk            (clk),
            .we             (we_reg),
            .ra1            (instr[25:21]),
            .ra2            (instr[20:16]),
            .ra3            (ra3),
            .wa             (rf_wa),
            .wd             (wd_rf),
            .rd1            (rs),
            .rd2            (wd_dm1),
            .rd3            (rd3)
        );

    regfile rf2 (
            .clk            (clk),
            .we             (we_reg),
            .ra1            (instr[25:21]),
            .ra2            (instr[20:16]),
            .ra3            (ra3),
            .wa             (rf_wa),
            .wd             (wd_rf),
            .rd1            (rs),
            .rd2            (wd_dm2),
            .rd3            (rd3)
        );

    regfile rf3 (
            .clk            (clk),
            .we             (we_reg),
            .ra1            (instr[25:21]),
            .ra2            (instr[20:16]),
            .ra3            (ra3),
            .wa             (rf_wa),
            .wd             (wd_rf),
            .rd1            (rs),
            .rd2            (wd_dm3),
            .rd3            (rd3)
        );

    signext se (
            .a              (instr[15:0]),
            .y              (sext_imm)
        );

    // --- ALU Logic --- //
    mux2 #(32) alu_pb_mux0 (
            .sel            (alu_src),
            .a              (wd_dm0),
            .b              (sext_imm),
            .y              (alu_pb)
        );
    
    mux2 #(32) alu_pb_mux1 (
            .sel            (alu_src),
            .a              (wd_dm1),
            .b              (sext_imm),
            .y              (alu_pb)
        );
    
    mux2 #(32) alu_pb_mux2 (
            .sel            (alu_src),
            .a              (wd_dm2),
            .b              (sext_imm),
            .y              (alu_pb)
        );
    
    mux2 #(32) alu_pb_mux3 (
            .sel            (alu_src),
            .a              (wd_dm3),
            .b              (sext_imm),
            .y              (alu_pb)
        );

    alu alu (
            .op             (alu_ctrl),
            .a              (alu_pa),
            .b              (alu_pb),
            .zero           (zero),
            .y              (alu_out)
        );

    // --- MULTIPLIER --- //
    multiplier mult0(
            .A            (rs),
            .B            (wd_dm0),
            .en           (mult_enable),
            .Y            ({high_in, low_in})
    );
    multiplier mult1(
            .A            (rs),
            .B            (wd_dm1),
            .en           (mult_enable),
            .Y            ({high_in, low_in})
    );
    multiplier mult2(
            .A            (rs),
            .B            (wd_dm2),
            .en           (mult_enable),
            .Y            ({high_in, low_in})
    );
    multiplier mult3(
            .A            (rs),
            .B            (wd_dm3),
            .en           (mult_enable),
            .Y            ({high_in, low_in})
    );

    dreg low_reg(
            .clk          (clk),
            .rst          (rst),
            .d            (low_in),
            .q            (sfmux_in0)
    );

    dreg high_reg(
            .clk          (clk),
            .rst          (rst),
            .d            (high_in),
            .q            (sfmux_in1)
    );

    mux2 #(32) sfmux (
            .sel          (sfmux_high),
            .a            (sfmux_in0),
            .b            (sfmux_in1),
            .y            (sfmux_out)
    );

    mux2 #(32) rf_sfhl_mux (
            .sel          (sf2reg),
            .a            (wd_aludm),
            .b            (sfmux_out),
            .y            (wd_sfhl)
    );

    // --- MEM Logic --- //
    mux2 #(32) rf_wd_mux0 (
            .sel            (dm2reg),
            .a              (alu_out),
            .b              (rd_dm0),
            .y              (wd_aludm)
        );

    mux2 #(32) rf_wd_mux1 (
            .sel            (dm2reg),
            .a              (alu_out),
            .b              (rd_dm1),
            .y              (wd_aludm)
        );

    mux2 #(32) rf_wd_mux2 (
            .sel            (dm2reg),
            .a              (alu_out),
            .b              (rd_dm2),
            .y              (wd_aludm)
        );

    mux2 #(32) rf_wd_mux3 (
            .sel            (dm2reg),
            .a              (alu_out),
            .b              (rd_dm3),
            .y              (wd_aludm)
        );

endmodule
