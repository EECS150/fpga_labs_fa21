module dac #(
    CYCLES_PER_PERIOD = 4096
)(
    input clk,
    input code,
    output pwm
);
    assign pwm = 0;
endmodule
