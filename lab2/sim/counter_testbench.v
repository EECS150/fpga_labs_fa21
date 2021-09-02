`timescale 1ns/1ns

`define SECOND 1000000000
`define MS 1000000

module counter_testbench();
  reg clock;
  reg ce = 0;
  wire [5:0] LEDS;

  counter ctr (
    .clk(clock),
    .ce(ce),
    .LEDS(LEDS)
  );

  // Notice that this code causes the `clock` signal to constantly
  // switch up and down every 4 time steps.
  always #(4) clock <= ~clock;

  initial begin
    // TODO: Change input values and step forward in time to test
    // your counter and its clock enable/disable functionality.
    
    $finish();
  end

  
endmodule

