import shape_pkg::*;
import shapes_pkg::*;

class shape_factory;

    static function shape_c make_shape(point que[$]);
        triangle_c  triangle_h;
        rectangle_c rectangle_h;
        circle_c    circle_h;
        polygon_c   polygon_h;
        case (que.size())
            2: begin
                circle_h = new(que);
                return circle_h;
            end
            3: begin
                triangle_h = new(que);
                return triangle_h;
            end
            4: begin
                rectangle_h = new(que);
                return rectangle_h;
            end
            default: begin
                polygon_h = new(que);
                return polygon_h;
            end
        endcase
    endfunction

endclass