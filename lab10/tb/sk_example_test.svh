//----------------------------------------------------------------------
// Created by Stanislaw Klat on Wed Jan 03 20:41:39 CET 2024
//----------------------------------------------------------------------

`ifndef SK_EXAMPLE_TEST_SVH
`define SK_EXAMPLE_TEST_SVH

// TODO sk_example_test: Define test
// For example:
class sk_example_test extends sk_base_test;

  `uvm_component_utils(sk_example_test)

  function new(string name = "sk_example_test", uvm_component parent=null);
    super.new(name,parent);
  endfunction : new

  virtual function void build_phase(uvm_phase phase);
    begin
      uvm_config_db#(uvm_object_wrapper)::set(this,
        "m_env.m_mult_agent.m_sequencer.run_phase",
        "default_sequence",
        sk_mult_example_seq::type_id::get());

      // Create the env
      super.build_phase(phase);
    end
  endfunction : build_phase

endclass : sk_example_test

`endif // SK_EXAMPLE_TEST_SVH
