class driver extends uvm_component;
    `uvm_component_utils(driver)
    
    protected virtual vdic_dut_2023_bfm bfm;
    uvm_get_port #(random_command) data_port;
    
    function new (string name, uvm_component parent);
        super.new(name, parent);
    endfunction : new

    /* build phase */
    function void build_phase(uvm_phase phase);
        if(!uvm_config_db #(virtual vdic_dut_2023_bfm)::get(null, "*","bfm", bfm))
            `uvm_fatal("DRIVER", "Failed to get BFM")
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