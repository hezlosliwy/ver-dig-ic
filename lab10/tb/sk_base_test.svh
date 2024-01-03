//----------------------------------------------------------------------
// Created by Stanislaw Klat on Wed Jan 03 20:41:39 CET 2024
//----------------------------------------------------------------------

`ifndef SK_BASE_TEST_SVH
`define SK_BASE_TEST_SVH

// The base sk base test. All children tests inherit this behavior.
// It creates the testbench.
// It configures the printer and verbosity.
// It performs some final reporting.
class sk_base_test extends uvm_test;

  `uvm_component_utils(sk_base_test)

  // The sk environment
  sk_env m_env;

  // Indicates pass/fail.
  bit test_pass = 1;

  uvm_table_printer printer;

  function new(string name = "sk_base_test", uvm_component parent=null);
    super.new(name,parent);
  endfunction : new

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    // Create the sk env.
    m_env = sk_env::type_id::create("m_env", this);

    // Create a specific depth printer for printing the created topology
    printer = new();
    printer.knobs.depth = 3;
  endfunction : build_phase

  virtual function void end_of_elaboration_phase(uvm_phase phase);
    // Print the test topology
    `uvm_info(get_type_name(), $sformatf("Printing the test topology :\n%s", this.sprint(printer)), UVM_LOW)
  endfunction : end_of_elaboration_phase

  virtual task run_phase(uvm_phase phase);
    super.run_phase(phase);
  // HINT Here you can set the drain-time if desired
  // phase.phase_done.set_drain_time(this, 10);
  endtask : run_phase

  virtual function void report_phase(uvm_phase phase);
    if(test_pass) begin
      `uvm_info(get_type_name(), "** UVM TEST PASSED **", UVM_NONE)
    end
    else begin
      `uvm_error(get_type_name(), "** UVM TEST FAIL **")
    end
  endfunction : report_phase

endclass : sk_base_test

`endif // SK_BASE_TEST_SVH
