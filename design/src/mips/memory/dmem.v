 module dmem (
        input  wire        clk,
        input  wire        we,
        input  wire [5:0]  a,
        input  wire [31:0] d,
        output wire [31:0] q
    );

    reg [31:0] ram [0:63];

    integer n;

    initial begin
        for (n = 0; n < 64; n = n + 1) ram[n] = 32'hFFFFFFFF;
    end

    always @ (posedge clk) begin
        if (we) ram[a] <= d;
    end

    assign q = ram[a];
    
endmodule


 module dmem4 (
        input  wire        clk,
        input  wire        we,
        input  wire [5:0]  a,
        input  wire [31:0] d0,
        input  wire [31:0] d1,
        input  wire [31:0] d2,
        input  wire [31:0] d3,
        output wire [31:0] q0,
        output wire [31:0] q1,
        output wire [31:0] q2,
        output wire [31:0] q3
    );

    reg [31:0] ram [0:63];

    integer n;

    initial begin
        for (n = 0; n < 64; n = n + 1) ram[n] = 32'hFFFFFFFF;
    end

    always @ (posedge clk) begin
        if (we) ram[a] <= d;
    end

    assign q = ram[a];
    
endmodule