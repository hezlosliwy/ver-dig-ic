virtual class base_tpgen extends uvm_component;

	`uvm_component_utils(base_tpgen)
	
	protected virtual vdic_dut_2023_bfm bfm;
	
	function new (string name, uvm_component parent);
		super.new(name, parent);
	endfunction : new
	
	protected t_data_packet  data_pkt;
	protected bit [1:0] parity_mode;

	// Random data generation functions
	pure virtual function shortint get_data();


	function void build_phase(uvm_phase phase);
		if(!uvm_config_db #(virtual vdic_dut_2023_bfm)::get(null, "*","bfm", bfm))
		$fatal(1,"Failed to get BFM");
	endfunction : build_phase

	/* Tester */
	task run_phase(uvm_phase phase);
		phase.raise_objection(this);
		
	    bfm.rst_dut();
	    repeat (1000) begin : tester_loop
		    parity_mode = 2'($random);
	        data_pkt.arg_a = get_data();
	        data_pkt.arg_a_parity = (^data_pkt.arg_a)^parity_mode[0];
	        data_pkt.arg_b = get_data();
	        data_pkt.arg_b_parity = (^data_pkt.arg_b)^parity_mode[1];
			bfm.send2dut(data_pkt);
	    end : tester_loop
	    
	    phase.drop_objection(this);
	endtask

endclass : base_tpgen