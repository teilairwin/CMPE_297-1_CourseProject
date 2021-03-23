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

module rom_loadable (
        input wire clk,
        input  wire [5:0]  read_addr,
        output wire [31:0] read_data,
        input wire write_enable,
        input wire [5:0] write_addr,
        input wire [31:0] write_data,
        output wire [31:0] read_data2
    );

    reg [31:0] rom [0:63];

    integer n;
    initial begin
        for (n = 0; n < 64; n = n + 1) rom[n] = 32'h00000000;
    end

    always @ (posedge clk) begin
        if (write_enable) rom[write_addr] <= write_data;
    end

    assign read_data = rom[read_addr];
    assign read_data2 = rom[write_addr];
endmodule
