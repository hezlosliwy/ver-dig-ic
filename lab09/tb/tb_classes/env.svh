class env extends uvm_env;
	`uvm_component_utils(env)
	

	sequencer sequencer_h;
	coverage coverage_h;
	scoreboard scoreboard_h;
	driver driver_h;
	data_monitor data_monitor_h;
	result_monitor result_monitor_h;
	
    function new (string name, uvm_component parent);
        super.new(name,parent);
    endfunction : new

    function void build_phase(uvm_phase phase);
	    sequencer_h		  = sequencer::type_id::create("sequencer_h", this);
        driver_h          = driver::type_id::create("drive_h",this);

        coverage_h        = coverage::type_id::create ("coverage_h",this);
        scoreboard_h      = scoreboard::type_id::create("scoreboard_h",this);

        data_monitor_h    = data_monitor::type_id::create("data_monitor_h",this);
        result_monitor_h  = result_monitor::type_id::create("result_monitor_h",this);
    endfunction : build_phase


    function void connect_phase(uvm_phase phase);
        driver_h.seq_item_port.connect(sequencer_h.seq_item_export);

        data_monitor_h.ap.connect(coverage_h.analysis_export);
        data_monitor_h.ap.connect(scoreboard_h.data_f.analysis_export);
        result_monitor_h.ap.connect(scoreboard_h.analysis_export);
    endfunction : connect_phase

    function void end_of_elaboration_phase(uvm_phase phase);
        super.end_of_elaboration_phase(phase);
    endfunction : end_of_elaboration_phase

endclass : env