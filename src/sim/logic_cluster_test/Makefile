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
$(mkfile_dir)../../logic_cluster.v \
$(mkfile_dir)logic_cluster_tb.v

# TOPLEVEL is the name of the toplevel module in your Verilog or VHDL file
TOPLEVEL = logic_cluster_tb

# MODULE is the basename of the Python test file
MODULE = logic_cluster_test

BEL_INPUT_WIDTH = 6
BELS = 5
CLUSTER_INPUT_WIDTH = 5

COMPILE_ARGS += -Plogic_cluster.BEL_INPUT_WIDTH=$(BEL_INPUT_WIDTH) \
-Plogic_cluster.BELS=$(BELS) \
-Plogic_cluster.CLUSTER_INPUT_WIDTH=$(CLUSTER_INPUT_WIDTH)

# include cocotb's make rules to take care of the simulator setup
include $(shell cocotb-config --makefiles)/Makefile.sim