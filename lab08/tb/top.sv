module top;
	
import uvm_pkg::*;
`include "uvm_macros.svh"

import vdic_dut_2023_pkg::*;

vdic_dut_2023_bfm class_bfm();

vdic_dut_2023 class_DUT (
    .clk(bfm.clk),
    .rst_n(bfm.rst_n),
    .arg_a(bfm.arg_a),
    .arg_a_parity(bfm.arg_a_parity),
    .arg_b(bfm.arg_b),
    .arg_b_parity(bfm.arg_b_parity),
    .req(bfm.req),
    .ack(bfm.ack),
    .result(bfm.result),
    .result_parity(bfm.result_parity),
    .result_rdy(bfm.result_rdy),
    .arg_parity_error(bfm.arg_parity_error)
);

vdic_dut_2023_bfm module_bfm();

vdic_dut_2023 module_DUT (
    .clk(bfm.clk),
    .rst_n(bfm.rst_n),
    .arg_a(bfm.arg_a),
    .arg_a_parity(bfm.arg_a_parity),
    .arg_b(bfm.arg_b),
    .arg_b_parity(bfm.arg_b_parity),
    .req(bfm.req),
    .ack(bfm.ack),
    .result(bfm.result),
    .result_parity(bfm.result_parity),
    .result_rdy(bfm.result_rdy),
    .arg_parity_error(bfm.arg_parity_error)
);


initial begin
    uvm_config_db #(virtual vdic_dut_2023_bfm)::set(null, "*", "class_bfm", class_bfm);
    uvm_config_db #(virtual vdic_dut_2023_bfm)::set(null, "*", "module_bfm", module_bfm);
	run_test("dual_test");
end

endmodule : top


