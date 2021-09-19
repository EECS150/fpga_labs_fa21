module sampler(
    input clk,
    input next_sample,
    input [9:0] sampler_in,
    output reg [9:0] sampler_out
);
    assign sampler_out = 0;
    always @(posedge clk)
        if (next_sample)
            sampler_out <= sampler_in;
endmodule
