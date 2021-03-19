module intc(
            input   wire [3:0]  done,
            input   wire [31:0] input_addr,
            input   wire [31:0] write_data,
            input   wire write_enable,
            input   wire IACK,
            input   wire clk,
            input   wire [31:0] addr0,addr1,addr2,addr3,
            output  wire IRQ,
            output  wire [31:0] isr_addr,
            output  wire [31:0] read_data,
            output wire [1:0] priority_select
            
    );
    // internal wires
    wire    [3:0]  q_state;
    wire    [3:0]  reset = 0;
    wire int0_status_enable;
    wire int1_status_enable;
    wire int2_status_enable;
    wire int3_status_enable;
    assign int0_status_enable = done[0];
    assign int1_status_enable = done[1];
    assign int2_status_enable = done[2];
    assign int3_status_enable = done[3];
    /*
    assign int0_status_enable; = reset[0];
    assign int1_status_enable = reset[1];
    assign int2_status_enable = reset[2];
    assign int3_status_enable = reset[3];   
    */ 
    //wire reset0,reset1,reset2,reset3;
    // reg     [3:0]  status_clear;
    //reg data_valid;

    // priority encoder - input is 4 bit interrupt status
    pri_encoder pri_enc(
        .interrupts (q_state),
        .y          (priority_select),
        .valid      (IRQ)
    );
    
    // mux to select which line provides the interrupt address
    mux4 addr_mux(
        .sel   (priority_select),
        .a     (addr0),
        .b     (addr1),
        .c     (addr2),
        .d     (addr3),
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
        
            
endmodule
