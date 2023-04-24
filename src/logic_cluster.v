`default_nettype none
`timescale 1ns/1ps

module logic_cluster #(
    parameter BEL_INPUT_WIDTH = 6,
    parameter BELS = 5,
    parameter CLUSTER_INPUT_WIDTH = 5
) (
    // Programming interface
    input wire prog_clk,
    input wire prog_en,
    input wire prog_in,
    output wire prog_out,

    // logic cluster
    input wire clk,
    input wire rst,
    input wire [CLUSTER_INPUT_WIDTH - 1 : 0] cluster_in,
    output wire [BELS - 1 : 0] cluster_out
);

    wire bel_prog[BELS : 0];
    assign bel_prog[0] = prog_in;

    assign prog_out = bel_prog[BELS];


    wire [BELS - 1 : 0] bel_outputs;

    localparam BEL_IN_CONNS = (BELS + CLUSTER_INPUT_WIDTH);
    /* Possible inputs to a bel in a logic cluster are all the inputs
    * to the logic cluster + all the outputs of the bels
    */
    /* verilator lint_off UNOPTFLAT */
    wire [BEL_IN_CONNS - 1 : 0] bel_in_conn_bus = {bel_outputs, cluster_in};
    /* verilator lint_on UNOPTFLAT */

    genvar i;
    genvar j;
    generate
        for (i = 0; i < BELS; i = i + 1) begin : gen_ble

            wire [BEL_INPUT_WIDTH - 1 : 0] bel_inputs;
            wire bel_prog_out;
            bel #(
                .INPUT_WIDTH(BEL_INPUT_WIDTH)
            ) bel_inst (
                // Programming interface
                .prog_clk(prog_clk),
                .prog_en(prog_en),
                .prog_in(bel_prog[i]),
                .prog_out(bel_prog_out),
                // BEL IO
                .clk(clk),
                .rst(rst),
                .bel_in(bel_inputs),
                .bel_out(bel_outputs[i])
            );

            wire prog_mux_prog[BEL_INPUT_WIDTH : 0];
            assign prog_mux_prog[0] = bel_prog_out;

            for (j = 0; j < BEL_INPUT_WIDTH; j = j + 1) begin : gen_input_mux
                prog_mux #(
                    .INPUTS(BEL_IN_CONNS)
                ) prog_mux_inst (
                    // Programming interface
                    .prog_clk(prog_clk),
                    .prog_en(prog_en),
                    .prog_in(prog_mux_prog[j]),
                    .prog_out(prog_mux_prog[j + 1]),
                    // Mux signals
                    .mux_in(bel_in_conn_bus),
                    .mux_out(bel_inputs[j])
                );
            end

            assign bel_prog[i + 1] = prog_mux_prog[BEL_INPUT_WIDTH];
            
        end
    endgenerate

    assign cluster_out = bel_outputs;

endmodule
