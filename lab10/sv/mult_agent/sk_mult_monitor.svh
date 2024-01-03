//----------------------------------------------------------------------
// Created by Stanislaw Klat on Wed Jan 03 20:41:39 CET 2024
//----------------------------------------------------------------------

`ifndef SK_MULT_MONITOR_SVH
`define SK_MULT_MONITOR_SVH

// The  sk mult monitor.
class sk_mult_monitor extends uvm_monitor;

  // The virtual interface to HDL signals.
  protected virtual sk_mult_if m_mult_vif;

  // Configuration object
  protected sk_mult_config_obj m_config_obj;

  // Collected item
  protected sk_mult_item m_collected_item;

  // Collected item is broadcast on this port
  uvm_analysis_port #(sk_mult_item) m_collected_item_port;

  `uvm_component_utils(sk_mult_monitor)

  function new (string name, uvm_component parent);
    super.new(name, parent);

    // Allocate collected_item.
    m_collected_item = sk_mult_item::type_id::create("m_collected_item", this);

    // Allocate collected_item_port.
    m_collected_item_port = new("m_collected_item_port", this);
  endfunction : new

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    // Get the virtual interface.
    if(!uvm_config_db#(virtual sk_mult_if)::get(this, "", "m_mult_vif", m_mult_vif))
      `uvm_fatal("NOVIF", {"Virtual interface must be set for: ", get_full_name(), ".m_mult_vif"})

    // Get the configuration object
    if(!uvm_config_db#(sk_mult_config_obj)::get(this, "", "m_config_obj", m_config_obj))
      `uvm_fatal("NOCONFIG", {"Config object must be set for: ", get_full_name(), ".m_config_obj"})
  endfunction : build_phase

  virtual task run_phase(uvm_phase phase);
    process main_thread; // main thread
    process rst_mon_thread; // reset monitor thread

    // Start monitoring only after an initial reset pulse
    @(negedge m_mult_vif.reset)
      do @(posedge m_mult_vif.clock);
      while(m_mult_vif.reset!==1);

    // Start monitoring
    forever begin
      fork
        // Start the monitoring thread
        begin
          main_thread=process::self();
          collect_items();
        end
        // Monitor the reset signal
        begin
          rst_mon_thread = process::self();
          @(negedge m_mult_vif.reset) begin
            // Interrupt current item at reset
            if(main_thread) main_thread.kill();
            // Do reset
            reset_monitor();
          end
        end
      join_any

      if (rst_mon_thread) rst_mon_thread.kill();
    end
  endtask : run_phase

  // Collects items.
  virtual protected task collect_items();
    forever begin
      collect_item();

      `uvm_info(get_type_name(), $sformatf("Collected :\n%s", m_collected_item.sprint()), UVM_FULL)

      m_collected_item_port.write(m_collected_item);

      if(m_config_obj.m_checks_enable)
        perform_item_checks();
    end
  endtask : collect_items

  // Collects an item.
  virtual protected task collect_item();
    // XXX sk_mult_monitor: Implement collect_item()
    // For example:
    void'(this.begin_tr(m_collected_item));
    while (m_mult_vif.req !== 1'b1) @(posedge m_mult_vif.clock);
	m_collected_item.a = m_mult_vif.arg_a;
	m_collected_item.a_parity = m_mult_vif.arg_a_parity;
	m_collected_item.b = m_mult_vif.arg_b;
	m_collected_item.b_parity = m_mult_vif.arg_b_parity;
    while (m_mult_vif.req !== 1'b0) @(posedge m_mult_vif.clock);
    this.end_tr(m_collected_item);
  endtask : collect_item

  // Performs item checks.
  virtual protected function void perform_item_checks();
  // TODO sk_mult_monitor: Implement perform_item_checks()
  endfunction : perform_item_checks

  // Resets monitor.
  virtual protected function void reset_monitor();
  // HINT Here you reset monitor specific state variables (e.g. counters, flags, buffers, queues, etc.).
  endfunction : reset_monitor

endclass : sk_mult_monitor

`endif // SK_MULT_MONITOR_SVH
