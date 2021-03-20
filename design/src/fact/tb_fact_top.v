`timescale 1ns / 1ps

module tb_fact_top();
    reg         clk, rst;
    reg  [1:0]  addr;
    reg  [3:0]  n;          // Write Data
    reg         go;         // Write Enable
    wire [31:0] fact_n;     // Read Data
    wire        done;
//    wire [31:0] fact_calc;
    reg         testPass;

    integer     i;

    fact_top fact_top (
        .A          (addr),
        .clk        (clk),
        .rst        (rst),
        .WE         (go),
        .WD         (n),
        .RD         (fact_n),
        .Done       (done)
    );

    always begin
        #5 clk = ~clk;
    end

    initial begin
        addr        = 2'b01;
        clk         = 0;
        rst         = 0;
        testPass    = 1;
        n           = 0;
        go          = 0;
//        fact_calc   = 1;


        #10 rst      = 1;
        #20 rst      = 0;

        // for (i = 0; i < 100; i++) begin
        //     #10 n = n + 1;
        //     #10 fact_calc = fact_calc * n;
        //     #10 go  = 1;
        //     wait( done == 1 );
        //     #10 if (fact_n != fact_calc) begin
        //     testPass = 0;
        //     end
        // end

        #10 n   = 3;
        #10 go  = 1;
        wait( done == 1 );
        #10 if (fact_n != (2*3)) begin
         testPass = 0;
        end

        #10 n   = 4;
        #10 go  = 1;
        wait( done == 1 );
        #10 if (fact_n != (2*3*4)) begin
         testPass = 0;
        end

        #10 n   = 5;
        #10 go  = 1;
        wait( done == 1 );
        #10 if (fact_n != (2*3*4*5)) begin
         testPass = 0;
        end

        #10 n   = 6;
        #10 go  = 1;
        wait( done == 1 );
        #10 if (fact_n != (2*3*4*5*6)) begin
         testPass = 0;
        end

        #10 n   = 7;
        #10 go  = 1;
        wait( done == 1 );
        #10 if (fact_n != (2*3*4*5*6*7)) begin
         testPass = 0;
        end

        #10 n   = 8;
        #10 go  = 1;
        wait( done == 1 );
        #10 if (fact_n != (2*3*4*5*6*7*8)) begin
         testPass = 0;
        end

        #10 n   = 9;
        #10 go  = 1;
        wait( done == 1 );
        #10 if (fact_n != (2*3*4*5*6*7*8*9)) begin
         testPass = 0;
        end

        #10 n   = 10;
        #10 go  = 1;
        wait( done == 1 );
        #10 if (fact_n != (2*3*4*5*6*7*8*9*10)) begin
         testPass = 0;
        end

        #10 n   = 11;
        #10 go  = 1;
        wait( done == 1 );
        #10 if (fact_n != (2*3*4*5*6*7*8*9*10*11)) begin
         testPass = 0;
        end

        #10 n   = 12;
        #10 go  = 1;
        wait( done == 1 );
        #10 if (fact_n != (2*3*4*5*6*7*8*9*10*11*12)) begin
         testPass = 0;
        end

        #10 n   = 13;
        #10 go  = 1;
        wait( done == 1 );
        #10 if (fact_n != (2*3*4*5*6*7*8*9*10*11*12*13)) begin
         testPass = 0;
        end

        #10 n   = 14;
        #10 go  = 1;
        wait( done == 1 );
        #10 if (fact_n != (2*3*4*5*6*7*8*9*10*11*12*13*14)) begin
         testPass = 0;
        end

        #1200 $finish;
    end
endmodule
