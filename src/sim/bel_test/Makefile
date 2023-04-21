# Makefile
# See https://docs.cocotb.org/en/stable/quickstart.html for more info

# defaults
SIM ?= icarus
TOPLEVEL_LANG ?= verilog

mkfile_path := $(abspath $(lastword $(MAKEFILE_LIST)))
mkfile_dir := $(dir $(mkfile_path))

VERILOG_SOURCES += $(mkfile_dir)../../lut.v \
$(mkfile_dir)../../prog_mux.v \
$(mkfile_dir)../../bel.v \
$(mkfile_dir)bel_tb.v

# TOPLEVEL is the name of the toplevel module in your Verilog or VHDL file
TOPLEVEL = bel_tb

# MODULE is the basename of the Python test file
MODULE = bel_test

INPUT_WIDTH = 6
COMPILE_ARGS += -Pbel_tb.INPUT_WIDTH=$(INPUT_WIDTH)

# include cocotb's make rules to take care of the simulator setup
include $(shell cocotb-config --makefiles)/Makefile.sim