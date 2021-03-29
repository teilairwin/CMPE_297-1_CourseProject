module isr_address_config_decoder(
        input [31:0] intc_write_address,
        // input [31:0] write_data,
        input write_enable,
        output reg [1:0] select,
        output reg error
    );
    
    initial begin
        // If no ISR addresses are written, default to zero and set error
        select = 2'b00;
        error = 1'b1;
    end
    always@(posedge write_enable)begin
        if(intc_write_address == 32'h00020000) begin
                // write to isr register 0
                select = 2'b00;
                error = 1'b0;
            end
        else if (intc_write_address == 32'h00020020) begin
            // write to isr register 1
                select = 2'b01;
                error = 1'b0;
            end
        else if (intc_write_address == 32'h00020040) begin
            // write to isr register 2
                select = 2'b10;
                error = 1'b0;
            end
        else if (intc_write_address == 32'h00020060) begin
            // write to isr register 3
                select = 2'b11;
                error = 1'b0;
            end
    end
            
endmodule
