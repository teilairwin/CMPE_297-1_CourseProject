module tb_intc_top();
    reg clk;
    reg [3:0] done;
    reg IACK;
    reg [31:0] input_addr;
    reg write_enable;
    reg [31:0] write_data;
    wire [31:0] read_data;
    wire IRQ;
    wire [31:0] isr_addr;
    wire error;
    
    // Device under test instantiation
    intc_top DUT (
    .done       (done),
    .IACK       (IACK),
    .clk        (clk),
    .input_addr (input_addr),
    .write_enable (write_enable),
    .write_data(write_data),
    .read_data(read_data), 
    .IRQ        (IRQ),
    .isr_addr   (isr_addr),
    .error      (error)
    );
    
    // Test data
    wire [31:0] intc_reg0_addr,intc_reg1_addr,intc_reg2_addr,intc_reg3_addr;
    wire [31:0] isr0_addr_to_write,isr1_addr_to_write,isr2_addr_to_write,isr3_addr_to_write;
    reg  [31:0] isr_addr_temp = 0;
    wire [31:0] input_addr_test_interrupt0,input_addr_test_interrupt1,input_addr_test_interrupt2,input_addr_test_interrupt3;
    reg irq_temp = 0;

    // Test values
    // Addresses of the isr address registers
    assign intc_reg0_addr = 32'h00020000;
    assign intc_reg1_addr = 32'h00020004;
    assign intc_reg2_addr = 32'h00020008;
    assign intc_reg3_addr = 32'h0002000C;
    
    // Test values for isr addresses to write
    assign isr0_addr_to_write = 32'h0000000A;
    assign isr1_addr_to_write = 32'h0000000B;
    assign isr2_addr_to_write = 32'h0000000C;
    assign isr3_addr_to_write = 32'h0000000D;
    
    // Test input address values for simulating interrupts
    assign input_addr_test_interrupt0 = 32'h0003AAAA;
    assign input_addr_test_interrupt1 = 32'h0004BBBB;
    assign input_addr_test_interrupt2 = 32'h0005CCCC;
    assign input_addr_test_interrupt3 = 32'h0006DDDD;
    
    // Constant values for the address boundaries of the factorial units
    reg [31:0] fact0_address_boundary = 32'h00030000;
    reg [31:0] fact1_address_boundary = 32'h00040000;
    reg [31:0] fact2_address_boundary = 32'h00050000;
    reg [31:0] fact3_address_boundary = 32'h00060000;
    
    // Timing constants for simulating interrupts coming from MIPS 
    integer DONE_PULSE_WIDTH = 5; 
    integer IACK_PULSE_WIDTH = 5;
    integer TIME_IN_BETWEEN_INTERRUPTS = 15;
    integer HALF_CLOCK_CYCLE = 5;
    integer ONE_CLOCK_CYCLE = 10;
    always begin
        #HALF_CLOCK_CYCLE clk = ~clk;
    end
    //////////////////////////////////////////////////////////////
    // Test helper functions
    //////////////////////////////////////////////////////////////
    task reset_test;
    begin
        IACK = 0;
        clk = 0;
        done <= 4'b0;
        write_enable <= 0;
        write_data <= 0;
        done <= 0;
    end
    endtask
    
    task simulate_interrupt;
    input [31:0] address_to_mm;
    begin
        input_addr <= address_to_mm;
        write_enable <= 1;
        if(address_to_mm >= fact3_address_boundary) begin
            $display("Simulating interrupt 3 from factorial unit");
            done <= 4'b1000;
            #ONE_CLOCK_CYCLE;
            done <= 4'b0000;
            #ONE_CLOCK_CYCLE;
            write_enable <= 0;
            #TIME_IN_BETWEEN_INTERRUPTS;
        end
        else if( (address_to_mm < fact3_address_boundary) && (address_to_mm >= fact2_address_boundary) ) begin
            $display("Simulating interrupt 2 from factorial unit");
            done <= 4'b0100;
            #ONE_CLOCK_CYCLE;
            done <= 4'b0000;
            #ONE_CLOCK_CYCLE;
            write_enable <= 0;
            #TIME_IN_BETWEEN_INTERRUPTS;
        end
        else if( (address_to_mm < fact2_address_boundary) && (address_to_mm >= fact1_address_boundary) ) begin
            $display("Simulating interrupt 1 from factorial unit");
            done <= 4'b0010;
            #ONE_CLOCK_CYCLE;
            done <= 4'b0000;
            #ONE_CLOCK_CYCLE;
            write_enable <= 0;
            #TIME_IN_BETWEEN_INTERRUPTS;
        end
        else if( (address_to_mm < fact1_address_boundary) && (address_to_mm >= fact0_address_boundary) ) begin
            $display("Simulating interrupt 0 from factorial unit");
            done <= 4'b0001;
            #ONE_CLOCK_CYCLE;
            done <= 4'b0000;
            #ONE_CLOCK_CYCLE;
            write_enable <= 0;
            #TIME_IN_BETWEEN_INTERRUPTS;
        end
    end
    endtask
    
    task send_iack;
    begin
        IACK <= 1;
        #ONE_CLOCK_CYCLE;
        IACK <= 0;
        #ONE_CLOCK_CYCLE;
        #TIME_IN_BETWEEN_INTERRUPTS;       
    end 
    endtask
    
    task write_isr_address;
    input [1:0] isr_index;
    input [31:0] isr_addr_to_write;
    begin
        write_data <= isr_addr_to_write;
        if(isr_index == 0) begin
            input_addr <= intc_reg0_addr;
        end
        else if (isr_index == 1) begin
            input_addr <= intc_reg1_addr;
        end
        else if (isr_index == 2) begin
            input_addr <= intc_reg2_addr;
        end
        else if (isr_index == 3) begin
            input_addr <= intc_reg3_addr;  
        end
        write_enable <= 1;
        #ONE_CLOCK_CYCLE;
        write_enable <= 0; 
        #ONE_CLOCK_CYCLE;
    end
    endtask
    
    task write_address_table;
    begin
        write_isr_address(0,isr0_addr_to_write);
        write_isr_address(1,isr1_addr_to_write);
        write_isr_address(2,isr2_addr_to_write);
        write_isr_address(3,isr3_addr_to_write);
    end
    endtask
    ////////////////////////////////////////////////////////////////////////
    // Checking functions for verification
    ////////////////////////////////////////////////////////////////////////
    reg [31:0] isr_addr_act_val;
    task check_addr_write;
    input [1:0] reg_index;
    input [31:0] expected_isr_addr;
    begin
        // set address = 
        if (reg_index == 0) begin
            // set read address
            input_addr = intc_reg0_addr;
        end
        else if (reg_index == 1) begin
            // set read address
            input_addr = intc_reg1_addr;
        end
        else if (reg_index == 2) begin
            // set read address
            input_addr = intc_reg2_addr;
        end 
        else if (reg_index == 3) begin
            // set read address
            input_addr = intc_reg3_addr;

        end 
        
        isr_addr_act_val = isr_addr_temp;
        if (isr_addr_act_val != expected_isr_addr) begin
            $display("FAIL! Isr Address Register value [%h] not equal to expected [%h]",isr_addr_act_val,expected_isr_addr);
        end
        else begin
            $display("Test Passed - Isr Address Register value [%h] equal to expected [%h]",isr_addr_act_val,expected_isr_addr);
        end            
    end
    endtask
    
    task check_irq;
    input irq;
    input expected_irq;
    begin
        if (irq != expected_irq) begin
            $display("FAIL! Controller IRQ [%h] not equal to expected [%h]",irq,expected_irq);
        end
        else begin
            $display("Test Passed - Controller IRQ [%d] equal to expected [%h]",irq,expected_irq);
        end
    end
    endtask
    
    task check_isr_addr;    
    input [31:0] act_isr_addr;
    input [31:0] expected_addr;
    begin
        if (act_isr_addr != expected_addr) begin
            $display("ISR address [%h] not equal to expected address [%h]",act_isr_addr,expected_addr);
        end
        else begin
            $display("Test Passed - ISR address [%h] equal to expected address [%h]",act_isr_addr,expected_addr);
        end
    end
    endtask
    
    /////////////////////////////////////////////////////////////////////
    // Tests
    /////////////////////////////////////////////////////////////////////
    task test_write_addr_table;
    begin
        $display("\n...\nRunning test test_write_isr_addr: Test ISR Address Writes\n...\n");
        
        write_address_table();
        check_addr_write(0,isr0_addr_to_write);
        check_addr_write(1,isr1_addr_to_write);
        check_addr_write(2,isr2_addr_to_write);
        check_addr_write(3,isr3_addr_to_write);
    end
    endtask
    
    
    task test_irq;
    begin
        $display("\n...\nRunning test test_irq: Test IRQ Behavior\n...\n");
        // send interrupt 3 done to interrupt controller
        simulate_interrupt(input_addr_test_interrupt3);
        //check that IRQ is enabled
        check_irq(irq_temp,1);
        send_iack;
        //check that IRQ is disabled after iack
        check_irq(IRQ,0);
    
        // send interrupt 2 done to interrupt controller
        simulate_interrupt(input_addr_test_interrupt2);
        check_irq(irq_temp,1);
        send_iack;
        check_irq(IRQ,0);
        
        // send interrupt 0 done to interrupt controller
        simulate_interrupt(input_addr_test_interrupt0);
        check_irq(irq_temp,1);
        send_iack;
        check_irq(IRQ,0);
                
        // send interrupt 1 done to interrupt controller
        simulate_interrupt(input_addr_test_interrupt1);
        check_irq(irq_temp,1);
        send_iack;
        check_irq(IRQ,0);    
    end
    endtask
    
    task test_isr_addr;
    begin
        $display("Running test test_isr_addr: Test Interrupt Service Routine Address");
        simulate_interrupt(input_addr_test_interrupt3);
        check_isr_addr(isr_addr_temp,isr3_addr_to_write);
        send_iack;
        check_isr_addr(isr_addr_temp,isr3_addr_to_write);
        
        simulate_interrupt(input_addr_test_interrupt2);
        check_isr_addr(isr_addr_temp,isr2_addr_to_write);
        send_iack;
        check_isr_addr(isr_addr_temp,isr2_addr_to_write);    
        
        simulate_interrupt(input_addr_test_interrupt0);
        check_isr_addr(isr_addr_temp,isr0_addr_to_write);
        send_iack;
        check_isr_addr(isr_addr_temp,isr0_addr_to_write);
        
        simulate_interrupt(input_addr_test_interrupt1);
        check_isr_addr(isr_addr_temp,isr1_addr_to_write);
        send_iack;
        check_isr_addr(isr_addr_temp,isr1_addr_to_write);                
        
    end
    endtask
    
    // always block to capture test data
    always@(posedge IRQ) begin
        //if(IRQ) begin
            #0.5;
            irq_temp <= IRQ;
            
    end
    
    always@(write_enable, input_addr) begin
            #HALF_CLOCK_CYCLE;
            isr_addr_temp <= read_data;
    end
    
    
    initial begin
        $display("==========================================================================");
        $display("== Beginning test tb_intc_top: Interrupt Controller Top Testbench");
        $display("==========================================================================");
        reset_test();
        test_write_addr_table();        
        //test_irq();
        //test_isr_addr();

        $finish;
      end
endmodule
