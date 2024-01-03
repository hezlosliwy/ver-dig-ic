//----------------------------------------------------------------------
// Created by Stanislaw Klat on Wed Jan 03 20:41:39 CET 2024
//----------------------------------------------------------------------

`ifndef SK_MULT_CONFIG_OBJ_SVH
`define SK_MULT_CONFIG_OBJ_SVH

// The sk mult config object.
class sk_mult_config_obj extends uvm_object;

  // Agent id
  int unsigned m_agent_id = 0;

  // Is the agent is active or passive
  uvm_active_passive_enum m_is_active = UVM_ACTIVE;

  // Control whether checks are enabled.
  bit m_checks_enable = 1;

  // Control whether coverage is enabled.
  bit m_coverage_enable = 1;

  // HINT Here you add additional configuration parameters.

  // HINT Here you register additional configuration parameters.
  // It's very important that you use these macros on all the configuration fields that you want to propagate.
  // If you miss any field it will not be propagated correctly.
  `uvm_object_utils_begin(sk_mult_config_obj)
    `uvm_field_int(m_agent_id, UVM_DEFAULT)
    `uvm_field_enum(uvm_active_passive_enum, m_is_active, UVM_DEFAULT)
    `uvm_field_int(m_checks_enable, UVM_DEFAULT)
    `uvm_field_int(m_coverage_enable, UVM_DEFAULT)
  `uvm_object_utils_end

  function new(string name = "sk_mult_config_obj");
    super.new(name);
  endfunction: new

endclass : sk_mult_config_obj

`endif // SK_MULT_CONFIG_OBJ_SVH
