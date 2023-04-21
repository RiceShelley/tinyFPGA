`default_nettype none

module bel_tb#(
    parameter INPUT_WIDTH = 6
) (
    // Programming interface
    input wire prog_clk,
    input wire prog_en,
    input wire prog_in,
    output wire prog_out,

    // BEL IO
    input wire clk,
    input wire rst
);

    // Macro to dump signals
    `ifdef COCOTB_SIM
        initial begin
            $dumpfile ("bel_tb.vcd");
            $dumpvars (0, bel_tb);
            #1;
        end
    `endif

    wire bel_out;
    wire [INPUT_WIDTH - 1 : 0] bel_in;

    assign bel_in[0] = bel_out;
    assign bel_in[INPUT_WIDTH - 1 : 1] = 0;

    bel #(
        .INPUT_WIDTH(INPUT_WIDTH)
    ) bel_inst (
        // Programming interface
        .prog_clk(prog_clk),
        .prog_en(prog_en),
        .prog_in(prog_in),
        .prog_out(prog_out),
        // BEL IO
        .clk(clk),
        .rst(rst),
        .bel_in(bel_in),
        .bel_out(bel_out)
    );

endmodule