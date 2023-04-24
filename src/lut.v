`default_nettype none
`timescale 1ns/1ps

module lut #(
    parameter LUT_SIZE = 6
) (
    // Programming interface
    input wire prog_clk,
    input wire prog_en,
    input wire prog_in,
    output wire prog_out,
    // LUT IO
    input wire [LUT_SIZE - 1 : 0] lut_in,
    output wire lut_out
);

    localparam LUT_RAM_DEPTH = (1 << LUT_SIZE);
    reg [LUT_RAM_DEPTH - 1 : 0] lut_ram;

    // Program LUT RAM
    always @(posedge prog_clk) begin
        if (prog_en) begin
            lut_ram <= {lut_ram[LUT_RAM_DEPTH - 2 : 0], prog_in};
        end
    end
    assign prog_out = lut_ram[LUT_RAM_DEPTH - 1];

    // Output of LUT
    assign lut_out = lut_ram[lut_in];

endmodule

