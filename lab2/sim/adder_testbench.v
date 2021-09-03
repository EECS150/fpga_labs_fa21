`timescale 1ns/1ns

`define SECOND 1000000000
`define MS 1000000

module adder_testbench();
    reg [13:0] a;
    reg [13:0] b;
    wire [14:0] sum;
  
    structural_adder sa (
        .a(a),
        .b(b),
        .sum(sum)
    );
  
    initial begin
        `ifdef IVERILOG
            $dumpfile("tone_generator_testbench.fst");
            $dumpvars(0,tone_generator_testbench);
        `endif
        `ifndef IVERILOG
            $vcdpluson;
        `endif
  
        // Change input values and step forward in time to test
        // your counter and its clock enable/disable functionality.
        a = 14'd1;
        b = 14'd1;
        #(10 * `MS);
        
        a = 14'd0;
        b = 14'd1;
        #(10 * `MS);
  
        a = 14'd10;
        b = 14'd10;
        #(10 * `MS);
  
        `ifndef IVERILOG
            $vcdplusoff;
        `endif
        $finish();
    end
endmodule

