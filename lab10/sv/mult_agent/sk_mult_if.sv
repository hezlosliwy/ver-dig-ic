//----------------------------------------------------------------------
// Created by Stanislaw Klat on Wed Jan 03 20:41:39 CET 2024
//----------------------------------------------------------------------

// The  sk mult interface
interface sk_mult_if(input clock, input reset);

  // Control whether checks are enabled.
  bit                has_checks = 1;
  // Control whether coverage is enabled.
  bit                has_coverage = 1;


  // XXX sk_mult_if: Define signals 
  //
  // For example:
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

   // TODO sk_mult_if: Implement assertions 
   // For example:
   // always @(negedge sig_clock) begin
   //
   // // Read and write never true at the same time
   // assertReadOrWrite: assert property (
   //                disable iff(!has_checks) 
   //                ($onehot(sig_grant) |-> !(sig_read && sig_write)))
   //                else
   //                  $error("ERR_READ_OR_WRITE\n Read and Write true at the same time");   
   //
   // end
   
    task send2dut(
		input bit signed   [15:0]  a, b, input bit a_parity , b_parity
	);
    automatic int timeout = 1000;

	arg_a = a;
	arg_a_parity = a_parity;
	arg_b = b;
	arg_b_parity = b_parity;
	req = 1'b1;
    while(!ack) begin
	    @(negedge clock);
    end
	req = 1'b0;
    while(ack !== 0) begin
	    timeout--;
	    @(negedge clock);
	    if(timeout==0) begin
//		    `uvm_info("BFM send2dut()", "Data sending timeout!", UVM_DEBUG)
		    break;
	    end
    end

	endtask : send2dut

//	task get_from_dut(
//		output sk_res_item  s_result
//	);
//	    while(result_rdy !== 1) begin
//		    @(negedge clk);
//	    end
//	    `uvm_info("BFM send2dut()", "RESULT READY!!!", UVM_DEBUG)
//	    s_result.mult_res = result;
//	    s_result.result_par = result_parity;
//	    s_result.par_error = arg_parity_error;
//		result_monitor_h.write_to_monitor(s_result);
//	    while(result_rdy !== 0) begin
//		    @(negedge clk);
//	    end
//	endtask

endinterface : sk_mult_if
