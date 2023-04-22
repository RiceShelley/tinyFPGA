import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge, FallingEdge, Timer, ClockCycles
from scipy.fft import fft
import numpy as np
from random import getrandbits
from cocotb.regression import TestFactory

async def cfg_bel(dut, bel_prog, bel_prog_width):
    await RisingEdge(dut.prog_clk)
    dut.prog_en.value = 1
    for i in range(bel_prog_width, 0, -1):
        dut.prog_in.value = (bel_prog >> (i - 1)) & 0x1
        await RisingEdge(dut.prog_clk)
    dut.prog_en.value = 0
    await RisingEdge(dut.prog_clk)

@cocotb.test()
async def cluster_test(dut):
    dut._log.info("start")

    bel_input_width = dut.BEL_INPUT_WIDTH.value
    bels = dut.BELS.value
    cluster_input_width = dut.CLUSTER_INPUT_WIDTH.value

    dut._log.info(f"bel input width = {bel_input_width}")
    dut._log.info(f"bels = {bels}")
    dut._log.info(f"cluster input width = {cluster_input_width}")

    prog_clock = Clock(dut.prog_clk, 10, units="ns")
    cocotb.start_soon(prog_clock.start())

    # program bel to osc
    bel_bit_stream = 0x10000000000000001
    await cfg_bel(dut, bel_bit_stream, 65)

    await ClockCycles(dut.prog_clk, 50)

    #dut.rst.value = 1
    #clock = Clock(dut.clk, 10, units="ns")
    #cocotb.start_soon(clock.start())
    #await ClockCycles(dut.clk, 10)
    #dut.rst.value = 0
    #await ClockCycles(dut.clk, 50)
