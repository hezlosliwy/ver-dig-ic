module tpgen(vdic_dut_2023_bfm bfm);

import vdic_dut_2023_pkg::*;

t_data_packet  data_pkt;
bit [1:0] parity_mode;

// Random data generation functions
function shortint get_data();

    bit [2:0] data_case;

    data_case = 3'($random);

    if (data_case == 3'b000)
        return 16'sh0000;
    else if (data_case == 3'b001)
        return 16'sh8000;
    else if (data_case == 3'b010)
	    return 16'sh7FFF;
    else if (data_case == 3'b011)
	    return 16'shFFFF;
    else if (data_case == 3'b100)
        return 16'sh0001;
    else
        return 16'($random);
endfunction : get_data

/* Tester */
initial begin : tester
    bfm.rst_dut();
    repeat (1000) begin : tester_loop
	    parity_mode = 2'($random);
        data_pkt.arg_a = get_data();
        data_pkt.arg_a_parity = (^data_pkt.arg_a)^parity_mode[0];
        data_pkt.arg_b = get_data();
        data_pkt.arg_b_parity = (^data_pkt.arg_b)^parity_mode[1];
		bfm.send2dut(data_pkt);
    end : tester_loop
    $finish;
end : tester

endmodule