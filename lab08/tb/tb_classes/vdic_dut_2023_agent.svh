class vdic_dut_2023_agent extends uvm_agent;
    `uvm_component_utils(vdic_dut_2023_agent)
    
    vdic_dut_2023_agent_config agent_config_h;
    
	tpgen tpgen_h;
	uvm_tlm_fifo #(random_command) data_f;
	driver driver_h;

	coverage coverage_h;
	scoreboard scoreboard_h;
	data_monitor data_monitor_h;
	result_monitor result_monitor_h;

    function new (string name, uvm_component parent);
        super.new(name,parent);
    endfunction : new
   	
    function void build_phase(uvm_phase phase);
	    
        if(!uvm_config_db #(vdic_dut_2023_agent_config)::get(this, "","config", agent_config_h))
            `uvm_fatal("AGENT", "Failed to get config object");
	    
        if (agent_config_h.get_is_active() == UVM_ACTIVE) begin : make_stimulus
            data_f   = new("data_f", this);
            tpgen_h  = tpgen::type_id::create( "tpgen_h",this);
            driver_h = driver::type_id::create("driver_h",this);
        end
        coverage_h        = coverage::type_id::create ("coverage_h",this);
        scoreboard_h      = scoreboard::type_id::create("scoreboard_h",this);
        data_monitor_h    = data_monitor::type_id::create("data_monitor_h",this);
        result_monitor_h  = result_monitor::type_id::create("result_monitor_h",this);
    endfunction : build_phase
    
    function void connect_phase(uvm_phase phase);
        if (agent_config_h.get_is_active() == UVM_ACTIVE) begin
	        driver_h.data_port.connect(data_f.get_export);
	        tpgen_h.data_port.connect(data_f.put_export);
        end
        
        data_monitor_h.ap.connect(coverage_h.analysis_export);
        data_monitor_h.ap.connect(scoreboard_h.data_f.analysis_export);
        result_monitor_h.ap.connect(scoreboard_h.analysis_export);
    endfunction : connect_phase
    
endclass : vdic_dut_2023_agent