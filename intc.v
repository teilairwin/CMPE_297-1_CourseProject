module intc(
            input   wire [3:0]  done,
            input   wire [31:0] input_addr,
            input   wire [31:0] write_data,
            input   wire write_enable,
            input   wire IACK,
            input   wire clk,
            output  wire IRQ,
            output  wire [31:0] isr_addr,
            output  wire read_data
    );
    // internal wires
    wire    [31:0] addr0,addr1,addr2,addr3;    
    wire    [1:0]  priority_select;
    wire    [3:0]  q_state;
    wire    [3:0]  q_not;
    wire    [3:0]  reset;
            
    // address vector table - temporary  until memory map is defined
    assign addr0 = 32'h0000_0000;
    assign addr1 = 32'h0000_0020;
    assign addr2 = 32'h0000_0040;
    assign addr3 = 32'h0000_0060;
    
    // dreg with reset and enable for interrupt status registers
    dreg_en #4 interrupt_0_status_register(
        .clk    (clk),
        .rst    (reset),
        .en     (done),
        .d      (done),
        .q      (q_state),
        .q_not  (q_not)
    );
    /*
    dreg_en #1 interrupt_1_status_register(
            .clk    (clk),
            .rst    (reset[1]),
            .en     (done[1]),
            .d      (done[1]),
            .q      (q_state[1]),
            .q_not  (q_not[1])
    );
        
    dreg_en #1 interrupt_2_status_register(
            .clk    (clk),
            .rst    (reset[2]),
            .en     (done[2]),
            .d      (done[2]),
            .q      (q_state[2]),
            .q_not  (q_not[2])
    );
    
    dreg_en #1 interrupt_3_status_register(
            .clk    (clk),
            .rst    (reset[3]),
            .en     (done[3]),
            .d      (done[3]),
            .q      (q_state[3]),
            .q_not  (q_not[3])
        );  */  
        
    // mux to select which line provides the interrupt address
    mux4 addr_mux(
        .sel   (priority_select),
        .a     (addr0),
        .b     (addr1),
        .c     (addr2),
        .d     (addr3),
        .y     (isr_addr)
    );
    
    // mux to select which line gets cleared by IACK
    mux4 #(4) iack_mux(
        .sel   (priority_select),
        .a     (reset),
        .y     (IACK)
    );

    // priority encoder - input is 4 bit interrupt status
    priority_encoder pri_enc(
        .interrupts (q_state),
        .y          (priority_select),
        .valid      (IRQ)
    );
            
endmodule
