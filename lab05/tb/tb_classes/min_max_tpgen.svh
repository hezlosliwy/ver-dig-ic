class min_max_tpgen extends random_tpgen;

	`uvm_component_utils(min_max_tpgen)
	
	function new (string name, uvm_component parent);
		super.new(name, parent);
	endfunction : new
	
	// Random data generation functions
	function shortint get_data();
	
	    bit [1:0] data_case;
	
	    data_case = 2'($random);
	
	    if (data_case == 2'b00)
	        return 16'sh0001;
	    else if (data_case == 2'b01)
	        return 16'sh8000;
	    else if (data_case == 2'b10)
		    return 16'sh7FFF;
	    else
		    return 16'shFFFF;
	endfunction : get_data

endclass