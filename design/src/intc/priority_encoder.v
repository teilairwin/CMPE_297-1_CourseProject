module priority_encoder(
        input  wire  [3:0] interrupts,
        input  wire  clk,
        output reg   [1:0] y,
        // we can move the OR gate into the priority encoder if we use a validity flag
        output wire         IRQ
    );
    reg valid;
    
    initial begin
        valid = 1'b0;
    end
    
    always @(interrupts) begin
        casex(interrupts)
            // 0 is highest priority, 3 is lowest, valid is 1 when interrupt is active
            // Priority 0
            4'bxxx1 : begin
                        y = 2'b00;
                      end
            // Priority 1
            4'bxx10 : begin
                        y = 2'b01;
                      end
            // Priority 2
            4'bx100 : begin
                        y = 2'b10;                    
                      end
            // Priority 3
            4'b1000 : begin
                        y = 2'b11;                       
                      end
            // No interrupt
            default:  begin 
                        y = 2'b00;
                      end
        endcase
      end
    //assign IRQ = valid;
    assign IRQ = interrupts[0] | interrupts[1] | interrupts[2] | interrupts[3];
endmodule
