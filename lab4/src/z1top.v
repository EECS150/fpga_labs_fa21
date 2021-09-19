`define CLOCK_FREQ 125_000_000

`define SQ_WAVE_CIRCUIT

module z1top (
    input CLK_125MHZ_FPGA,
    input [3:0] BUTTONS,
    input [1:0] SWITCHES,
    output [5:0] LEDS,
    output AUD_PWM,
    output AUD_SD
);
    assign LEDS[5:4] = 2'b11;

    // Button parser test circuit
    // Sample the button signal every 500us
    localparam integer B_SAMPLE_CNT_MAX = $rtoi(0.0005 * `CLOCK_FREQ);
    // The button is considered 'pressed' after 100ms of continuous pressing
    localparam integer B_PULSE_CNT_MAX = $rtoi(0.100 / 0.0005);

    wire [3:0] buttons_pressed;
    button_parser #(
        .WIDTH(4),
        .SAMPLE_CNT_MAX(B_SAMPLE_CNT_MAX),
        .PULSE_CNT_MAX(B_PULSE_CNT_MAX)
    ) bp (
        .clk(CLK_125MHZ_FPGA),
        .in(BUTTONS),
        .out(buttons_pressed)
    );

    assign AUD_SD = SWITCHES[1]; // 1 = audio enabled

    wire next_sample;
    wire [9:0] code;

    dac #(
        .CYCLES_PER_WINDOW(1024)
    ) dac (
        .clk(CLK_125MHZ_FPGA),
        .code(code),
        .next_sample(next_sample),
        .pwm(AUD_PWM)
    );

`ifdef SQ_WAVE_CIRCUIT
    sq_wave_gen gen (
        .clk(CLK_125MHZ_FPGA),
        .next_sample(next_sample),
        .buttons(buttons_pressed),
        .code(code),
        .leds(LEDS[3:0])
    );
`else
    wire [23:0] fcw;
    wire [1:0] addr;
    wire [23:0] d_in;
    wire wr_en;

    fcw_ram fcw_ram(
        .clk(CLK_125MHZ_FPGA),
        .rst(buttons_pressed[3]),
        .rd_en(1'b1),
        .wr_en(wr_en),
        .addr(addr),
        .d_in(d_in),
        .d_out(fcw)
    );


    wire [9:0] nco_out;
    nco nco(
        .clk(CLK_125MHZ_FPGA),
        .rst(buttons_pressed[3]),
        .fcw(fcw),
        .out(nco_out)
    );

    sampler sampler(
        .clk(CLK_125MHZ_FPGA),
        .next_sample(next_sample),
        .sampler_in(nco_out),
        .sampler_out(code)
    );

    fsm fsm(
        .clk(CLK_125MHZ_FPGA),
        .buttons(buttons_pressed),
        .d_out(fcw),
        .leds(LEDS[3:0]),
        .addr(addr),
        .wr_en(wr_en),
        .d_in(d_in)
    );
`endif
endmodule
