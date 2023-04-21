`default_nettype none
`timescale 1ns/1ps

/*
this testbench just instantiates the module and makes some convenient wires
that can be driven / tested by the cocotb test.py
*/

module tb (
    // testbench is controlled by test.py
    input wire clk,
    input wire prog_en,
    input wire rst,

    output wire prog_out,

    input wire [4:0] fpga_inputs,
    output wire [4:0] fpga_outputs
   );

    // this part dumps the trace to a vcd file that can be viewed with GTKWave
    initial begin
        $dumpfile ("tb.vcd");
        $dumpvars (0, tb);
        #1;
    end

    // wire up the inputs and outputs
    wire [7:0] inputs = {fpga_inputs, rst, prog_en, clk};
    wire [7:0] outputs;
    assign prog_out = outputs[0];
    assign fpga_outputs = outputs[7:3];

    tinyFPGA dut(
        .io_in(inputs),
        .io_out(outputs)
    );

endmodule
