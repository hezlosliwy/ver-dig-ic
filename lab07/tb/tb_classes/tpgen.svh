class tpgen extends uvm_component;
    `uvm_component_utils (tpgen)
	
    uvm_put_port #(random_command) data_port;
	
	function new (string name, uvm_component parent);
		super.new(name, parent);
	endfunction : new
	
	protected bit [1:0] parity_mode;

	function void build_phase(uvm_phase phase);
        data_port = new("data_port", this);
	endfunction : build_phase

	/* Tester */
	task run_phase(uvm_phase phase);
		random_command  random_data;
	    
		phase.raise_objection(this);
		
		random_data = random_command::type_id::create("random_data");
		repeat (1000) begin : tester_loop
			assert(random_data.randomize());
		    parity_mode = 2'($random);
			data_port.put(random_data);
	    end : tester_loop
	    #500;
	    phase.drop_objection(this);
	endtask

endclass : tpgen