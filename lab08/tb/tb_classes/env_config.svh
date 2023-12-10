class env_config;

    virtual vdic_dut_2023_bfm class_bfm;
    virtual vdic_dut_2023_bfm module_bfm;

    function new(virtual vdic_dut_2023_bfm class_bfm, virtual vdic_dut_2023_bfm module_bfm);
        this.class_bfm  = class_bfm;
        this.module_bfm = module_bfm;
    endfunction : new

endclass : env_config