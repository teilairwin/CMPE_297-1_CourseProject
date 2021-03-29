module priority_encoder(
        input  wire  [3:0] interrupts,
        output reg   [1:0] y,
        // we can move the OR gate into the priority encoder if we use a validity flag
        output wire         IRQ
    );
    reg valid;
    // integer IRQ_PULSE_WIDTH = 5;
    
    initial begin
        valid = 1'b0;
    end
    
    always @(interrupts) begin
        casex(interrupts)
            // 0 is highest priority, 3 is lowest, valid is 1 when interrupt is active
            // Priority 0
            4'bxxx1 : begin
                        y = 2'b00;
                        valid = 1;
                        #5;
                        valid = 0;
                        #5;
                      end
            // Priority 1
            4'bxx10 : begin
                        y = 2'b01;
                        valid = 1;
                        #5;
                        valid = 0;
                        #5;
                      end
            // Priority 2
            4'bx100 : begin
                        y = 2'b10;
                        valid = 1;
                        #5;
                        valid = 0;
                        #5;                      
                      end
            // Priority 3
            4'b1000 : begin
                        y = 2'b11;
                        valid = 1;
                        #5;
                        valid = 0;
                        #5;                         
                      end
            // No interrupt
            default:  begin 
                        y = 2'b00;
                        valid = 0;
                      end
        endcase
      end
    assign IRQ = valid;
endmodule
