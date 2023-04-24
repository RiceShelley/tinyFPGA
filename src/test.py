import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge, FallingEdge, Timer, ClockCycles
import math



async def cfg_bel(dut, bel_prog, bel_prog_width):
    await RisingEdge(dut.prog_clk)
    dut.prog_en.value = 1
    for i in range(bel_prog_width, 0, -1):
        dut.prog_in.value = (bel_prog >> (i - 1)) & 0x1
        await RisingEdge(dut.prog_clk)
    dut.prog_en.value = 0
    await RisingEdge(dut.prog_clk)

@cocotb.test()
async def test_fpga(dut):
    dut._log.info("start")

    bel_input_width = dut.dut.BEL_INPUT_WIDTH.value
    bels_in_cluster = dut.dut.BELS.value
    cluster_input_width = dut.dut.CLUSTER_INPUT_WIDTH.value

    bel_in_prog_mux_width = cluster_input_width + bels_in_cluster
    dut._log.info(f"bel input prog mux width {bel_in_prog_mux_width}")

    bel_in_prog_mux_prog_len = math.ceil(math.log2(bel_in_prog_mux_width))
    dut._log.info(f"bel in prog mux len {bel_in_prog_mux_prog_len}")


    clock = Clock(dut.clk, 10, units="us")
    cocotb.start_soon(clock.start())

    await ClockCycles(dut.clk, 1000)
