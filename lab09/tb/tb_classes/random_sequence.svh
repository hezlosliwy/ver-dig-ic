class random_sequence extends uvm_sequence #(random_sequence_item);
	`uvm_object_utils(random_sequence)
	
	//req inherited
	
    function new(string name = "random_sequence");
        super.new(name);
    endfunction : new
    
    task body();
	    `uvm_info("SEQUENCE RAND", "", UVM_MEDIUM)
	    `uvm_create(req);
	    
	    repeat (5000) begin
		   `uvm_rand_send(req) 
	    end
    endtask
endclass