`default_nettype none
`timescale 1ns/1ps

module prog_mux#(
    parameter INPUTS = 2
) (
    // Programming interface
    input wire prog_clk,
    input wire prog_en,
    input wire prog_in,
    output wire prog_out,
    // mux signals
    input wire [INPUTS - 1 : 0] mux_in,
    output wire mux_out
);

    localparam SEL_WIDTH = $clog2(INPUTS);
    reg [SEL_WIDTH - 1 : 0] sel_reg;

    // Program mux sel reg
    wire [SEL_WIDTH - 1 : 0] next_sel;
    generate
        if (SEL_WIDTH == 1) begin
            assign next_sel[0] = prog_in;
        end else begin
            assign next_sel = {sel_reg[SEL_WIDTH - 2 : 0], prog_in};
        end
    endgenerate

    always @(posedge prog_clk) begin
        if (prog_en) begin
            sel_reg <= next_sel;
        end
    end
    assign prog_out = sel_reg[SEL_WIDTH - 1];

    assign mux_out = mux_in[sel_reg];

endmodule
