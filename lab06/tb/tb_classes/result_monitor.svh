class result_monitor extends uvm_component;
    `uvm_component_utils(result_monitor)

    protected virtual vdic_dut_2023_bfm bfm;
    uvm_analysis_port #(t_s_output_vect) ap;

    function new (string name, uvm_component parent);
        super.new(name, parent);
    endfunction : new

//------------------------------------------------------------------------------
// monitoring function called from BFM
//------------------------------------------------------------------------------
    function void write_to_monitor(t_s_output_vect r);
        ap.write(r);
    endfunction : write_to_monitor

//------------------------------------------------------------------------------
// build phase
//------------------------------------------------------------------------------
    function void build_phase(uvm_phase phase);
        if(!uvm_config_db #(virtual vdic_dut_2023_bfm)::get(null, "*","bfm", bfm))
            $fatal(1, "Failed to get BFM");
        bfm.result_monitor_h = this;
        ap                   = new("ap",this);
    endfunction : build_phase



endclass : result_monitor