//----------------------------------------------------------------------
// Created by Stanislaw Klat on Wed Jan 03 20:41:39 CET 2024
//----------------------------------------------------------------------

`ifndef SK_MULT_AGENT_SVH
`define SK_MULT_AGENT_SVH

// The sk mult agent.
class sk_mult_agent extends uvm_agent;

  // Configuration object
  protected sk_mult_config_obj m_config_obj;

  `uvm_component_utils(sk_mult_agent)

  sk_mult_driver m_driver;
  sk_mult_sequencer m_sequencer;
  sk_mult_monitor m_monitor;
  sk_mult_coverage_collector m_coverage_collector;

  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    // Get the configuration object
    if(!uvm_config_db#(sk_mult_config_obj)::get(this, "", "m_config_obj", m_config_obj))
      `uvm_fatal("NOCONFIG", {"Config object must be set for: ", get_full_name(), ".m_config_obj"})

    // Propagate the configuration object to monitor
    uvm_config_db#(sk_mult_config_obj)::set(this, "m_monitor", "m_config_obj", m_config_obj);
    // Create the monitor
    m_monitor = sk_mult_monitor::type_id::create("m_monitor", this);

    if(m_config_obj.m_coverage_enable) begin
      m_coverage_collector = sk_mult_coverage_collector::type_id::create("m_coverage_collector", this);
    end

    if(m_config_obj.m_is_active == UVM_ACTIVE) begin
      // Propagate the configuration object to driver
      uvm_config_db#(sk_mult_config_obj)::set(this, "m_driver", "m_config_obj", m_config_obj);
      // Create the driver
      m_driver = sk_mult_driver::type_id::create("m_driver", this);
      
      // Create the sequencer
      m_sequencer = sk_mult_sequencer::type_id::create("m_sequencer", this);
    end
  endfunction : build_phase

  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);

    if(m_config_obj.m_coverage_enable) begin
      m_monitor.m_collected_item_port.connect(m_coverage_collector.m_monitor_port);
    end

    if(m_config_obj.m_is_active == UVM_ACTIVE) begin
      m_driver.seq_item_port.connect(m_sequencer.seq_item_export);
    end
  endfunction : connect_phase

endclass : sk_mult_agent

`endif // SK_MULT_AGENT_SVH
