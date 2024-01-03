//----------------------------------------------------------------------
// Created by Stanislaw Klat on Wed Jan 03 20:41:39 CET 2024
//----------------------------------------------------------------------

`ifndef SK_MULT_SEQUENCER_SVH
`define SK_MULT_SEQUENCER_SVH

// The  sk mult sequencer.
class sk_mult_sequencer extends uvm_sequencer #(sk_mult_item);

  `uvm_component_utils(sk_mult_sequencer)

  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

endclass : sk_mult_sequencer

`endif // SK_MULT_SEQUENCER_SVH
