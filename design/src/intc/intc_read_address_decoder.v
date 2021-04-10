module intc_read_address_decoder(
        input [31:0] read_address,
        output wire [1:0] select
    );
    
    assign select = read_address[3:2];

endmodule
