class env extends uvm_env;
	`uvm_component_utils(env)
	
    vdic_dut_2023_agent class_vdic_dut_2023_agent_h;
    vdic_dut_2023_agent module_vdic_dut_2023_agent_h;
	
    function new (string name, uvm_component parent);
        super.new(name,parent);
    endfunction : new

    function void build_phase(uvm_phase phase);
        env_config env_config_h;
        vdic_dut_2023_agent_config class_agent_config_h;
        vdic_dut_2023_agent_config module_agent_config_h;
	    
        if(!uvm_config_db #(env_config)::get(this, "","config", env_config_h))
            `uvm_fatal("ENV", "Failed to get config object");
	    
        // create configs for the agents
        class_agent_config_h   = new(.bfm(env_config_h.class_bfm), .is_active(UVM_ACTIVE));
        
        // for the second DUT we provide external stimulus, the agent does not generate it
        module_agent_config_h  = new(.bfm(env_config_h.module_bfm), .is_active(UVM_PASSIVE));
	    
        uvm_config_db #(vdic_dut_2023_agent_config)::set(this, "class_vdic_dut_2023_agent_h*",
            "config", class_agent_config_h);
        uvm_config_db #(vdic_dut_2023_agent_config)::set(this, "module_vdic_dut_2023_agent_h*",
            "config", module_agent_config_h);
	    
        class_vdic_dut_2023_agent_h  = vdic_dut_2023_agent::type_id::create("class_vdic_dut_2023_agent_h",this);
        module_vdic_dut_2023_agent_h = vdic_dut_2023_agent::type_id::create("module_vdic_dut_2023_agent_h",this);
	    
    endfunction : build_phase




//    function void end_of_elaboration_phase(uvm_phase phase);
//        super.end_of_elaboration_phase(phase);
//	    `uvm_info("ENV", $sformatf("*** Created tpgen type: %s\n", tpgen_h.get_type_name()), UVM_NONE)
//    endfunction : end_of_elaboration_phase

endclass : env