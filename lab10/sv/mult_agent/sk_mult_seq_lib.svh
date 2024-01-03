//----------------------------------------------------------------------
// Created by Stanislaw Klat on Wed Jan 03 20:41:39 CET 2024
//----------------------------------------------------------------------

`ifndef SK_MULT_SEQ_LIB_SVH
`define SK_MULT_SEQ_LIB_SVH

// The base sk mult base sequence. All children sequences inherit this behavior.
// It raises/drops objections in pre/post_body.
virtual class sk_mult_base_seq extends uvm_sequence#(sk_mult_item);
  
  `uvm_declare_p_sequencer(sk_mult_sequencer)

  function new(string name="sk_mult_base_seq");
    super.new(name);
  endfunction : new

  // Raise objection in pre_body.
  virtual task pre_body();
    uvm_phase starting_phase = get_starting_phase();
    if(starting_phase != null) begin
      `uvm_info(get_type_name(), $sformatf("%s pre_body() raising %s objection", get_sequence_path(), starting_phase.get_name()), UVM_MEDIUM)
      starting_phase.raise_objection(this);
    end
  endtask : pre_body

  // Drop objection in post_body.
  virtual task post_body();
    uvm_phase starting_phase = get_starting_phase();
    if(starting_phase != null) begin
      `uvm_info(get_type_name(), $sformatf("%s post_body() dropping %s objection", get_sequence_path(), starting_phase.get_name()), UVM_MEDIUM)
      starting_phase.drop_objection(this);
    end
  endtask : post_body

endclass : sk_mult_base_seq


// TODO sk mult sequence library: Define sequences
// For example:
class sk_mult_example_seq extends sk_mult_base_seq;

  function new(string name="sk_mult_example_seq");
    super.new(name);
  endfunction : new

  `uvm_object_utils(sk_mult_example_seq)

  rand int unsigned nof_items = 1;
  constraint nof_items_ct { (nof_items <= 10); }

  virtual task body();
    for (int i=0; i<nof_items; i++) begin
      `uvm_do(req);
      get_response(rsp);
    end
  endtask : body

endclass : sk_mult_example_seq

`endif // SK_MULT_SEQ_LIB_SVH
