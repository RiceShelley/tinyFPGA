`default_nettype none
`timescale 1ns/1ps

module tinyFPGA (
  input wire [7:0] io_in,
  output wire [7:0] io_out
);
    localparam BEL_INPUT_WIDTH = 5;
    localparam BELS = 5;
    localparam CLUSTER_INPUT_WIDTH = 5;

    // FPGA programming interface
    wire prog_clk;
    wire prog_en;
    wire prog_in;
    wire prog_out;

    assign prog_clk = io_in[0];
    assign prog_en = io_in[1];
    assign prog_in = io_in[2];

    wire [BELS - 1 : 0] fpga_out;

    // assign inputs to cluster
    wire [4:0] cluster_in = io_in[7:3];


    assign io_out[0] = prog_out;
    assign io_out[7 : 3] = fpga_out;
    assign io_out[1] = rst;

    wire clk = io_in[0];
    wire rst = io_in[2] & (prog_en == 1'b0);

    // outputs from cluster
    wire [BELS - 1 : 0] cluster_out;
    wire cluster_prog_out;
    logic_cluster #(
        .BEL_INPUT_WIDTH(BEL_INPUT_WIDTH),
        .BELS(BELS),
        .CLUSTER_INPUT_WIDTH(CLUSTER_INPUT_WIDTH)
    ) logic_cluster_dut (
        // Programming interface
        .prog_clk       (prog_clk),
        .prog_en        (prog_en),
        .prog_in        (prog_in),
        .prog_out       (cluster_prog_out),
        // logic cluster
        .clk            (clk),
        .rst            (rst),
        .cluster_in     (cluster_in),
        .cluster_out    (cluster_out)
    );

    // Mux FPGA outputs
    genvar i;
    generate

        wire prog_mux_prog[BELS : 0];
        assign prog_mux_prog[0] = cluster_prog_out;

        for (i = 0; i < BELS; i = i + 1) begin : gen_output_mux
            prog_mux #(
                .INPUTS(BELS)
            ) prog_mux_inst (
                // Programming interface
                .prog_clk(prog_clk),
                .prog_en(prog_en),
                .prog_in(prog_mux_prog[i]),
                .prog_out(prog_mux_prog[i + 1]),
                // Mux signals
                .mux_in(cluster_out),
                .mux_out(fpga_out[i])
            );
        end

        assign prog_out = prog_mux_prog[BELS];
    endgenerate

endmodule
