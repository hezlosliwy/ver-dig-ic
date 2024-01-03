//----------------------------------------------------------------------
// Created by Stanislaw Klat on Wed Jan 03 20:41:39 CET 2024
//----------------------------------------------------------------------

`ifndef SK_MULT_ITEM_SVH
`define SK_MULT_ITEM_SVH

// The sk mult item.
class sk_mult_item extends uvm_sequence_item;

  // TODO sk_mult_item: Define fields
  // For example:
  rand int unsigned m_data;

  // TODO sk_mult_item: Define default constraints
  // For example:
  constraint c_data {
    m_data inside {1,2,4,8};
  }

  `uvm_object_utils_begin(sk_mult_item)
    // TODO sk_mult_item: Register fields
    // For example:
    `uvm_field_int(m_data, UVM_DEFAULT)
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
