class result_monitor extends uvm_component;
    `uvm_component_utils(result_monitor)

    protected virtual vdic_dut_2023_bfm bfm;
    uvm_analysis_port #(result_transaction) ap;

    function new (string name, uvm_component parent);
        super.new(name, parent);
    endfunction : new

//------------------------------------------------------------------------------
// monitoring function called from BFM
//------------------------------------------------------------------------------
    function void write_to_monitor(result_transaction r);
        ap.write(r);
    endfunction : write_to_monitor

//------------------------------------------------------------------------------
// build phase
//------------------------------------------------------------------------------
    function void build_phase(uvm_phase phase);
	    vdic_dut_2023_agent_config vdic_dut_2023_agent_config_h;

        if(!uvm_config_db #(vdic_dut_2023_agent_config)::get(this, "","config", vdic_dut_2023_agent_config_h))
            `uvm_fatal("DRIVER", "Failed to get config");
        
        vdic_dut_2023_agent_config_h.bfm.result_monitor_h = this;
        
        ap                   = new("ap",this);
    endfunction : build_phase



endclass : result_monitor