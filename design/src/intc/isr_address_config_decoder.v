module isr_address_config_decoder(
        input [31:0] intc_write_address,
        // input [31:0] write_data,
        input write_enable,
        output wire [1:0] select
        //output reg error
    );
    
    assign select = intc_write_address[3:2];

            
endmodule
