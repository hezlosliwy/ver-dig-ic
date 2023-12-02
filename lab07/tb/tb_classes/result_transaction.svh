class result_transaction extends uvm_transaction;
    `uvm_object_utils(result_transaction)

//------------------------------------------------------------------------------
// transaction variables
//------------------------------------------------------------------------------

    bit signed [31:0] mult_res;
    bit par_error;
    bit result_par;

//------------------------------------------------------------------------------
// transaction functions: do_copy, clone_me, do_compare, convert2string
//------------------------------------------------------------------------------

    function void do_copy(uvm_object rhs);
        result_transaction copied_transaction_h;

        if(rhs == null)
            `uvm_fatal("RANDOM COMMAND", "Tried to copy from a null pointer")

        super.do_copy(rhs); // copy all parent class data

        if(!$cast(copied_transaction_h,rhs))
            `uvm_fatal("RANDOM COMMAND", "Tried to copy wrong type.")

        mult_res   = copied_transaction_h.mult_res;
        par_error  = copied_transaction_h.par_error;
        result_par = copied_transaction_h.result_par;
		
    endfunction : do_copy


    function result_transaction clone_me();
        
        result_transaction clone;
        uvm_object tmp;

        tmp = this.clone();
        $cast(clone, tmp);
        return clone;
        
    endfunction : clone_me


    function bit do_compare(uvm_object rhs, uvm_comparer comparer);
        
        result_transaction compared_transaction_h;
        bit same;

        if (rhs==null) `uvm_fatal("RANDOM TRANSACTION",
                "Tried to do comparison to a null pointer");

        if (!$cast(compared_transaction_h,rhs))
            same = 0;
        else
            same = super.do_compare(rhs, comparer)    &&
            (compared_transaction_h.mult_res == mult_res) &&
            (compared_transaction_h.par_error == par_error) &&
            (compared_transaction_h.result_par == result_par);

        return same;
        
    endfunction : do_compare


    function string convert2string();
        string s;
        s = $sformatf("Result of transaction: %8h, Parity Error: %b, Result Parity: %b", mult_res, par_error, result_par);
        return s;
    endfunction : convert2string

//------------------------------------------------------------------------------
// constructor
//------------------------------------------------------------------------------

    function new (string name = "");
        super.new(name);
    endfunction : new

endclass : result_transaction