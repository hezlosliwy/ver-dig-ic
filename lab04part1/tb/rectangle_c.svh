import shape_pkg::*;

class rectangle_c extends shape_c;

    function new(point que[$]);
        super.new("rectangle", que);
    endfunction

    function real get_area();
        return ((points[0].x - points[1].x)**2 + (points[0].y - points[1].y)**2)**0.5 * 
               ((points[2].x - points[1].x)**2 + (points[2].y - points[1].y)**2)**0.5;
    endfunction

endclass