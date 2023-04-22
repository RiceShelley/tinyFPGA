`default_nettype none

module logic_cluster_tb#(
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

    // Macro to dump signals
    `ifdef COCOTB_SIM
        initial begin
            $dumpfile ("logic_cluster_tb.vcd");
            $dumpvars (0, logic_cluster_tb);
            #1;
        end
    `endif


    logic_cluster #(
        .BEL_INPUT_WIDTH(6),
        .BELS(5),
        .CLUSTER_INPUT_WIDTH(5)
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
