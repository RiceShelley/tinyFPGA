import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge, FallingEdge, Timer, ClockCycles
from scipy.fft import fft
import numpy as np
from random import getrandbits
from cocotb.regression import TestFactory

async def test_lut(dut, lut_cfg, lut_size):
    dut.prog_en.value = 0

    clock = Clock(dut.prog_clk, 10, units="ns")
    cocotb.start_soon(clock.start())

    prog_bits = 2 ** lut_size

    # program LUT
    await RisingEdge(dut.prog_clk)
    dut.prog_en.value = 1
    for i in range(prog_bits, 0, -1):
        dut.prog_in.value = (lut_cfg >> (i - 1)) & 0x1
        await RisingEdge(dut.prog_clk)
    dut.prog_en.value = 0

    # Test That LUT has correct config
    for i in range(prog_bits):
        dut.lut_in.value = i
        await Timer(5, 'ns')
        expected = (lut_cfg >> i) & 0x1
        actual = dut.lut_out.value
        assert(expected == actual)

    # Test that LUT cfg is shifted out correctly
    await FallingEdge(dut.prog_clk)
    dut.prog_in.value = 0
    dut.prog_en.value = 1
    for i in range(prog_bits, 0, -1):
        actual = dut.prog_out.value
        expected = (lut_cfg >> (i - 1)) & 0x1
        assert(actual == expected)
        await FallingEdge(dut.prog_clk)
    dut.prog_en.value = 0

    await ClockCycles(dut.prog_clk, 10)

@cocotb.test()
async def lut_test(dut):
    dut._log.info("start")
    lut_size = dut.LUT_SIZE.value
    dut._log.info(f"LUT SIZE = {lut_size}")
    for i in range(0, 50):
        await test_lut(dut, getrandbits(2 ** lut_size), lut_size)
