import shape_pkg::*;

class circle_c extends shape_c;

    function new(point que[$]);
        super.new("circle", que);
    endfunction

    function real get_area();
        return 3.14*((points[0].x - points[1].x)**2 + (points[0].y - points[1].y)**2);
    endfunction

endclass