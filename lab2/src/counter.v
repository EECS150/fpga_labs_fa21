module counter (
  input clk,
  input ce,
  output [5:0] LEDS
);
  assign LEDS[5:4] = 0;

  // Some initial code has been provided for you
  // You can change this code if needed
  reg [3:0] led_cnt_value;
  assign LEDS[3:0] = led_cnt_value;

  // TODO: Instantiate a reg net to count the number of cycles
  // required to reach one second. Note that our clock period is 8ns.
  // Think about how many bits are needed for your reg.

  always @(posedge clk) begin
    // TODO: update the reg if clock is enabled (ce is 1).
    // Once the requisite number of cycles is reached, increment the count.

  end
endmodule

