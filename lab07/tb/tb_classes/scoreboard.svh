class scoreboard extends uvm_subscriber #(result_transaction);
	
	`uvm_component_utils(scoreboard)
	
    uvm_tlm_analysis_fifo #(random_command) data_f;

	protected typedef enum bit {
	    PASSED,
	    FAILED
	} test_res_t;

	protected test_res_t test_res = PASSED;

    function new (string name, uvm_component parent);
		super.new(name, parent);
    endfunction : new
    
	function void build_phase(uvm_phase phase);
        data_f = new ("data_f", this);
	endfunction : build_phase

	// calculate expected result
	protected function automatic result_transaction get_expected(
	        bit signed [15:0] A,
	        bit A_par,
	        bit signed [15:0] B,
	        bit B_par
		);
		result_transaction exp_res = new("exp_res");
		if((^A == A_par) && (^B == B_par)) begin
			exp_res.par_error = 1'b0;
		    exp_res.mult_res = A*B;
		end
		else begin
			exp_res.par_error = 1'b1;
		    exp_res.mult_res = 0;
		end
		exp_res.result_par = ^exp_res.mult_res;
		return exp_res;
	endfunction : get_expected

	function void write(T t);
		random_command dp;
		result_transaction s_result;
        result_transaction expected;
		dp = new("dp");
		s_result = t;
        if (!data_f.try_get(dp))
            `uvm_fatal("SCOREBOARD", "Missing data in self checker")
        expected = get_expected(dp.a, dp.a_parity, dp.b, dp.b_parity);
		assert(s_result.compare(expected)) begin
            `uvm_info("SCOREBOARD", $sformatf("Test passed for %s", dp.convert2string()), UVM_FULL)
        end
        else begin
            test_res <= FAILED;
            `uvm_error("SCOREBOARD",$sformatf("%0t Test FAILED for %s\nExpected: %s received: %s", $time, dp.convert2string(), expected.convert2string(), s_result.convert2string()))
        end
	endfunction
	
	protected function void print_test_res (test_res_t res);
	    					$display ("|---------------------------------|");
	    if(res == PASSED)   $display ("|           Test PASSED           |");
	    else                $display ("|           Test FAILED           |");
	    					$display ("|---------------------------------|");
	endfunction

	// show test result
	function void report_phase(uvm_phase phase);
        super.report_phase(phase);
	    print_test_res(test_res);
	endfunction

endclass