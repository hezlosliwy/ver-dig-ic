import shape_pkg::*;
import shapes_pkg::*;

class shape_factory;

	protected static function bit is_rectangle(point que[$]);
		bit [3:0] test_res = 4'hF;
		for(int i = 0; i<4; i++) begin
			if(
			(   (que[(i+0)%4].x-que[(i+1)%4].x)**2+(que[(i+0)%4].y-que[(i+1)%4].y)**2   +
				(que[(i+1)%4].x-que[(i+2)%4].x)**2+(que[(i+1)%4].y-que[(i+2)%4].y)**2 ) !=
				(que[(i+2)%4].x-que[(i+0)%4].x)**2+(que[(i+2)%4].y-que[(i+0)%4].y)**2
				) test_res[i] = 1'b0;
		end
		return &test_res;
	endfunction

    static function shape_c make_shape(point que[$], ref e_shape e_shape_i);
        triangle_c  triangle_h;
        rectangle_c rectangle_h;
        circle_c    circle_h;
        polygon_c   polygon_h;
        case (que.size())
            2: begin
	            e_shape_i = CIRCLE;
                circle_h = new(que);
                return circle_h;
            end
            3: begin
	            e_shape_i = TRIANGLE;
                triangle_h = new(que);
                return triangle_h;
            end
            4: begin
	            if(is_rectangle(que)) begin
		            e_shape_i = RECTANGLE;
	                rectangle_h = new(que);
	            end
	            else begin
    	            e_shape_i = POLYGON;
                	polygon_h = new(que);
	            end
                return rectangle_h;
            end
            default: begin
	            if(que.size()) begin
		            e_shape_i = POLYGON;
	                polygon_h = new(que);
	            end
	            else e_shape_i = NO_SHAPE;
	            return polygon_h;
            end
        endcase
    endfunction

endclass