`timescale 1ns / 1ps

module tb_priority_encoder();
    reg         clk;
    reg   [3:0] interrupts_in;
    wire  [1:0] y_out;
    reg   [1:0] y_expected;
    wire        valid_out;
    reg         valid_expected;
    reg         testPass;

    priority_encoder priority_encoder(
      .interrupts (interrupts_in),
      .y          (y_out),
      .valid      (valid_out)
    );

    always begin
        #5 clk = ~clk;
    end

    initial begin
      clk         = 0;
      testPass    = 1;

      // No Interrupt
      interrupts_in  = 4'b0000;
      y_expected     = 2'b00;
      valid_expected = 0;
      #10 if ((y_out != y_expected) || (valid_out != valid_expected)) begin
        testPass = 0;
      end

      // Priority 0
      #20 interrupts_in = 4'b0001;
      y_expected     = 2'b00;
      valid_expected = 1;
      #10 if ((y_out != y_expected) || (valid_out != valid_expected)) begin
        testPass = 0;
      end

      // Priority 1
      #20 interrupts_in = 4'b0010;
      y_expected     = 2'b01;
      valid_expected = 1;
      #10 if ((y_out != y_expected) || (valid_out != valid_expected)) begin
        testPass = 0;
      end

      // Priority 0
      #20 interrupts_in = 4'b0011;
      y_expected     = 2'b00;
      valid_expected = 1;
      #10 if ((y_out != y_expected) || (valid_out != valid_expected)) begin
        testPass = 0;
      end

      // Priority 2
      #20 interrupts_in = 4'b0100;
      y_expected     = 2'b10;
      valid_expected = 1;
      #10 if ((y_out != y_expected) || (valid_out != valid_expected)) begin
        testPass = 0;
      end

      // Priority 0
      #20 interrupts_in = 4'b0101;
      y_expected     = 2'b00;
      valid_expected = 1;
      #10 if ((y_out != y_expected) || (valid_out != valid_expected)) begin
        testPass = 0;
      end

      // Priority 1
      #20 interrupts_in = 4'b0110;
      y_expected     = 2'b01;
      valid_expected = 1;
      #10 if ((y_out != y_expected) || (valid_out != valid_expected)) begin
        testPass = 0;
      end

      // Priority 0
      #20 interrupts_in = 4'b0111;
      y_expected     = 2'b00;
      valid_expected = 1;
      #10 if ((y_out != y_expected) || (valid_out != valid_expected)) begin
        testPass = 0;
      end

      // Priority 3
      #20 interrupts_in = 4'b1000;
      y_expected     = 2'b11;
      valid_expected = 1;
      #10 if ((y_out != y_expected) || (valid_out != valid_expected)) begin
        testPass = 0;
      end

      // Priority 0
      #20 interrupts_in = 4'b1001;
      y_expected     = 2'b00;
      valid_expected = 1;
      #10 if ((y_out != y_expected) || (valid_out != valid_expected)) begin
        testPass = 0;
      end

      // Priority 1
      #20 interrupts_in = 4'b1010;
      y_expected     = 2'b01;
      valid_expected = 1;
      #10 if ((y_out != y_expected) || (valid_out != valid_expected)) begin
        testPass = 0;
      end

      // Priority 0
      #20 interrupts_in = 4'b1011;
      y_expected     = 2'b00;
      valid_expected = 1;
      #10 if ((y_out != y_expected) || (valid_out != valid_expected)) begin
        testPass = 0;
      end

      // Priority 2
      #20 interrupts_in = 4'b1100;
      y_expected     = 2'b10;
      valid_expected = 1;
      #10 if ((y_out != y_expected) || (valid_out != valid_expected)) begin
        testPass = 0;
      end

      // Priority 0
      #20 interrupts_in = 4'b1101;
      y_expected     = 2'b00;
      valid_expected = 1;
      #10 if ((y_out != y_expected) || (valid_out != valid_expected)) begin
        testPass = 0;
      end

      // Priority 1
      #20 interrupts_in = 4'b1110;
      y_expected     = 2'b00;
      valid_expected = 1;
      #10 if ((y_out != y_expected) || (valid_out != valid_expected)) begin
        testPass = 0;
      end

      // Priority 0
      #20 interrupts_in = 4'b1111;
      y_expected     = 2'b00;
      valid_expected = 1;
      #10 if ((y_out != y_expected) || (valid_out != valid_expected)) begin
        testPass = 0;
      end


      #300 $finish;
    end

endmodule
