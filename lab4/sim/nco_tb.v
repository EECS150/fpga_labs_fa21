`timescale 1ns/1ns
`define CLK_PERIOD 8

module nco_tb();
    // Generate 125 Mhz clock
    reg clk = 0;
    always #(`CLK_PERIOD/2) clk = ~clk;

    // I/O
    reg [23:0] fcw;
    reg rst;
    wire [9:0] out;

    nco DUT (
        .clk(clk),
        .rst(rst),
        .fcw(fcw),
        .out(out)
    );

    initial begin
        `ifdef IVERILOG
            $dumpfile("nco_tb.fst");
            $dumpvars(0, nco_tb);
        `endif
        `ifndef IVERILOG
            $vcdpluson;
        `endif

        fork
            // Thread to drive code and check output
            begin
                rst = 1;
                fcw = 1;
                repeat (10) @(posedge clk);
                #1;
                rst = 0;
                repeat (10) @(posedge clk);
                #1;
                fcw = 2;
                repeat (10) @(posedge clk);
                #1;
            end
            // Thread to check next_sample
            begin

            end
        join

        $display("Test finished");

        `ifndef IVERILOG
            $vcdplusoff;
        `endif
        $finish();
    end
endmodule
