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

//DUT outputs
wire                 ack;
wire signed   [31:0] result;
wire                 result_parity;
wire                 result_rdy;
wire                 arg_parity_error;

bit                  clk;
bit                  rst_n;

t_s_output_vect      expected;
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
        return 16'h0000;
    else if (data_case == 3'b001)
        return 16'h8000;
    else if (data_case == 3'b010)
	    return 16'h3FFF;
    else if (data_case == 3'b011)
	    return 16'hFFFF;
    else if (data_case == 3'b100)
        return 16'h0001;
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

// Tester
initial begin : tester
    rst_dut();
    repeat (1000) begin : tester_loop
        @(negedge clk);
        req = 1'b1;
        arg_a = get_data();
        arg_a_parity = 1'($random);
        arg_b = get_data();
        arg_b_parity = 1'($random);
	    
        expected = get_expected(arg_a, arg_a_parity, arg_b, arg_b_parity);
        while(!ack) @(negedge clk);
        req = 1'b0;
        while(!result_rdy) @(negedge clk);

        assert(result === expected.mult_res && result_parity === expected.result_par && arg_parity_error === expected.par_error) begin
            dprint($sformatf("Test passed for A=%0d A_parity=%0b B=%0d B_parity=%0b", arg_a, arg_a_parity, arg_b, arg_b_parity));
        end
        else begin
            $display("Test FAILED for A=%0d A_parity=%0b B=%0d B_parity=%0b", arg_a, arg_a_parity, arg_b, arg_b_parity);
            $display("Expected: %d  received: %d", expected, result);
            test_res = FAILED;
        end
    end : tester_loop
    $finish;
end : tester

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

endmodule : top
