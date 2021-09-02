`timescale 1ns/1ns

module z1top_counter (
  input CLK_125MHZ_FPGA,
  input [3:0] BUTTONS,
  input [1:0] SWITCHES,
  output [5:0] LEDS
);
  assign LEDS[5:4] = 0;

  // Some initial code has been provided for you
  wire [3:0] counter_led_value;
  assign LEDS[3:0] = counter_led_value;

  counter ctr (
    .clk(CLK_125MHZ_FPGA),
    .ce(SWITCHES[0]),
    .LEDS(counter_led_value)
  );
endmodule

