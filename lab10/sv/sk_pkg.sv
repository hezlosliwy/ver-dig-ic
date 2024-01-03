//----------------------------------------------------------------------
// Created by Stanislaw Klat on Wed Jan 03 20:41:39 CET 2024
//----------------------------------------------------------------------


// HINT Here you include agent interfaces.
`include "mult_agent/sk_mult_if.sv"

package sk_pkg;

  // HINT Here you update the version.
  `define sk_VERSION "1.0"

  `include "uvm_macros.svh"
  import uvm_pkg::*;

  // HINT Here you include agents.

  // Include the mult agent.
  `include "mult_agent/sk_mult_config_obj.svh"
  `include "mult_agent/sk_mult_item.svh"
  `include "mult_agent/sk_mult_monitor.svh"
  `include "mult_agent/sk_mult_coverage_collector.svh"
  `include "mult_agent/sk_mult_sequencer.svh"
  `include "mult_agent/sk_mult_driver.svh"
  `include "mult_agent/sk_mult_agent.svh"
  `include "mult_agent/sk_mult_seq_lib.svh"

  `include "sk_env.svh"

endpackage : sk_pkg
