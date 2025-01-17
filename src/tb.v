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
    input wire prog_in,
    input wire rst,

    output wire prog_out,

    output wire rst_out,

    input wire [4:0] fpga_inputs,
    output wire [3:0] fpga_outputs
   );

    localparam BEL_INPUT_WIDTH = 5;
    localparam BELS = 4;
    localparam CLUSTER_INPUT_WIDTH = 5;

    // this part dumps the trace to a vcd file that can be viewed with GTKWave
    initial begin
        $dumpfile ("tb.vcd");
        $dumpvars (0, tb);
        #1;
    end

    // wire up the inputs and outputs
    /* verilator lint_off UNOPTFLAT */
    wire [7:0] inputs = prog_en ? {5'd0, prog_en, prog_in, clk} : {fpga_inputs, prog_en, rst, clk};
    /* verilator lint_on UNOPTFLAT */

    /* verilator lint_off UNUSED */
    wire [7:0] outputs;
    /* verilator lint_on UNUSED */
    assign prog_out = outputs[6];

    localparam FPGA_OUTPUT_PINS = 4;
    assign fpga_outputs = outputs[0 +: FPGA_OUTPUT_PINS];

    assign rst_out = outputs[1];

    riceshelley_tinyFPGA dut(
        .io_in(inputs),
        .io_out(outputs)
    );

endmodule
