module intc(
            input   wire [3:0]  done,
            input   wire IACK,
            input   wire clk,
            input   wire rst_ext,   //External Reset
            input   wire [31:0] isr_addr0,isr_addr1,isr_addr2,isr_addr3,
            output  wire IRQ,
            output  wire [31:0] isr_addr
    );
    
    // internal wires
    wire    [3:0]  q_state;
    wire    [3:0]  reset_state;
    wire    [3:0]  reset;
    
    assign reset[0] = reset_state[0] | rst_ext;
    assign reset[1] = reset_state[1] | rst_ext;
    assign reset[2] = reset_state[2] | rst_ext;
    assign reset[3] = reset_state[3] | rst_ext;
    
    
    wire int0_status_enable;
    wire int1_status_enable;
    wire int2_status_enable;
    wire int3_status_enable;
    
    // connect the status reg enables to the done inputs
    assign int0_status_enable = done[0];
    assign int1_status_enable = done[1];
    assign int2_status_enable = done[2];
    assign int3_status_enable = done[3];
    wire [1:0] priority_select;
        
    // priority encoder - input is 4 bit interrupt status
    priority_encoder pri_enc(
        // input: interrupt status registers
        .interrupts (q_state),
        .clk(clk),
        // outputs
        .y          (priority_select),
        .IRQ      (IRQ)
    );
    
    // mux to select which line provides the interrupt address
    mux4 addr_mux(
        .sel   (priority_select),
        .a     (isr_addr0),
        .b     (isr_addr1),
        .c     (isr_addr2),
        .d     (isr_addr3),
        .y     (isr_addr)
    );
    
    // decoder to select which line gets cleared by IACK
    iack_decoder iack_decoder(
        .priority_select  (priority_select),
        .IACK             (IACK),
        .reset            (reset_state)
    );
    
    ///////////////////////////////////////////////////////////////////////////
    // dreg with reset and enable for interrupt status registers
    dreg_en #1 interrupt_0_status_register(
        .clk    (clk),
        .rst    (reset[0]),
        .en     (int0_status_enable),
        .d      (done[0]),
        .q      (q_state[0])
    );
    
    dreg_en #1 interrupt_1_status_register(
            .clk    (clk),
            .rst    (reset[1]),
            .en     (int1_status_enable),
            .d      (done[1]),
            .q      (q_state[1])
    );
        
    dreg_en #1 interrupt_2_status_register(
            .clk    (clk),
            .rst    (reset[2]),
            .en     (int2_status_enable),
            .d      (done[2]),
            .q      (q_state[2])
    );
    
    dreg_en #1 interrupt_3_status_register(
            .clk    (clk),
            .rst    (reset[3]),
            .en     (int3_status_enable),
            .d      (done[3]),
            .q      (q_state[3])
        );  
endmodule
