module sq_wave_gen #(
    parameter STEP = 20
)(
    input clk,
    input next_sample,
    input [3:0] buttons,
    output [9:0] code,
    output [3:0] leds
);
    assign code = 0;
    assign leds = 0;
endmodule
