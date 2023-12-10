class driver extends uvm_component;
    `uvm_component_utils(driver)
    
    virtual vdic_dut_2023_bfm bfm;
    uvm_get_port #(random_command) data_port;
    
    function new (string name, uvm_component parent);
        super.new(name, parent);
    endfunction : new

    /* build phase */
    function void build_phase(uvm_phase phase);
	    
	    vdic_dut_2023_agent_config vdic_dut_2023_agent_config_h;
	    
        if(!uvm_config_db #(vdic_dut_2023_agent_config)::get(this, "","config", vdic_dut_2023_agent_config_h))
            `uvm_fatal("DRIVER", "Failed to get config");
        bfm = vdic_dut_2023_agent_config_h.bfm;
            
        data_port = new("data_port",this);
    endfunction : build_phase
    
    /* run phase */
    task run_phase(uvm_phase phase);
        random_command data_pkt;

        forever begin : data_loop
            data_port.get(data_pkt);
            bfm.send2dut(data_pkt);
        end : data_loop
    endtask : run_phase
    

endclass : driver