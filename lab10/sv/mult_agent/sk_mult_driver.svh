//----------------------------------------------------------------------
// Created by Stanislaw Klat on Wed Jan 03 20:41:39 CET 2024
//----------------------------------------------------------------------

`ifndef SK_MULT_DRIVER_SVH
`define SK_MULT_DRIVER_SVH

// The  sk mult driver.
class sk_mult_driver extends uvm_driver#(sk_mult_item);

  // The virtual interface to HDL signals.
  protected virtual sk_mult_if m_mult_vif;

  // Configuration object
  protected sk_mult_config_obj m_config_obj;

  `uvm_component_utils(sk_mult_driver)

  function new (string name, uvm_component parent);
    super.new(name, parent);
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
    // Driving should be triggered by an initial reset pulse
    @(negedge m_mult_vif.reset)
      do @(posedge m_mult_vif.clock);
      while(m_mult_vif.reset!==1);

    // Start driving
    get_and_drive();
  endtask : run_phase

  // Drives items.
  virtual protected task get_and_drive();
    process main_thread; // main thread
    process rst_mon_thread; // reset monitor thread

    forever begin
      // Don't drive during reset
      while(m_mult_vif.reset!==1) @(posedge m_mult_vif.clock);

      // Get the next item from the sequencer
      seq_item_port.get_next_item(req);
      $cast(rsp, req.clone());
      rsp.set_id_info(req);

      // Drive current item
      fork
        // Drive the item
        begin
          main_thread=process::self();
          `uvm_info(get_type_name(), $sformatf("sk mult %0d start driving item :\n%s", m_config_obj.m_agent_id, rsp.sprint()), UVM_HIGH)
          drive_item(rsp);
          `uvm_info(get_type_name(), $sformatf("sk mult %0d done driving item :\n%s", m_config_obj.m_agent_id, rsp.sprint()), UVM_HIGH)

          if(rst_mon_thread) rst_mon_thread.kill();
        end
        // Monitor the reset signal
        begin
          rst_mon_thread = process::self();
          @(negedge m_mult_vif.reset) begin
            // Interrupt current item at reset
            if(main_thread) main_thread.kill();
            // Do reset
            reset_signals();
            reset_driver();
          end
        end
      join_any

      // Send item_done and a response to the sequencer
      seq_item_port.item_done();
      // HINT Here you should set a field in the rsp item to indicate the current item was interrupted by reset.
      seq_item_port.put_response(rsp);
    end
  endtask : get_and_drive

  // Resets signals.
  virtual protected task reset_signals();
    // TODO  sk_mult_driver: Implement reset_signals()
    //
    // For example:
    m_mult_vif.data <= 'hz;
  endtask : reset_signals

  // Resets driver.
  virtual protected task reset_driver();
  // HINT Here you reset driver specific state variables (e.g. counters, flags, buffers, queues, etc.).
  endtask : reset_driver

  // Drives item.
  virtual protected task drive_item (sk_mult_item item);
    // TODO sk_mult_driver: Implement drive_item()
    // For example:
    m_mult_vif.data <= item.m_data;
    @(posedge m_mult_vif.clock);
  endtask : drive_item

endclass : sk_mult_driver

`endif // SK_MULT_DRIVER_SVH
