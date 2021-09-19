module fsm #(
    parameter CLOCK_FREQ = 125_000_000,
    parameter WIDTH = $clog2(CLOCK_FREQ)
)(
    input clk,
    input rst,
    input [2:0] buttons,
    input [23:0] d_out,
    output [3:0] leds,
    output [1:0] addr,
    output wr_en,
    output [23:0] d_in
);
    assign leds = 0;
    assign addr = 0;
    assign wr_en = 0;
    assign d_in = 0;
endmodule
