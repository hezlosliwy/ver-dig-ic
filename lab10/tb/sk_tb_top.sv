//----------------------------------------------------------------------
// Created by Stanislaw Klat on Wed Jan 03 20:41:39 CET 2024
//----------------------------------------------------------------------

`include "dut.v"
`include "sk_pkg.sv"
`include "sk_test_pkg.sv"

// The testbench top.
module sk_tb_top;
  import uvm_pkg::*;
  import sk_pkg::*;
  import sk_test_pkg::*;

  reg clock;
  reg reset;

  // HINT Here you instantiate agent interfaces.
  sk_mult_if mult_vif(.clock(clock), .reset(reset));

  // TODO sk_tb_top: Instantiate the dut
  // For example:
  dut my_dut(
    .clock(clock),
    .reset(reset),
    // HINT Here you connect dut signals to agent interfaces.
    //
    // For example:
    .data(mult_vif.data)
  );

  initial begin
    // Propagate the interface to all the components that need it
    uvm_config_db#(virtual sk_mult_if)::set(uvm_root::get(), "*", "m_mult_vif", mult_vif);
    // Start the test
    run_test();
  end

  // Initial Reset
  initial begin
    reset <= 1'b1;
    clock <= 1'b1;
    #21 reset <= 1'b0;
    #51 reset <= 1'b1;
  end

  // Generate Clock
  always
    #5 clock <= ~clock;

endmodule : sk_tb_top
