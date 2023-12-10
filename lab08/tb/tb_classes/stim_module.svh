class stim_module;

	protected virtual vdic_dut_2023_bfm bfm;
	
	function new (virtual vdic_dut_2023_bfm b);
        bfm = b;
	endfunction : new
	
	protected random_command data_pkt;
	protected bit [1:0] parity_mode;

	// Random data generation functions
	protected function shortint get_data();
	
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

	/* Tester */
	task execute();
	    bfm.rst_dut();
	    repeat (1000) begin : tester_loop
		    data_pkt = new("data_pkt");
		    parity_mode = 2'($random);
	        data_pkt.a = get_data();
	        data_pkt.a_parity = (^data_pkt.a)^parity_mode[0];
	        data_pkt.b = get_data();
	        data_pkt.b_parity = (^data_pkt.b)^parity_mode[1];
			bfm.send2dut(data_pkt);
	    end : tester_loop
	endtask

endclass