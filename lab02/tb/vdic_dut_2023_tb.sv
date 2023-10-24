module top;

/* Type defs */

typedef enum bit {
    PASSED,
    FAILED
} test_res_t;

typedef struct packed{
    logic signed [31:0] mult_res;
    logic par_error;
    logic result_par;
} t_s_output_vect;

/* Local vars */

//DUT inputs
bit signed   [15:0]  arg_a;
bit                  arg_a_parity;
bit signed   [15:0]  arg_b;
bit                  arg_b_parity;
bit                  req;

//auxiliary variables
bit arg_a_par_correct;
bit arg_b_par_correct;
bit [1:0] parity_mode;
	
//DUT outputs
wire                 ack;
wire signed   [31:0] result;
wire                 result_parity;
wire                 result_rdy;
wire                 arg_parity_error;

bit                  clk;
bit                  rst_n;

test_res_t           test_res = PASSED;

// DUT

vdic_dut_2023 DUT(
    .clk,
    .rst_n,
    .arg_a,
    .arg_a_parity,
    .arg_b,
    .arg_b_parity,
    .req,
    .ack,
    .result,
    .result_parity,
    .result_rdy,
    .arg_parity_error
);

// Clk gen
initial begin : clk_gen_blk
    clk = 0;
    forever begin : clk_frv_blk
        #10;
        clk = ~clk;
    end
end

/* Tester functions */

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

// calculate expected result
function automatic t_s_output_vect get_expected(
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

/* Tester */
initial begin : tester
    rst_dut();
    repeat (1000) begin : tester_loop
        @(negedge clk);
        req = 1'b1;
	    parity_mode = 2'($random);
        arg_a = get_data();
        arg_a_parity = (^arg_a)^parity_mode[0];
        arg_b = get_data();
        arg_b_parity = (^arg_b)^parity_mode[1];
    
        while(!ack) @(negedge clk);
        req = 1'b0;
        while(!result_rdy) @(negedge clk);
    end : tester_loop
    $finish;
end : tester

assign arg_a_par_correct = (^arg_a) == arg_a_parity;
assign arg_b_par_correct = (^arg_b) == arg_b_parity;

// reset task
task rst_dut();
    dprint($sformatf("%0t DEBUG: reset_dut", $time));
    req   = 1'b0;
    rst_n = 1'b0;
    @(negedge clk);
    rst_n = 1'b1;
endtask : rst_dut

// show test result
final begin : finish_of_the_test
    print_test_res(test_res);
end

// debug print
function void dprint(string str);
    `ifdef DEBUG
        $display(str);
    `endif
endfunction

function void print_test_res (test_res_t res);
    					$display ("|---------------------------------|");
    if(res == PASSED)   $display ("|           Test PASSED           |");
    else                $display ("|           Test FAILED           |");
    					$display ("|---------------------------------|");
endfunction

/* coverage */

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
	
	a_data_sign : coverpoint arg_a {
		bins positive = { [1:$] };
		bins negative = { [$:-1] };
	}
	
	a_data : coverpoint arg_a {
		bins max_pos  = { 16'sh7FFF };
		bins min_pos  = { 16'sh0001 };
		bins min_neg  = { 16'sh8000 };
		bins max_neg  = { 16'shFFFF };
	}
	
	a_zero : coverpoint arg_a {
		bins zero     = { 16'sh0000 };
		bins non_zero = { [$:-1],[1:$] };
	}
	
	b_data_sign : coverpoint arg_b {
		bins positive = { [1:$] };
		bins negative = { [$:-1] };
	}

	b_data : coverpoint arg_b {
		bins max_pos  = { 16'sh7FFF };
		bins min_pos  = { 16'sh0001 };
		bins min_neg  = { 16'sh8000 };
		bins max_neg  = { 16'shFFFF };
	}
	
	b_zero : coverpoint arg_b {
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

cg_parities v_cg_parities;
cg_data v_cg_data;

initial begin : coverage

    v_cg_parities = new();
	v_cg_data = new();

    forever begin @(posedge clk);
	    if(req) begin
		    v_cg_parities.sample();
		    v_cg_data.sample();
		    #1step;
		    if($get_coverage()==100) break;
	    end
    end
end
/* scoreboard */

typedef struct packed {
    bit signed   [15:0]  arg_a;
    bit                  arg_a_parity;
    bit signed   [15:0]  arg_b;
    bit                  arg_b_parity;
} t_data_packet;

t_data_packet q_sb_data [$];
bit req_prev;

always @(posedge clk) begin : sb_fetch
    if(req == 1 && req_prev == 0) begin
        q_sb_data.push_front(
                t_data_packet'({arg_a, arg_a_parity, arg_b, arg_b_parity})
            );
    end
    req_prev <= req;
end : sb_fetch

always @(negedge clk) begin
    if(result_rdy) begin
        t_data_packet   dp;
        t_s_output_vect expected;

        dp = q_sb_data.pop_back();
        expected = get_expected(dp.arg_a, dp.arg_a_parity, dp.arg_b, dp.arg_b_parity);
        
        assert(result === expected.mult_res && result_parity === expected.result_par && arg_parity_error === expected.par_error) begin
            dprint($sformatf("Test passed for A=%0d A_parity=%0b B=%0d B_parity=%0b", dp.arg_a, dp.arg_a_parity, dp.arg_b, dp.arg_b_parity));
        end
        else begin
            test_res <= FAILED;
            $error("%0t Test FAILED for A=%0d A_parity=%0b B=%0d B_parity=%0b\nExpected: (MULT_RES: %d, PAR_ERR: %b, RES_PAR %b)  received: (MR: %d, PAR_ERR: %b, RES_PAR %b)", $time, arg_a, arg_a_parity, arg_b, arg_b_parity, expected.mult_res, expected.par_error, expected.result_par, result, arg_parity_error, result_parity);
        end
    end
end

endmodule : top
