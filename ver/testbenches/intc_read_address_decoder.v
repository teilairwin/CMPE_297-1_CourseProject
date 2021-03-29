module intc_read_address_decoder(
        input [31:0] read_address,
        output reg [1:0] select
    );
    
initial begin
select = 2'b00;
            
end
always@(*) begin
    casex(read_address)
        32'h0002000x: begin
            select = 2'b00;
            end
        32'h0002002x: begin
            select = 2'b01;
            end
        32'h0002004x: begin
            select = 2'b10;
            end
        32'h0002006x: begin
            select = 2'b11;
            end
        default: begin
            select = 2'b00;
            end
        endcase
    end
endmodule
