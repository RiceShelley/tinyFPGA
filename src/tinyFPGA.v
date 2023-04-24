`default_nettype none

module tinyFPGA (
  input wire [7:0] io_in,
  output wire [7:0] io_out
);

    // FPGA programming interface
    wire prog_clk;
    wire prog_en;
    wire prog_in;
    wire prog_out;

    assign prog_clk = io_in[0];
    assign prog_en = io_in[1];
    assign prog_in = io_in[2];
    assign io_out[0] = prog_out;

    // assign inputs to cluster
    wire [4:0] cluster_in = io_in[7:3];

    // outputs from cluster
    wire [4:0] cluster_out;
    assign io_out[7:3] = cluster_out;

    wire clk = io_in[0];
    wire rst = io_in[2] & (prog_en == 1'b0);

    localparam BEL_INPUT_WIDTH = 5;
    localparam BELS = 7;
    localparam CLUSTER_INPUT_WIDTH = 5;

    logic_cluster #(
        .BEL_INPUT_WIDTH(BEL_INPUT_WIDTH),
        .BELS(BELS),
        .CLUSTER_INPUT_WIDTH(CLUSTER_INPUT_WIDTH)
    ) logic_cluster_dut (
        // Programming interface
        .prog_clk       (prog_clk),
        .prog_en        (prog_en),
        .prog_in        (prog_in),
        .prog_out       (prog_out),
        // logic cluster
        .clk            (clk),
        .rst            (rst),
        .cluster_in     (cluster_in),
        .cluster_out    (cluster_out)
    );

endmodule
