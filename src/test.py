import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge, FallingEdge, Timer, ClockCycles
import math

async def test_prog_chain(dut, prog_len):
    await RisingEdge(dut.clk)
    dut.prog_en.value = 1
    for i in range(0, prog_len):
        dut.prog_in.value = i % 2
        await RisingEdge(dut.clk)
    dut.prog_en.value = 0
    await RisingEdge(dut.clk)

@cocotb.test()
async def test_fpga(dut):
    dut._log.info("start")

    bel_input_width = dut.BEL_INPUT_WIDTH.value
    bels_in_cluster = dut.BELS.value
    cluster_input_width = dut.CLUSTER_INPUT_WIDTH.value

    bel_in_prog_mux_width = cluster_input_width + bels_in_cluster
    dut._log.info(f"bel input prog mux width {bel_in_prog_mux_width}")

    bel_in_prog_mux_prog_len = math.ceil(math.log2(bel_in_prog_mux_width))
    dut._log.info(f"bel in prog mux len {bel_in_prog_mux_prog_len}")

    prog_muxs_per_bel = bel_input_width
    dut._log.info(f"bel input prog muxs {prog_muxs_per_bel}")

    total_bel_prog_mux_cfg_bits = prog_muxs_per_bel * bel_in_prog_mux_prog_len
    dut._log.info(f"\ntotal bel prog mux cfg bits {total_bel_prog_mux_cfg_bits}")

    bel_lut_prog_len = (2 ** bel_input_width)
    bel_prog_mux_len = 1
    bel_prog_len = bel_lut_prog_len + bel_prog_mux_len

    dut._log.info(f"bel prog len {bel_prog_len}")

    total_bel_prog_len = bel_prog_len + total_bel_prog_mux_cfg_bits
    dut._log.info(f"total bel prog len {total_bel_prog_len}")

    # Cluster    
    dut._log.info(f"\nbels per cluster {bels_in_cluster}")
    cluster_config_len = bels_in_cluster * total_bel_prog_len
    dut._log.info(f"cluster config bits len {cluster_config_len}")

    # Output config mux
    fpga_outputs = bels_in_cluster
    dut._log.info(f"\nfpga outputs {fpga_outputs}")

    fout_prog_mux_cfg_len = math.ceil(math.log2(fpga_outputs))
    dut._log.info(f"output prog mux len {fout_prog_mux_cfg_len}")

    total_output_cfg_len = fout_prog_mux_cfg_len * fpga_outputs
    dut._log.info(f"total output cfg len {total_output_cfg_len}")

    total_bit_stream_len = total_output_cfg_len + cluster_config_len
    dut._log.info(f"total bit stream length {total_bit_stream_len}")


    dut.rst.value = 0
    dut.prog_en.value = 0
    dut.prog_in.value = 0
    clock = Clock(dut.clk, 10, units="us")
    cocotb.start_soon(clock.start())
    await ClockCycles(dut.clk, 100)

    # prog in -> bel 0 (prog_mux [4 : 0] -> bel N (prog_mux [4 : 0]) -> output pin prog muxs [3 : 0] -> prog out
    #def cfg_bel(lut_cfg, pin0_sel, pin1_sel, pin2_sel, pin3_sel, pin4_sel, ff_en):

    # Test that programming chain is correct
    await test_prog_chain(dut, total_bit_stream_len)
    assert (dut.prog_out.value == 0)

    await ClockCycles(dut.clk, 1000)
