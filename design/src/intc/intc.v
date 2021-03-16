module intc(
        input   wire interrupt_0_done,
        input   wire interrupt_1_done,
        input   wire interrupt_2_done,
        input   wire interrupt_3_done,
        input   wire IACK,
        input   wire clk,
        output  wire  IRQ,
        output  wire [31:0] ADDR
    );
    // internal wires
    wire    [31:0] addr0,addr1,addr2,addr3;    
    //reg     [3:0]  interrupt_status_register;
    wire    [1:0]  priority_select;
    wire    [3:0]  q_state;
    wire    [3:0]  q_not;
    wire    [3:0]  reset;
            
    // address vector table
    assign addr0 = 32'h0000_0000;
    assign addr1 = 32'h0000_0020;
    assign addr2 = 32'h0000_0040;
    assign addr3 = 32'h0000_0060;
    
    // dreg with reset and enable for interrupt status registers
    dreg_en #1 interrupt_0_status_register(
        .clk    (clk),
        .rst    (reset[0]),
        .en     (interrupt_0_done),
        .d      (interrupt_0_done),
        .q      (q_state[0]),
        .q_not  (q_not[0])
    );
    
    dreg_en #1 interrupt_1_status_register(
            .clk    (clk),
            .rst    (reset[1]),
            .en     (interrupt_1_done),
            .d      (interrupt_1_done),
            .q      (q_state[1]),
            .q_not  (q_not[1])
    );
        
    dreg_en #1 interrupt_2_status_register(
            .clk    (clk),
            .rst    (reset[2]),
            .en     (interrupt_2_done),
            .d      (interrupt_2_done),
            .q      (q_state[2]),
            .q_not  (q_not[2])
    );
    
    dreg_en #1 interrupt_3_status_register(
            .clk    (clk),
            .rst    (reset[3]),
            .en     (interrupt_3_done),
            .d      (interrupt_3_done),
            .q      (q_state[3]),
            .q_not  (q_not[3])
        );    
        
    // mux to select which line provides the interrupt address
    mux4 addr_mux(
        .sel   (priority_select),
        .a     (addr0),
        .b     (addr1),
        .c     (addr2),
        .d     (addr1),
        .y     (ADDR)
    );
    
    // mux to select which line gets cleared by IACK
    mux4 #(1) iack_mux(
        .sel   (priority_select),
        .a     (reset[0]),
        .b     (reset[1]),
        .c     (reset[2]),
        .d     (reset[3]),
        .y     (IACK)
    );

    // priority encoder - input is 4 bit interrupt status
    priority_encoder pri_enc(
        .interrupts (q_state),
        .y          (priority_select),
        .valid      (IRQ)
    );
            
endmodule
