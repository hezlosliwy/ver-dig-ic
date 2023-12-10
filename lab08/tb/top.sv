module top;
	
import uvm_pkg::*;
`include "uvm_macros.svh"

import vdic_dut_2023_pkg::*;

vdic_dut_2023_bfm class_bfm();

vdic_dut_2023 class_DUT (
    .clk(class_bfm.clk),
    .rst_n(class_bfm.rst_n),
    .arg_a(class_bfm.arg_a),
    .arg_a_parity(class_bfm.arg_a_parity),
    .arg_b(class_bfm.arg_b),
    .arg_b_parity(class_bfm.arg_b_parity),
    .req(class_bfm.req),
    .ack(class_bfm.ack),
    .result(class_bfm.result),
    .result_parity(class_bfm.result_parity),
    .result_rdy(class_bfm.result_rdy),
    .arg_parity_error(class_bfm.arg_parity_error)
);

vdic_dut_2023_bfm module_bfm();

vdic_dut_2023 module_DUT (
    .clk(module_bfm.clk),
    .rst_n(module_bfm.rst_n),
    .arg_a(module_bfm.arg_a),
    .arg_a_parity(module_bfm.arg_a_parity),
    .arg_b(module_bfm.arg_b),
    .arg_b_parity(module_bfm.arg_b_parity),
    .req(module_bfm.req),
    .ack(module_bfm.ack),
    .result(module_bfm.result),
    .result_parity(module_bfm.result_parity),
    .result_rdy(module_bfm.result_rdy),
    .arg_parity_error(module_bfm.arg_parity_error)
);

stim_module stim_module_h;

initial begin
	stim_module_h = new(module_bfm);
	stim_module_h.execute();
end

initial begin
    uvm_config_db #(virtual vdic_dut_2023_bfm)::set(null, "*", "class_bfm", class_bfm);
    uvm_config_db #(virtual vdic_dut_2023_bfm)::set(null, "*", "module_bfm", module_bfm);
	run_test("dual_test");
end

endmodule : top


