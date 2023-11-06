interface vdic_dut_2023_bfm;

import vdic_dut_2023_pkg::*;

bit                  clk;
bit                  rst_n;

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

modport tlm(import rst_dut, get_data_posedge, send2dut, get_result);

// Clk gen
initial begin : clk_gen_blk
    clk = 0;
    forever begin : clk_frv_blk
        #10;
        clk = ~clk;
    end
end

// reset task
task rst_dut();
    dprint($sformatf("%0t DEBUG: reset_dut", $time));
    req   = 1'b0;
	rst_n = 1'b1;
    @(negedge clk);
    rst_n = 1'b0;
    @(negedge clk);
    rst_n = 1'b1;
endtask : rst_dut

task send2dut(
	input t_data_packet  s_data
);
    automatic int timeout = 1000;

	arg_a = s_data.arg_a;
	arg_a_parity = s_data.arg_a_parity;
	arg_b = s_data.arg_b;
	arg_b_parity = s_data.arg_b_parity;
	req = 1'b1;
    while(!ack) begin
	    @(negedge clk);
    end
	req = 1'b0;
    while(ack) begin
	    timeout--;
	    @(negedge clk);
	    if(timeout==0) break;
    end

endtask : send2dut

task get_data_posedge(
	output t_data_packet  s_ret
);
	while(!req) begin
	    @(posedge clk);
    end
	s_ret.arg_a = arg_a;
	s_ret.arg_a_parity = arg_a_parity;
	s_ret.arg_b = arg_b;
	s_ret.arg_b_parity = arg_b_parity;
	while(req) begin
	    @(posedge clk);
    end
endtask : get_data_posedge

task get_result(
	output t_s_output_vect s_result
);
    while(result_rdy !== 1) begin
	    @(negedge clk);
    end
    dprint("RESULT READY!!!");
    s_result.mult_res = result;
    s_result.result_par = result_parity;
    s_result.par_error = arg_parity_error;
    while(result_rdy !== 0) begin
	    @(negedge clk);
    end
endtask : get_result

endinterface : vdic_dut_2023_bfm