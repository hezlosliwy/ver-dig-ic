class env extends uvm_env;
	`uvm_component_utils(env)
	
	random_tpgen tpgen_h;
	uvm_tlm_fifo #(t_data_packet) data_f;
	driver driver_h;

	coverage coverage_h;
	scoreboard scoreboard_h;
	data_monitor data_monitor_h;
	result_monitor result_monitor_h;
	
    function new (string name, uvm_component parent);
        super.new(name,parent);
    endfunction : new


    function void build_phase(uvm_phase phase);
        tpgen_h           = random_tpgen::type_id::create("random_tpgen",this);
        data_f            = new("data_f", this);
        driver_h          = driver::type_id::create("drive_h",this);
        coverage_h        = coverage::type_id::create ("coverage_h",this);
        scoreboard_h      = scoreboard::type_id::create("scoreboard_h",this);
        data_monitor_h    = data_monitor::type_id::create("data_monitor_h",this);
        result_monitor_h  = result_monitor::type_id::create("result_monitor_h",this);
    endfunction : build_phase


    function void connect_phase(uvm_phase phase);
        driver_h.data_port.connect(data_f.get_export);
        tpgen_h.data_port.connect(data_f.put_export);
        data_monitor_h.ap.connect(coverage_h.analysis_export);
        data_monitor_h.ap.connect(scoreboard_h.data_f.analysis_export);
        result_monitor_h.ap.connect(scoreboard_h.analysis_export);
    endfunction : connect_phase

    function void end_of_elaboration_phase(uvm_phase phase);
        super.end_of_elaboration_phase(phase);
        $write("*** Created tpgen type: %s\n", tpgen_h.get_type_name());
    endfunction : end_of_elaboration_phase

endclass : env