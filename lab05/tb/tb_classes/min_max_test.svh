class min_max_test extends random_test;
	`uvm_component_utils(min_max_test)
	
    function new(string name, uvm_component parent);
		super.new(name, parent);
	endfunction : new
	
	function void build_phase(uvm_phase phase);

		super.build_phase(phase);
		
		// set the factory to produce a add_tpgen whenever it would produce
		// a random_tpgen
		 
		random_tpgen::type_id::set_type_override(min_max_tpgen::get_type());
		
	endfunction : build_phase

endclass : min_max_test