module fcw_ram(
    input clk,
    input rst,
    input rd_en,
    input wr_en,
    input [1:0] addr,
    input [23:0] d_in,
    output [23:0] d_out
);
    reg [23:0] ram [3:0];

    assign d_out = (rd_en) ? ram[addr] : 24'b0;

    always @(posedge clk) begin
        if (rst) begin
            ram[0] <= 24'd0; // replace the RAM reset values with the values you computed
            ram[1] <= 24'd0;
            ram[2] <= 24'd0;
            ram[3] <= 24'd0;
        end
        else if (wr_en)
            ram[addr] <= d_in;
    end
endmodule
