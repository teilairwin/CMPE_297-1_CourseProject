`timescale 1ns / 1ps

module tb_intc();
    reg [3:0] done;
    reg IACK;
    reg clk;
    reg [31:0] input_addr;
    reg write_enable;
    reg [31:0] write_data;
    wire [31:0] read_data;
    wire IRQ;
    wire [31:0] isr_addr;
    wire [31:0] addr0,addr1,addr2,addr3;

    /*assign gpI1 = {27'b0, Sel, n[3:0]};
    assign dispSe = gpO1[1];
    assign factErr = gpO1[0];*/
    assign addr0 = 32'h00030000;
    assign addr1 = 32'h00040000;
    assign addr2 = 32'h00050000;
    assign addr3 = 32'h00060000;

    intc DUT (
        .interrupt_0_done   (done[0]),
        .interrupt_1_done   (done[1]),
        .interrupt_2_done   (done[2]),
        .interrupt_3_done   (done[3]),
        .IACK               (IACK),
        .clk                (clk),
        .IRQ                (IRQ),
        .ADDR               (ADDR)
    );

    integer DONE_PULSE_WIDTH = 10; 
    integer IACK_PULSE_WIDTH = 10;
    integer TIME_IN_BETWEEN_INTERRUPTS = 15;
    always begin
        #5 clk = ~clk;
    end
    initial begin
        clk             = 0;
        // reset everything - consider adding this as a functionality
        done            <= 4'b0;
        //input_addr      <= 0;
        write_enable    <= 0;
        write_data      <= 0;
        done            <= 0;

        // send interrupt 3 done to interrupt controller
        input_addr      <= addr3;
        write_enable    <= 1;
        done            <= 4'b1000;
        #DONE_PULSE_WIDTH;
        done            <= 4'b0000;
        #DONE_PULSE_WIDTH;
        write_enable    <= 0;
        #TIME_IN_BETWEEN_INTERRUPTS;

        IACK            <= 1;
        #IACK_PULSE_WIDTH;
        IACK            <= 0;
        #IACK_PULSE_WIDTH;
        #TIME_IN_BETWEEN_INTERRUPTS;

        // send interrupt 2 done to interrupt controller
        input_addr      <= addr2;
        write_enable    <= 1;
        done            <= 4'b0100;
        #DONE_PULSE_WIDTH;
        done            <= 4'b0000;
        #DONE_PULSE_WIDTH;
        write_enable    <= 0;
        #TIME_IN_BETWEEN_INTERRUPTS;

        IACK            <= 1;
        #IACK_PULSE_WIDTH;
        IACK            <= 0;
        #IACK_PULSE_WIDTH;
        #TIME_IN_BETWEEN_INTERRUPTS;

        // send interrupt 0 done to interrupt controller
        input_addr      <= addr0;
        write_enable    <= 1;
        done            <= 4'b0001;
        #DONE_PULSE_WIDTH;
        done            <= 4'b0000;
        #DONE_PULSE_WIDTH;
        write_enable    <= 0;
        #TIME_IN_BETWEEN_INTERRUPTS;

        IACK            <= 1;
        #IACK_PULSE_WIDTH;
        IACK            <= 0;
        #IACK_PULSE_WIDTH;
        #TIME_IN_BETWEEN_INTERRUPTS;

        // send interrupt 1 done to interrupt controller
        input_addr      <= addr1;
        write_enable    <= 1;
        done            <= 4'b0010;
        #DONE_PULSE_WIDTH;
        done            <= 4'b0000;
        #DONE_PULSE_WIDTH;
        write_enable    <= 0;
        #TIME_IN_BETWEEN_INTERRUPTS;

        IACK            <= 1;
        #IACK_PULSE_WIDTH;
        IACK            <= 0;
        #IACK_PULSE_WIDTH;
        #TIME_IN_BETWEEN_INTERRUPTS;




        $finish;
      end
endmodule