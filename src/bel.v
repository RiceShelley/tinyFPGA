`default_nettype none
`timescale 1ns/1ps

module bel#(
    parameter INPUT_WIDTH = 6
) (
    // Programming interface
    input wire prog_clk,
    input wire prog_en,
    input wire prog_in,
    output wire prog_out,

    // BEL IO
    input wire clk,
    input wire rst,
    input wire [INPUT_WIDTH - 1 : 0] bel_in,
    output wire bel_out
);

    // LUT for BEL Comb logic
    wire lut_prog_out;
    wire lut_out;
    lut #(
        .LUT_SIZE(INPUT_WIDTH)
    ) lut_inst (
        // Prog iface to LUT
        .prog_clk(prog_clk),
        .prog_en(prog_en),
        .prog_in(prog_in),
        .prog_out(lut_prog_out),
        // LUT IO
        .lut_in(bel_in),
        .lut_out(lut_out)
    );

    // Optional register at output of LUT
    reg d_ff;
    always @(posedge clk) begin
        if (rst == 1'b1) begin
            d_ff <= 0;
        end else begin
            d_ff <= lut_out;
        end
    end

    // Mux between BEL output as Comb or Registered
    prog_mux #(
        .INPUTS(2)
    ) prog_mux_inst (
        // Prog iface to LUT
        .prog_clk(prog_clk),
        .prog_en(prog_en),
        .prog_in(lut_prog_out),
        .prog_out(prog_out),
        // Mux signals
        .mux_in({d_ff, lut_out}),
        .mux_out(bel_out)
    );

endmodule
