interface vdic_dut_2023_bfm;

import misc_pkg::*;
import vdic_dut_2023_pkg::*;
import uvm_pkg::*;

data_monitor data_monitor_h;
result_monitor result_monitor_h;

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
	`uvm_info("BFM send2dut()", $sformatf("%0t DEBUG: reset_dut", $time), UVM_DEBUG)
    req   = 1'b0;
	rst_n = 1'b1;
    @(negedge clk);
    rst_n = 1'b0;
    @(negedge clk);
    rst_n = 1'b1;
endtask : rst_dut

task send2dut(
	input random_sequence_item  s_data
);
    automatic int timeout = 1000;

	arg_a = s_data.a;
	arg_a_parity = s_data.a_parity;
	arg_b = s_data.b;
	arg_b_parity = s_data.b_parity;
	req = 1'b1;
    while(!ack) begin
	    @(negedge clk);
    end
	req = 1'b0;
    while(ack !== 0) begin
	    timeout--;
	    @(negedge clk);
	    if(timeout==0) begin
		    `uvm_info("BFM send2dut()", "Data sending timeout!", UVM_DEBUG)
		    break;
	    end
    end

endtask : send2dut

initial begin
	rst_dut();
end

initial begin
	automatic random_command  s_ret;
	s_ret = new("random_command");
	forever begin
		while(!req) begin
		    @(posedge clk);
	    end
		s_ret.a = arg_a;
		s_ret.a_parity = arg_a_parity;
		s_ret.b = arg_b;
		s_ret.b_parity = arg_b_parity;
		data_monitor_h.write_to_monitor(s_ret);
		while(req) begin
		    @(posedge clk);
		end
	end
end

initial begin
	automatic result_transaction s_result = new("s_result");
	forever begin
	    while(result_rdy !== 1) begin
		    @(negedge clk);
	    end
	    `uvm_info("BFM send2dut()", "RESULT READY!!!", UVM_DEBUG)
	    s_result.mult_res = result;
	    s_result.result_par = result_parity;
	    s_result.par_error = arg_parity_error;
		result_monitor_h.write_to_monitor(s_result);
	    while(result_rdy !== 0) begin
		    @(negedge clk);
	    end
    end
end

endinterface : vdic_dut_2023_bfm