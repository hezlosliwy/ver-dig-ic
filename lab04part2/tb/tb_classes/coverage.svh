class coverage;
	
	//auxiliary variables
	protected bit arg_a_par_correct;
	protected bit arg_b_par_correct;
	
	protected bit signed   [15:0]  arg_a;
	protected bit                  arg_a_parity;
	protected bit signed   [15:0]  arg_b;
	protected bit                  arg_b_parity;
		
	protected virtual vdic_dut_2023_bfm bfm;
	
	covergroup cg_parities;

	    option.name = "i_cg_parities";
		
		a_correct : coverpoint arg_a_par_correct {
			bins correct = { 1 };	
			bins incorrect = { 0 };
		}
	
		b_correct : coverpoint arg_b_par_correct {
			bins correct = { 1 };	
			bins incorrect = { 0 };
		}
		
		A_a_b_cross : cross a_correct, b_correct {
			bins A_a_correct = binsof(a_correct.correct) && binsof(b_correct.incorrect);
			bins A_b_correct = binsof(a_correct.incorrect) && binsof(b_correct.correct);
			bins A_ab_correct = binsof(a_correct.correct) && binsof(b_correct.correct);
			bins A_ab_incorrect = binsof(a_correct.incorrect) && binsof(b_correct.incorrect);
		}
	
	endgroup
	
	covergroup cg_data;
	
	    option.name = "i_cg_data";
		
		a_data_sign : coverpoint bfm.arg_a {
			bins positive = { [1:$] };
			bins negative = { [$:-1] };
		}
		
		a_data : coverpoint bfm.arg_a {
			bins max_pos  = { 16'sh7FFF };
			bins min_pos  = { 16'sh0001 };
			bins min_neg  = { 16'sh8000 };
			bins max_neg  = { 16'shFFFF };
		}
		
		a_zero : coverpoint bfm.arg_a {
			bins zero     = { 16'sh0000 };
			bins non_zero = { [$:-1],[1:$] };
		}
		
		b_data_sign : coverpoint bfm.arg_b {
			bins positive = { [1:$] };
			bins negative = { [$:-1] };
		}
	
		b_data : coverpoint bfm.arg_b {
			bins max_pos  = { 16'sh7FFF };
			bins min_pos  = { 16'sh0001 };
			bins min_neg  = { 16'sh8000 };
			bins max_neg  = { 16'shFFFF };
		}
		
		b_zero : coverpoint bfm.arg_b {
			bins zero     = { 16'sh0000 };
			bins non_zero = { [$:-1],[1:$] };
		}
		
		A_a_b_cross_pos_neg : cross a_data_sign, b_data_sign {
			bins A_a_neg_b_pos = binsof(a_data_sign.negative) && binsof(b_data_sign.positive);
			bins A_a_pos_b_neg = binsof(a_data_sign.positive) && binsof(b_data_sign.negative);
			bins A_a_b_pos = binsof(a_data_sign.positive) && binsof(b_data_sign.positive);
			bins A_a_b_neg = binsof(a_data_sign.negative) && binsof(b_data_sign.negative);
		}
		
		A_a_b_cross_zero : cross a_zero, b_zero {
			bins A_a_zero_b_zero = binsof(a_zero.zero) && binsof(b_zero.zero);
			bins A_a_nzero_b_zero = binsof(a_zero.non_zero) && binsof(b_zero.zero);
			bins A_a_zero_b_nzero = binsof(a_zero.zero) && binsof(b_zero.non_zero);
			bins A_a_nzero_b_nzero = binsof(a_zero.non_zero) && binsof(b_zero.non_zero);
		}
	
		A_a_b_cross_min_max : cross a_data, b_data {
			bins A_a_max_pos_b_min_neg = binsof(a_data.max_pos) && binsof(b_data.min_neg);
			bins A_a_max_pos_b_max_neg = binsof(a_data.max_pos) && binsof(b_data.max_neg);
			bins A_a_max_pos_b_max_pos = binsof(a_data.max_pos) && binsof(b_data.max_pos);
			bins A_a_max_pos_b_min_pos = binsof(a_data.max_pos) && binsof(b_data.min_pos);
	
			bins A_a_min_pos_b_min_neg = binsof(a_data.min_pos) && binsof(b_data.min_neg);
			bins A_a_min_pos_b_max_neg = binsof(a_data.min_pos) && binsof(b_data.max_neg);
			bins A_a_min_pos_b_max_pos = binsof(a_data.min_pos) && binsof(b_data.max_pos);
			bins A_a_min_pos_b_min_pos = binsof(a_data.min_pos) && binsof(b_data.min_pos);
			
			bins A_a_max_neg_b_min_neg = binsof(a_data.max_neg) && binsof(b_data.min_neg);
			bins A_a_max_neg_b_max_neg = binsof(a_data.max_neg) && binsof(b_data.max_neg);
			bins A_a_max_neg_b_max_pos = binsof(a_data.max_neg) && binsof(b_data.max_pos);
			bins A_a_max_neg_b_min_pos = binsof(a_data.max_neg) && binsof(b_data.min_pos);
	
			bins A_a_min_neg_b_min_neg = binsof(a_data.min_neg) && binsof(b_data.min_neg);
			bins A_a_min_neg_b_max_neg = binsof(a_data.min_neg) && binsof(b_data.max_neg);
			bins A_a_min_neg_b_max_pos = binsof(a_data.min_neg) && binsof(b_data.max_pos);
			bins A_a_min_neg_b_min_pos = binsof(a_data.min_neg) && binsof(b_data.min_pos);
		}
	
	endgroup
	
	
	function new (virtual vdic_dut_2023_bfm b);
		cg_parities = new();
		cg_data     = new();
        bfm         = b;
	endfunction : new

	task execute();
	    forever begin 
		    t_data_packet dp;
		    bfm.get_data_posedge(dp);
		    arg_a = dp.arg_a;
		    arg_a_parity = dp.arg_a_parity;
		    arg_b = dp.arg_b;
		    arg_b_parity = dp.arg_b_parity;
	    	arg_a_par_correct = (^arg_a) == arg_a_parity;
			arg_b_par_correct = (^arg_b) == arg_b_parity;
		    cg_parities.sample();
		    cg_data.sample();
		    #1step;
		    if($get_coverage()==100) break;
	    end
	endtask

endclass