# Makefile
# See https://docs.cocotb.org/en/stable/quickstart.html for more info

# defaults
SIM ?= icarus
TOPLEVEL_LANG ?= verilog

mkfile_path := $(abspath $(lastword $(MAKEFILE_LIST)))
mkfile_dir := $(dir $(mkfile_path))

VERILOG_SOURCES += $(mkfile_dir)../../prog_mux.v

# TOPLEVEL is the name of the toplevel module in your Verilog or VHDL file
TOPLEVEL = prog_mux

# MODULE is the basename of the Python test file
MODULE = prog_mux_test

INPUTS = 16
COMPILE_ARGS += -Pprog_mux.INPUTS=$(INPUTS)

# include cocotb's make rules to take care of the simulator setup
include $(shell cocotb-config --makefiles)/Makefile.sim