# Makefile
# See https://docs.cocotb.org/en/stable/quickstart.html for more info

# defaults
SIM ?= icarus
TOPLEVEL_LANG ?= verilog

mkfile_path := $(abspath $(lastword $(MAKEFILE_LIST)))
mkfile_dir := $(dir $(mkfile_path))

VERILOG_SOURCES += $(mkfile_dir)../../lut.v

# TOPLEVEL is the name of the toplevel module in your Verilog or VHDL file
TOPLEVEL = lut

# MODULE is the basename of the Python test file
MODULE = lut_test

LUT_SIZE = 6
COMPILE_ARGS += -Plut.LUT_SIZE=$(LUT_SIZE)

# include cocotb's make rules to take care of the simulator setup
include $(shell cocotb-config --makefiles)/Makefile.sim