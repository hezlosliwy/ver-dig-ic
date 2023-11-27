class data_monitor extends uvm_component;
    `uvm_component_utils(data_monitor)

//------------------------------------------------------------------------------
// local variables
//------------------------------------------------------------------------------
    protected virtual vdic_dut_2023_bfm bfm;
    uvm_analysis_port #(t_data_packet) ap;

//------------------------------------------------------------------------------
// constructor
//------------------------------------------------------------------------------
    function new (string name, uvm_component parent);
        super.new(name,parent);
    endfunction

//------------------------------------------------------------------------------
// monitoring function called from BFM
//------------------------------------------------------------------------------
    function void write_to_monitor(t_data_packet packet);
        ap.write(packet);
    endfunction : write_to_monitor

//------------------------------------------------------------------------------
// build phase
//------------------------------------------------------------------------------
    function void build_phase(uvm_phase phase);

        if(!uvm_config_db #(virtual vdic_dut_2023_bfm)::get(null, "*","bfm", bfm))
            $fatal(1, "Failed to get BFM");

        bfm.data_monitor_h = this;
        ap                    = new("ap",this);
    endfunction : build_phase

endclass : data_monitor