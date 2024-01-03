class zerorand_test extends base_test;
	`uvm_component_utils(zerorand_test)
	
	local zerorand_sequence zerorand_h;
	
    function new(string name, uvm_component parent);
		super.new(name, parent);
	    zerorand_h = new("zerorand_h");
	endfunction : new
	
   task run_phase(uvm_phase phase);
      phase.raise_objection(this);
      zerorand_h.start(sequencer_h);
      phase.drop_objection(this);
   endtask : run_phase

endclass : zerorand_test