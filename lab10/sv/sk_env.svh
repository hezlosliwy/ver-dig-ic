//----------------------------------------------------------------------
// Created by Stanislaw Klat on Wed Jan 03 20:41:39 CET 2024
//----------------------------------------------------------------------

`ifndef SK_MULT_ENV_SVH
`define SK_MULT_ENV_SVH

// The sk env.
class sk_env extends uvm_env;

  `uvm_component_utils(sk_env)

  // HINT Here you instantiate your agents.
  sk_mult_agent m_mult_agent;

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    // HINT Here you create the agents.
    begin
      // Create the configuration object if it has not been set
      sk_mult_config_obj config_obj;
      if(!uvm_config_db#(sk_mult_config_obj)::get(this, "", "m_config_obj", config_obj)) begin
        config_obj = sk_mult_config_obj::type_id::create("m_config_obj", this);
        uvm_config_db#(sk_mult_config_obj)::set(this, {"m_mult_agent","*"}, "m_config_obj", config_obj);
      end

      // Create the agent
      m_mult_agent = sk_mult_agent::type_id::create("m_mult_agent", this);
    end
  endfunction : build_phase

endclass : sk_env

`endif // SK_MULT_ENV_SVH
