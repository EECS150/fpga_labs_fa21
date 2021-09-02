module tone_generator (
    input output_enable,
    input clk,
    output square_wave_out
);
    reg [0:0] clock_counter;

    assign square_wave_out = 1'b0;
endmodule
