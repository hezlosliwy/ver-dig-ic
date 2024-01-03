class minmax_sequence_item extends random_sequence_item;
    `uvm_object_utils(minmax_sequence_item)

    function new (string name = "minmax_sequence_item");
        super.new(name);
    endfunction : new

    constraint data {
        a dist {-32768:=1, 32767:=1, -1:=1, 1:=1};
        b dist {-32768:=1, 32767:=1, -1:=1, 1:=1};
    }

endclass : minmax_sequence_item