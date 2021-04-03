///////////////////////////////////////////////////////////////////////////////
//Description: Basic instruction memory model
///////////////////////////////////////////////////////////////////////////////
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

///////////////////////////////////////////////////////////////////////////////
//Description: ROM memory model that can be loaded and examined externally
///////////////////////////////////////////////////////////////////////////////
module rom_loadable (
        input wire clk,
        input  wire [5:0]  read_addr,  //Host system Read-Addr
        output wire [31:0] read_data,  //Host system Read-Data
        
        input wire write_enable,       //External Write-Enable
        input wire [5:0] write_addr,   //External Write/Read-Addr
        input wire [31:0] write_data,  //External Write-Data
        output wire [31:0] read_data2  //External Read-Data
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
