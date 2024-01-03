class random_command extends uvm_transaction;
    `uvm_object_utils(random_command)

//------------------------------------------------------------------------------
// transaction variables
//------------------------------------------------------------------------------

    rand bit signed   [15:0]  a;
    rand bit                  a_parity;
    rand bit signed   [15:0]  b;
    rand bit                  b_parity;

//------------------------------------------------------------------------------
// constraints
//------------------------------------------------------------------------------
   constraint data_a {
        a dist {[-16'd32767:-16'd1]:/1, [16'd1:16'd32767]:/1, 16'h0000:/1, 16'sh8000:/1, 16'h7FFF:/1, -16'h0001:/1, 16'h0001:/1};
   }
   constraint data_b {
        b dist {[-16'd32767:-16'd1]:/1, [16'd1:16'd32767]:/1, 16'h0000:/1, 16'sh8000:/1, 16'h7FFF:/1, -16'h0001:/1, 16'h0001:/1};
    }
    
//------------------------------------------------------------------------------
// transaction functions: do_copy, clone_me, do_compare, convert2string
//------------------------------------------------------------------------------

    function void do_copy(uvm_object rhs);
        random_command copied_transaction_h;

        if(rhs == null)
            `uvm_fatal("RANDOM COMMAND", "Tried to copy from a null pointer")

        super.do_copy(rhs); // copy all parent class data

        if(!$cast(copied_transaction_h,rhs))
            `uvm_fatal("RANDOM COMMAND", "Tried to copy wrong type.")

        a  = copied_transaction_h.a;
        b  = copied_transaction_h.b;
        a_parity = copied_transaction_h.a_parity;
        b_parity = copied_transaction_h.b_parity;

    endfunction : do_copy


    function random_command clone_me();
        
        random_command clone;
        uvm_object tmp;

        tmp = this.clone();
        $cast(clone, tmp);
        return clone;
        
    endfunction : clone_me


    function bit do_compare(uvm_object rhs, uvm_comparer comparer);
        
        random_command compared_transaction_h;
        bit same;

        if (rhs==null) `uvm_fatal("RANDOM TRANSACTION",
                "Tried to do comparison to a null pointer");

        if (!$cast(compared_transaction_h,rhs))
            same = 0;
        else
            same = super.do_compare(rhs, comparer) &&
            (compared_transaction_h.a == a) &&
            (compared_transaction_h.b == b) &&
            (compared_transaction_h.a_parity == a_parity) &&
            (compared_transaction_h.b_parity == b_parity);

        return same;
        
    endfunction : do_compare


    function string convert2string();
        string s;
        s = $sformatf("a: %2h  b: %2h a_parity: %1b b_parity: %1b", a, b, a_parity, b_parity);
        return s;
    endfunction : convert2string

//------------------------------------------------------------------------------
// constructor
//------------------------------------------------------------------------------

    function new (string name = "");
        super.new(name);
    endfunction : new

endclass : random_command