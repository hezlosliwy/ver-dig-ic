import shape_pkg::*;

class polygon_c extends shape_c;

    function new(point que[$]);
        super.new("polygon", que);
    endfunction

    function real get_area();
        return -1.0;
    endfunction

endclass