module sq_wave_gen #(
    parameter STEP = 20
)(
    input clk,
    input next_sample,
    input [3:0] buttons,
    output [9:0] code
);
    assign code = 0;
endmodule
