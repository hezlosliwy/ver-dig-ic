import shape_pkg::*;

class triangle_c extends shape_c;

    function new(point que[$]);
        super.new("triangle", que);
    endfunction

    function real get_area();
	    real tmp = 0.5*(points[0].x*(points[1].y-points[2].y) + points[1].x*(points[2].y-points[0].y) + points[2].x*(points[0].y-points[1].y));
        return tmp < 0 ? tmp*-1 : tmp;
    endfunction

endclass