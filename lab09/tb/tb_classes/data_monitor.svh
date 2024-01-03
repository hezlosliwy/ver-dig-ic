class data_monitor extends uvm_component;
    `uvm_component_utils(data_monitor)

//------------------------------------------------------------------------------
// local variables
//------------------------------------------------------------------------------
    protected virtual vdic_dut_2023_bfm bfm;
    uvm_analysis_port #(random_command) ap;

//------------------------------------------------------------------------------
// constructor
//------------------------------------------------------------------------------
    function new (string name, uvm_component parent);
        super.new(name,parent);
    endfunction

//------------------------------------------------------------------------------
// monitoring function called from BFM
//------------------------------------------------------------------------------
    function void write_to_monitor(random_command packet);
	    random_command data2send;
	    data2send = new("data2send");
	    data2send.copy(packet);
        ap.write(data2send);
    endfunction : write_to_monitor

//------------------------------------------------------------------------------
// build phase
//------------------------------------------------------------------------------
    function void build_phase(uvm_phase phase);

        if(!uvm_config_db #(virtual vdic_dut_2023_bfm)::get(null, "*","bfm", bfm))
            `uvm_fatal("DATA Monitor", "Failed to get BFM")

        bfm.data_monitor_h = this;
        ap = new("ap",this);
    endfunction : build_phase

endclass : data_monitor