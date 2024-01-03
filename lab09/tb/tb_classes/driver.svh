class driver extends uvm_driver #(random_sequence_item);
    `uvm_component_utils(driver)
    
    protected virtual vdic_dut_2023_bfm bfm;
    
    function new (string name, uvm_component parent);
        super.new(name, parent);
    endfunction : new

    /* build phase */
    function void build_phase(uvm_phase phase);
        if(!uvm_config_db #(virtual vdic_dut_2023_bfm)::get(null, "*","bfm", bfm))
            `uvm_fatal("DRIVER", "Failed to get BFM")
    endfunction : build_phase
    
    /* run phase */
    task run_phase(uvm_phase phase);
        random_sequence_item data_pkt;

        forever begin : data_loop
	        seq_item_port.get_next_item(data_pkt);
            bfm.send2dut(data_pkt);
	        seq_item_port.item_done();
        end : data_loop
    endtask : run_phase
    

endclass : driver