import shape_pkg::*;

virtual class shape_c;

    string name;
    point points[$];

    function new(string name_s, point que[$]);
	    name = name_s;
        foreach(que[i]) begin
            points.push_back(que[i]);
        end
    endfunction

    pure virtual function real get_area();

    function void print();
	    real area;
        string area_s;
	    $display("--------------------------------------------------------------------------------");
        $display("This is: %s", name);
        foreach(points[i]) $display("(%0.2f, %0.2f)", points[i].x, points[i].y);
        area = get_area();
        if(area >= 0) $sformat(area_s, "%0.2f", area);
        else area_s = "can not be calculated for generic polygon";
        $display("Area is: %s", area_s);
    endfunction

endclass