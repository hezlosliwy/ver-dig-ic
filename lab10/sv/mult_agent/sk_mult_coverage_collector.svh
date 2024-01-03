//----------------------------------------------------------------------
// Created by Stanislaw Klat on Wed Jan 03 20:41:39 CET 2024
//----------------------------------------------------------------------

`ifndef SK_MULT_COVERAGE_COLLECTOR_SVH
`define SK_MULT_COVERAGE_COLLECTOR_SVH

// The sk mult coverage collector.
class sk_mult_coverage_collector extends uvm_component;

  // Configuration object
  protected sk_mult_config_obj m_config_obj;

  // Item collected from the monitor
  protected sk_mult_item m_collected_item;

  // Using suffix to handle more ports
  `uvm_analysis_imp_decl(_collected_item)

  // Connection to the monitor
  uvm_analysis_imp_collected_item#(sk_mult_item, sk_mult_coverage_collector) m_monitor_port;

  `uvm_component_utils(sk_mult_coverage_collector)

  // Covergroup
  covergroup item_cg;
    option.per_instance = 1;
  // TODO sk_mult_coverage_collector: Add coverpoints
  endgroup : item_cg

  function new(string name, uvm_component parent);
    super.new(name, parent);
    item_cg = new;
    item_cg.set_inst_name({get_full_name(), ".item_cg"});
  endfunction : new

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    m_monitor_port = new("m_monitor_port",this);

    // Get the configuration object
    if(!uvm_config_db#(sk_mult_config_obj)::get(this, "", "m_config_obj", m_config_obj))
      `uvm_fatal("NOCONFIG", {"Config object must be set for: ", get_full_name(), ".m_config_obj"})
  endfunction : build_phase

  function void write_collected_item(sk_mult_item item);
    m_collected_item = item;
    item_cg.sample();
  endfunction : write_collected_item

endclass : sk_mult_coverage_collector

`endif // SK_MULT_COVERAGE_COLLECTOR_SVH
