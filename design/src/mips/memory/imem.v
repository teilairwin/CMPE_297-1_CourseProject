module imem (
        input  wire [5:0]  a,
        output wire [31:0] y
    );

    reg [31:0] rom [0:63];

    initial begin
        $readmemh ("a4_polling.dat", rom);
    end

    assign y = rom[a];
    
endmodule