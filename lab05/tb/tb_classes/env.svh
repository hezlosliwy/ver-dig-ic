class env extends uvm_env;
	`uvm_component_utils(env)
	
	random_tpgen tpgen_h;
	coverage coverage_h;
	scoreboard scoreboard_h;
	
	function new(string name, uvm_component parent);
	 	super.new(name, parent);
	endfunction : new


	function void build_phase(uvm_phase phase);
		tpgen_h = random_tpgen::type_id::create("tpgen_h", this);
		coverage_h = coverage::type_id::create("coverage_h", this);
		scoreboard_h = scoreboard::type_id::create("scoreboard_h", this);
	endfunction : build_phase

endclass : env