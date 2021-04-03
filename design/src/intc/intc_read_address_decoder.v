module intc_read_address_decoder(
        input [31:0] read_address,
        output wire [1:0] select
    );
    
    assign select = read_address[3:2];
/*initial begin
        select = 2'b00;
        //error = 1'b1;
    end
    
    always@(read_address, select)begin
        if(read_address >= 32'h00020000 && read_address < 32'h0020020) begin
                // write to isr register 0
                select = 2'b00;
                //error = 1'b0;
            end
        else if (read_address >= 32'h00020020 && read_address < 32'h0020040) begin
            // write to isr register 1
                select = 2'b01;
                //error = 1'b0;
            end
        else if (read_address >= 32'h00020040 && read_address < 32'h0020060) begin
            // write to isr register 2
                select = 2'b10;
                //error = 1'b0;
            end
        else if (read_address >= 32'h00020060 && read_address < 32'h0020080) begin
            // write to isr register 3
                select = 2'b11;
                //error = 1'b0;
            end
    end*/
endmodule
