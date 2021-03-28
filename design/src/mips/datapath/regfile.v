module regfile (
        input  wire        clk,
        input  wire        rst,
        input  wire        we,
        input  wire [4:0]  ra1,
        input  wire [4:0]  ra2,
        input  wire [4:0]  ra3,
        input  wire [4:0]  wa,
        input  wire [31:0] wd,
        output wire [31:0] rd1,
        output wire [31:0] rd2,
        output wire [31:0] rd3
    );

    reg [31:0] rf [0:31];

    integer n;
    
    initial begin
        for (n = 0; n < 32; n = n + 1) rf[n] = 32'h0;
        rf[29] = 32'h100; // Initialze $sp
    end
    
    always @ (posedge clk) begin
        if (rst) begin 
            rf[ 1] <= 32'h0; rf[ 2] <= 32'b0; rf[ 3] <= 32'b0;
            rf[ 4] <= 32'h0; rf[ 5] <= 32'b0; rf[ 6] <= 32'b0; rf[ 7] <= 32'b0;
            rf[ 8] <= 32'h0; rf[ 9] <= 32'b0; rf[10] <= 32'b0; rf[11] <= 32'b0;
            rf[12] <= 32'h0; rf[13] <= 32'b0; rf[14] <= 32'b0; rf[15] <= 32'b0;
            rf[16] <= 32'h0; rf[17] <= 32'b0; rf[18] <= 32'b0; rf[19] <= 32'b0;
            rf[20] <= 32'h0; rf[21] <= 32'b0; rf[22] <= 32'b0; rf[23] <= 32'b0;
            rf[24] <= 32'h0; rf[25] <= 32'b0; rf[26] <= 32'b0; rf[27] <= 32'b0;
            rf[28] <= 32'h0; rf[29] <= 32'b0; rf[30] <= 32'b0; rf[31] <= 32'b0;
        end
        else if (we) rf[wa] <= wd;
    end

    assign rd1 = (ra1 == 0) ? 0 : rf[ra1];
    assign rd2 = (ra2 == 0) ? 0 : rf[ra2];
    assign rd3 = (ra3 == 0) ? 0 : rf[ra3];

endmodule