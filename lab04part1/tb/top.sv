module top;

    import shape_pkg::*;
	`include "shape_reporter.svh"
	
    initial begin
        int fd;
        point point_que[$];
	   	
        fd = $fopen("../tb/lab04part1_shapes.txt", "r");
        if(fd==0) begin
            $display("File not found: %0d", fd);
            $finish;
        end

        
        while(!$feof(fd)) begin
            string line;
            automatic int str_pointer;
	        shape_c tmp_shape;
	        
            void'($fgets(line, fd));
	        if(line.len()==0) break;
	        
            while(1) begin
                point tmp_point;
	            
                tmp_point.x = line[0]=="-" ? -line.atoreal(): line.atoreal();
                str_pointer = 0;
                while(line[str_pointer]!=" " && line[str_pointer]!="\n") begin
                    str_pointer += 1;
                end
                if(line[str_pointer]=="\n") break;
                else line = line.substr(str_pointer+1,line.len()-1);
                
                tmp_point.y = line[0]=="-" ? -line.atoreal(): line.atoreal();
//                $display("X=%0.2f, y=%0.2f", tmp_point.x, tmp_point.y);
                point_que.push_back(tmp_point);
                str_pointer = 0;
                while(line[str_pointer]!=" " && line[str_pointer]!="\n") begin
                    str_pointer += 1;
                end
                if(line[str_pointer]=="\n") break;
                else line = line.substr(str_pointer+1,line.len()-1);

            end
            
            tmp_shape = shape_factory::make_shape(point_que);
            case (point_que.size())
	            2: begin
	                shape_reporter#(circle_c)::set_storage(circle_c'(tmp_shape));
	            end
	            3: begin
	                shape_reporter#(triangle_c)::set_storage(triangle_c'(tmp_shape));
	            end
	            4: begin
	                shape_reporter#(rectangle_c)::set_storage(rectangle_c'(tmp_shape));
	            end
	            default: begin
	                shape_reporter#(polygon_c)::set_storage(polygon_c'(tmp_shape));
	            end
            endcase
            point_que.delete();
        end
                
        shape_reporter#(circle_c)::report_shapes();
        shape_reporter#(triangle_c)::report_shapes();
        shape_reporter#(rectangle_c)::report_shapes();
        shape_reporter#(polygon_c)::report_shapes();
        $finish;
    end

endmodule