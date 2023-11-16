class random_tpgen extends base_tpgen;

	`uvm_component_utils(random_tpgen)
	
	function new (string name, uvm_component parent);
		super.new(name, parent);
	endfunction : new

	// Random data generation functions
	function shortint get_data();
	
	    bit [2:0] data_case;
	
	    data_case = 3'($random);
	
	    if (data_case == 3'b000)
	        return 16'sh0000;
	    else if (data_case == 3'b001)
	        return 16'sh8000;
	    else if (data_case == 3'b010)
		    return 16'sh7FFF;
	    else if (data_case == 3'b011)
		    return 16'shFFFF;
	    else if (data_case == 3'b100)
	        return 16'sh0001;
	    else
	        return 16'($random);
	endfunction : get_data

endclass : random_tpgen