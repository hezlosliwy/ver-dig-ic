class minmax_sequence extends uvm_sequence #(random_sequence_item);
	`uvm_object_utils(minmax_sequence)
	
	//req inherited
	
    function new(string name = "minmax_sequence");
        super.new(name);
    endfunction : new
    
    task body();
	    `uvm_info("SEQUENCE MINMAX", "", UVM_MEDIUM)
	    `uvm_create(req);
	    
	    repeat (5000) begin
		    `uvm_rand_send_with(req, {a dist {-32768:=1, 32767:=1, -1:=1, 1:=1};
			    					  b dist {-32768:=1, 32767:=1, -1:=1, 1:=1};} )
	    end
    endtask
endclass