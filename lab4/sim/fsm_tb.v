`timescale 1ns/1ns
`define CLK_PERIOD 8

module fsm_tb();
    // Generate 125 Mhz clock
    reg clk = 0;
    always #(`CLK_PERIOD/2) clk = ~clk;

    // I/O
    reg rst;
    reg next_sample;
    reg [2:0] buttons;
    wire [9:0] code;
    wire [23:0] fcw;
    wire [3:0] leds;
    wire [1:0] leds_state;

    nco nco (
        .clk(clk),
        .rst(rst),
        .fcw(fcw),
        .next_sample(next_sample),
        .code(code)
    );

    fsm DUT (
        .clk(clk),
        .rst(rst),
        .buttons(buttons),
        .leds(leds),
        .leds_state(leds_state),
        .fcw(fcw)
    );

    integer code_file;
    integer next_sample_fetch;
    integer num_samples_fetched = 0;
    initial begin
        `ifdef IVERILOG
            $dumpfile("fsm_tb.fst");
            $dumpvars(0, fsm_tb);
        `endif
        `ifndef IVERILOG
            $vcdpluson;
        `endif

        code_file = $fopen("fsm_codes.txt", "w");
        rst = 1;
        next_sample = 0;
        @(posedge clk); #1;
        rst = 0;

        fork
            // Thread to pull samples from the NCO
            begin
                repeat (122000) begin
                    // Pull next_sample every X cycles where X is a random number in [2, 9]
                    next_sample_fetch = ($urandom() % 8) + 2;
                    repeat (next_sample_fetch) @(posedge clk);
                    #1;
                    next_sample = 1;
                    @(posedge clk); #1;
                    $fwrite(code_file, "%d\n", code);
                    num_samples_fetched = num_samples_fetched + 1;
                    next_sample = 0;
                    @(posedge clk); #1;
                end
            end
            // Thread for you to test the FSM
            begin
                buttons = 0;
                // TODO: toggle the buttons
                // verify state transitions with the LEDs
                // verify fcw is being set properly by the FSM
            end
        join

        $fclose(code_file);

        `ifndef IVERILOG
            $vcdplusoff;
        `endif
        $finish();
    end
endmodule
