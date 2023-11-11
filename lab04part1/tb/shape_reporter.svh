import shapes_pkg::*;

class shape_reporter #(type T=shape_c);
	
    protected static T storage[$];
	
	// Set storage
	static function void set_storage(T data);
		storage.push_back(data);
	endfunction : set_storage
	
    static function void report_shapes();
    	foreach(storage[i]) storage[i].print();
    endfunction
endclass