`timescale 1ns/1ns

`define CLK_PERIOD 8
`define DEBOUNCER_WIDTH 1
`define SAMPLE_CNT_MAX 10
`define PULSE_CNT_MAX 4

// This testbench checks that your debouncer smooths-out the input signals properly. Refer to the spec for details.

module debouncer_tb();
  // Generate 125 MHz clock
  reg clk = 0;
  always #(`CLK_PERIOD/2) clk = ~clk;

  // I/O of debouncer
  reg [`DEBOUNCER_WIDTH-1:0] glitchy_signal;
  wire [`DEBOUNCER_WIDTH-1:0] debounced_signal;

  debouncer #(
    .WIDTH(`DEBOUNCER_WIDTH),
    .SAMPLE_CNT_MAX(`SAMPLE_CNT_MAX),
    .PULSE_CNT_MAX(`PULSE_CNT_MAX)
  ) DUT (
    .clk(clk),
    .glitchy_signal(glitchy_signal),
    .debounced_signal(debounced_signal)
  );

  // Testbench variables
  reg test0_done = 0;
  initial begin
    #0;
    glitchy_signal = 0;
        
    #20;
        
    // We will use our first glitchy_signal to verify that if a signal bounces around and goes low
    // before the saturating counter saturates, that the output never goes high
    // Initially act glitchy
    repeat(10) begin
      glitchy_signal[0] = ~glitchy_signal[0];
      @(posedge clk);
    end
        
    // Bring the signal high and hold until before the saturating counter should saturate, then pull low
    glitchy_signal[0] = 1;
    repeat (`SAMPLE_CNT_MAX * (`PULSE_CNT_MAX - 1)) @(posedge clk);
        
    // Pull the signal low and wait, the debouncer shouldn't set its output high
    glitchy_signal[0] = 0;
    repeat (`SAMPLE_CNT_MAX * (`PULSE_CNT_MAX + 1)) @(posedge clk);
        
    test0_done = 1;
        
    // We will use the second glitchy_signal to verify that if a signal bounces around and stays high
    // long enough for the counter to saturate, that the output goes high and stays there until the glitchy_signal falls
    // Initially act glitchy
    repeat (10) begin
      glitchy_signal[0] = ~glitchy_signal[0];
      @(posedge clk);
    end
        
    // Bring the glitchy signal high and hold past the point at which the debouncer should saturate
    glitchy_signal[0] = 1;
    repeat (`SAMPLE_CNT_MAX * (`PULSE_CNT_MAX + 1)) @(posedge clk);

    if (debounced_signal[0] != 1)
      $display("Failure 1: The debounced output[0] should have gone high by now %d", $time);
    @(posedge clk);

    // While the glitchy signal is high, the debounced output should remain high
    repeat (`SAMPLE_CNT_MAX * 3) begin
      if (debounced_signal[0] != 1)
        $display("Failure 2: The debounced output[0] should stay high once the counter saturates at %d", $time);
        @(posedge clk);
    end

    // Pull the glitchy signal low and the output should fall after the next sampling period
    // The output is only guaranteed to fall after the next sampling period
    // Wait until another sampling period has definetely occured
    glitchy_signal[0] = 0;
    repeat (`SAMPLE_CNT_MAX + 1) @(posedge clk);

    if (debounced_signal[0] != 0)
      $display("Failure 3: The debounced output[0] should have falled by now %d", $time);
    @(posedge clk);

    // Wait for some time to ensure the signal stays low
    repeat (`SAMPLE_CNT_MAX * (`PULSE_CNT_MAX + 1)) begin
      if (debounced_signal[0] != 0)
        $display("Failure 4: The debounced output[0] should remain low at %d", $time);
        @(posedge clk);
    end
        
    #100;
        
    $display("Done!");
    $finish();      
  end

  // this checks that the output of the first debouncer never goes high
  initial begin
    while (test0_done == 0) begin
      if (debounced_signal[0] != 0)
        $display("Failure 0: The debounced output[0] wasn't 0 for the entire test.");
        @(posedge clk);
    end
  end
 
endmodule
