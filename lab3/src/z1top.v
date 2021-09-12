`define CLOCK_FREQ 125_000_000

`define BUTTON_COUNTER

module z1top (
    input CLK_125MHZ_FPGA,
    input [3:0] BUTTONS,
    input [1:0] SWITCHES,
    output [5:0] LEDS
);
`ifdef BUTTON_COUNTER
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

    reg [3:0] counter;

    assign LEDS[3:0] = counter;
    always @(posedge CLK_125MHZ_FPGA) begin
        if (buttons_pressed[0])
            counter <= counter + 4'd1;
        else if (buttons_pressed[1])
            counter <= counter - 4'd1;
        else if (buttons_pressed[2])
            counter <= counter << 1;
        else if (buttons_pressed[3])
            counter <= 4'd0;
        else
            counter <= counter;
    end
`else

`endif
endmodule
