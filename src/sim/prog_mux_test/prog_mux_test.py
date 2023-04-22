import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge, FallingEdge, Timer, ClockCycles
from scipy.fft import fft
import numpy as np
from random import getrandbits
from cocotb.regression import TestFactory

async def cfg_prog_mux(dut, sel, sel_width):
    await RisingEdge(dut.prog_clk)
    dut.prog_en.value = 1
    for i in range(sel_width, 0, -1):
        dut.prog_in.value = (sel >> (i - 1)) & 0x1
        await RisingEdge(dut.prog_clk)
    dut.prog_en.value = 0
    await RisingEdge(dut.prog_clk)

@cocotb.test()
async def prog_mux_test(dut):
    dut._log.info("start")

    mux_inputs = dut.INPUTS.value
    sel_width = dut.SEL_WIDTH.value

    dut._log.info(f"Mux inputs = {mux_inputs}")
    dut._log.info(f"Mux Sel Width = {sel_width}")

    clock = Clock(dut.prog_clk, 10, units="ns")
    cocotb.start_soon(clock.start())

    # Test that the correct signals are mux'd
    mux_input = getrandbits(mux_inputs)
    dut.mux_in.value = mux_input
    for i in range(mux_inputs):
        await cfg_prog_mux(dut, i, sel_width)
        expected = (mux_input >> i) & 0x1
        actual = dut.mux_out.value
        print(f"actual {actual} expected {expected}")
        assert(actual == expected)

    await ClockCycles(dut.prog_clk, 10)
