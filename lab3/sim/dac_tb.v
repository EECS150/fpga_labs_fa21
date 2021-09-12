`timescale 1ns/1ns
`define CLK_PERIOD 8

module dac_tb();
    // Generate 125 Mhz clock
    reg clk = 0;
    always #(`CLK_PERIOD/2) clk = ~clk;

    // I/O
    reg [9:0] code;
    wire pwm, next_sample;

    dac #(.CYCLES_PER_WINDOW(1024)) DUT (
        .clk(clk),
        .code(code),
        .pwm(pwm),
        .next_sample(next_sample)
    );

    initial begin
        `ifdef IVERILOG
            $dumpfile("dac_tb.fst");
            $dumpvars(0, dac_tb);
        `endif
        `ifndef IVERILOG
            $vcdpluson;
        `endif

        fork
            // Thread to drive code and check output
            begin
                code = 0;
                repeat (1024) begin
                    @(posedge clk); #1;
                    assert(pwm == 0);
                end

                code = 1023;
                repeat (1024) begin
                    @(posedge clk); #1;
                    assert(pwm == 1);
                end

                code = 511;
                repeat (2) begin
                    repeat (512) begin
                        @(posedge clk); #1;
                        assert(pwm == 1);
                    end
                    repeat (512) begin
                        @(posedge clk); #1;
                        assert(pwm == 0);
                    end
                end
            end
            // Thread to check next_sample
            begin
                repeat (4) begin
                    assert(next_sample == 0);
                    repeat (1023) @(posedge clk); #1;
                    assert(next_sample == 1);
                    @(posedge clk); #1;
                    assert(next_sample == 0);
                end
            end
        join

        $display("Test finished");

        `ifndef IVERILOG
            $vcdplusoff;
        `endif
        $finish();
    end
endmodule
