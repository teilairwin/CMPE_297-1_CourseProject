`timescale 1ns / 1ps

module tb_factorial();
    reg         clk, rst;
    wire [1:0]  CS;
    reg  [3:0]  n;
    reg         go;
    wire [31:0] fact_n;
    wire [31:0] fact_calc;
    wire        done, error;
    reg         testPass;

    integer     i;

    fact fact (
        .clk        (clk),
        .rst        (rst),
        .go         (go),
        .in         (n),
        .Done       (done),
        .Error      (error),
        .CS         (CS),
        .result     (fact_n)
    );

    always begin
        #5 clk = ~clk;
    end

    initial begin
        clk         = 0; 
        testPass    = 1;
        rst         = 0;
        n           = 0;
        go          = 0;
        fact_calc   = 1;


        #10 rst      = 1;
        #20 rst      = 0;

        #10 n   = 3;
        #10 go  = 1;
        wait( done == 1 );
        #10 if (fact_n != (2*3)) begin
         testPass = 0;
        end

        // for (i = 0; i < 100; i++) begin
        //     #10 n = n + 1;
        //     #10 fact_calc = fact_calc * n;
        //     #10 go  = 1;
        //     wait( done == 1 );
        //     #10 if (fact_n != fact_calc) begin
        //     testPass = 0;
        //     end
        // end

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
