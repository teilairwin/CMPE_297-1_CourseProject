module intc(
            input   wire [3:0]  done,
            input   wire [31:0] input_addr,
            input   wire IACK,
            input   wire clk,
            input   wire [31:0] isr_addr0,isr_addr1,isr_addr2,isr_addr3,
            output  wire IRQ,
            output  wire [31:0] isr_addr,
            
            output  wire [31:0] read_data            
    );
    
    // internal wires
    wire    [3:0]  q_state;
    wire    [3:0]  reset;
    wire    [31:0] read_reg0,read_reg1,read_reg2,read_reg3;
    
    // wire    rst; // this goes to the addr table reg and should always be 0 unless we want to make it an input
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
    wire [1:0] read_data_select;
    
    // priority encoder - input is 4 bit interrupt status
    priority_encoder pri_enc(
        // input: interrupt status registers
        .interrupts (q_state),
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
        .reset            (reset)
    );
    
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
    intc_read_address_decoder read_data_decoder(
            .read_address (input_addr),
            .select (read_data_select)
    );
    mux4 read_data_mux(
            .sel    (read_data_select),
            .a      (read_reg0),
            .b      (read_reg1),
            .c      (read_reg2),
            .d      (read_reg3),
            .y      (read_data)
    );
        
    
    
            
endmodule
