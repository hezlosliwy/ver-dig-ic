//----------------------------------------------------------------------
// Created by Stanislaw Klat on Wed Jan 03 20:41:39 CET 2024
//----------------------------------------------------------------------

`ifndef SK_MULT_ITEM_SVH
`define SK_MULT_ITEM_SVH

// The sk mult item.
class sk_mult_item extends uvm_sequence_item;

  // XXX sk_mult_item: Define fields
  // For example:
  rand bit signed   [15:0]  a;
  rand bit                  a_parity;
  rand bit signed   [15:0]  b;
  rand bit                  b_parity;

  // XXX sk_mult_item: Define default constraints
  // base is random

  `uvm_object_utils_begin(sk_mult_item)
  	  // XXX sk_mult_item: Register fields (ctrl + space)
	  `uvm_field_int(a, UVM_ALL_ON | UVM_DEC)
	  `uvm_field_int(a_parity, UVM_ALL_ON | UVM_DEC)
	  `uvm_field_int(b, UVM_ALL_ON | UVM_DEC)
	  `uvm_field_int(b_parity, UVM_ALL_ON | UVM_DEC)
  `uvm_object_utils_end

  // new - constructor
  function new (string name = "sk_mult_item");
    super.new(name);
  endfunction : new

  // HINT UVM field macros don't work with unions and structs, you may have to override sk_mult_item.do_copy().
  virtual function void do_copy(uvm_object rhs);
    super.do_copy(rhs);
  endfunction : do_copy

  // HINT UVM field macros don't work with unions and structs, you may have to override sk_mult_item.do_pack().
  virtual function void do_pack(uvm_packer packer);
    super.do_pack(packer);
  endfunction : do_pack

  // HINT UVM field macros don't work with unions and structs, you may have to override sk_mult_item.do_unpack().
  virtual function void do_unpack(uvm_packer packer);
    super.do_unpack(packer);
  endfunction : do_unpack

  // HINT UVM field macros don't work with unions and structs, you may have to override sk_mult_item.do_print().
  virtual function void do_print(uvm_printer printer);
    super.do_print(printer);
  endfunction : do_print

endclass : sk_mult_item

`endif // SK_MULT_ITEM_SVH
