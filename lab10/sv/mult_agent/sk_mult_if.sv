//----------------------------------------------------------------------
// Created by Stanislaw Klat on Wed Jan 03 20:41:39 CET 2024
//----------------------------------------------------------------------

// The  sk mult interface
interface sk_mult_if(input clock, input reset);

  // Control whether checks are enabled.
  bit                has_checks = 1;
  // Control whether coverage is enabled.
  bit                has_coverage = 1;


  // TODO sk_mult_if: Define signals 
  //
  // For example:
  logic              [32:0] data;

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

endinterface : sk_mult_if
