package vdic_dut_2023_pkg;

import uvm_pkg::*;
`include "uvm_macros.svh"

import misc_pkg::*;
`include "random_command.svh"
`include "random_sequence_item.svh"
//`include "minmax_sequence_item.svh"
`include "random_sequence.svh"
`include "minmax_sequence.svh"
`include "zerorand_sequence.svh"

typedef uvm_sequencer #(random_sequence_item) sequencer;

`include "result_transaction.svh"
`include "coverage.svh"
`include "scoreboard.svh"
`include "driver.svh"
`include "data_monitor.svh"
`include "result_monitor.svh"
`include "env.svh"
`include "base_test.svh"
`include "random_test.svh"
`include "min_max_test.svh"
`include "zerorand_test.svh"


endpackage