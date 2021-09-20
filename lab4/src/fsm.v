module fsm #(
    parameter CLOCK_FREQ = 125_000_000,
    parameter WIDTH = $clog2(CLOCK_FREQ)
)(
    input clk,
    input rst,
    input [2:0] buttons,
    output [3:0] leds,
    output [23:0] fcw
);
    assign leds = 0;
    assign addr = 0;
    assign wr_en = 0;
    assign d_in = 0;

    wire [1:0] addr;
    wire wr_en, rd_en;
    wire [23:0] d_in, d_out;

    fcw_ram notes (
        .clk(clk),
        .rst(rst),
        .rd_en(rd_en),
        .wr_en(wr_en),
        .addr(addr),
        .d_in(d_in),
        .d_out(d_out)
    );
endmodule
