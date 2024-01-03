class random_sequence_item extends uvm_sequence_item;

//------------------------------------------------------------------------------
// transaction variables
//------------------------------------------------------------------------------

    rand bit signed   [15:0]  a;
    rand bit                  a_parity;
    rand bit signed   [15:0]  b;
    rand bit                  b_parity;

    `uvm_object_utils_begin(random_sequence_item)
        `uvm_field_int(a, UVM_ALL_ON | UVM_DEC)
        `uvm_field_int(b, UVM_ALL_ON | UVM_DEC)
        `uvm_field_int(a_parity, UVM_ALL_ON | UVM_DEC)
        `uvm_field_int(b_parity, UVM_ALL_ON | UVM_DEC)
    `uvm_object_utils_end

//------------------------------------------------------------------------------
// constraints
//------------------------------------------------------------------------------
//   constraint data_a {
//        a dist {[-16'd32767:-16'd1]:/1, [16'd1:16'd32767]:/1, 16'h0000:/1, 16'sh8000:/1, 16'h7FFF:/1, -16'h0001:/1, 16'h0001:/1};
//   }
//   constraint data_b {
//        b dist {[-16'd32767:-16'd1]:/1, [16'd1:16'd32767]:/1, 16'h0000:/1, 16'sh8000:/1, 16'h7FFF:/1, -16'h0001:/1, 16'h0001:/1};
//    }
    

    function new(string name = "random_sequence_item");
        super.new(name);
    endfunction : new

//------------------------------------------------------------------------------
// functions: convert2string
//------------------------------------------------------------------------------

    function string convert2string();
        string s;
        s = $sformatf("a: %2h  b: %2h a_parity: %1b b_parity: %1b", a, b, a_parity, b_parity);
        return s;
    endfunction : convert2string

endclass : random_sequence_item