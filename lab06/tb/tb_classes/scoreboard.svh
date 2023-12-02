class scoreboard extends uvm_subscriber #(t_s_output_vect);
	
	`uvm_component_utils(scoreboard)
	
    uvm_tlm_analysis_fifo #(t_data_packet) data_f;

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
	protected function automatic t_s_output_vect get_expected(
	        bit signed [15:0] A,
	        bit A_par,
	        bit signed [15:0] B,
	        bit B_par
		);
		t_s_output_vect exp_res;
	    dprint($sformatf("%0t DEBUG: get_expected(%0d,%0b,%0d,%0b)",$time, A, A_par, B, B_par));
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
		t_data_packet dp;
		t_s_output_vect s_result;
        t_s_output_vect expected;
		s_result = t;
        if (!data_f.try_get(dp))
            $fatal(1, "Missing data in self checker");
        expected = get_expected(dp.arg_a, dp.arg_a_parity, dp.arg_b, dp.arg_b_parity);
		assert(s_result.mult_res === expected.mult_res && s_result.result_par === expected.result_par && s_result.par_error === expected.par_error) begin
            dprint($sformatf("Test passed for A=%0d A_parity=%0b B=%0d B_parity=%0b", dp.arg_a, dp.arg_a_parity, dp.arg_b, dp.arg_b_parity));
        end
        else begin
            test_res <= FAILED;
            $error("%0t Test FAILED for A=%0d A_parity=%0b B=%0d B_parity=%0b\nExpected: (MULT_RES: %d, PAR_ERR: %b, RES_PAR %b)  received: (MR: %d, PAR_ERR: %b, RES_PAR %b)", $time, dp.arg_a, dp.arg_a_parity, dp.arg_b, dp.arg_b_parity, expected.mult_res, expected.par_error, expected.result_par, s_result.mult_res, s_result.par_error, s_result.result_par);
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