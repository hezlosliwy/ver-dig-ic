class minmax_command extends random_command;
    `uvm_object_utils(minmax_command)

    function new (string name = "");
        super.new(name);
    endfunction : new

    constraint data {
        a dist {-32768:=1, 32767:=1, -1:=1, 1:=1};
        b dist {-32768:=1, 32767:=1, -1:=1, 1:=1};
    }

endclass : minmax_command