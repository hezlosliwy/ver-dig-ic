class zerorand_sequence extends uvm_sequence #(random_sequence_item);
	`uvm_object_utils(zerorand_sequence)
	
	//req inherited
	
    function new(string name = "zerorand_sequence");
        super.new(name);
    endfunction : new
    
    task body();
	    `uvm_info("SEQUENCE ZERORAND", "", UVM_MEDIUM)
	    `uvm_create(req);
	    
	    repeat (5000) begin
		   `uvm_rand_send_with(req, {a == 0;} )
   		   `uvm_rand_send_with(req, {b == 0;} )
   		   `uvm_rand_send_with(req, {a == 0; b == 0;} )
//		   `uvm_rand_send(req) //instead of start_item, randomize and finish_item
	    end
    endtask
endclass