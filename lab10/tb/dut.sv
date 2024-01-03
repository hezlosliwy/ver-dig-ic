//----------------------------------------------------------------------
// Created by Stanislaw Klat on Wed Jan 03 20:41:39 CET 2024
//----------------------------------------------------------------------

//This is a dummy DUT.
module dut(
    input wire clock,
    input wire reset,
    input  logic signed [15:0] arg_a,
    input  logic               arg_a_parity,     // parity bit for arg b (even parity)
    input  logic signed [15:0] arg_b,        
    input  logic               arg_b_parity,     // parity bit for arg_a (even parity)
    input  logic               req,              // arguments are valid
    output logic               ack,              // acknowledge for the arguments
    output logic signed [31:0] result,           // result of multiplication
    output logic               result_parity,    // parity bit for result (even parity)
    output logic               result_rdy,       // result is ready
    output logic               arg_parity_error  // set to 1 when input data has parity errors
	);
	
	vdic_dut_2023 DUT(
    .clk(clock),
    .rst_n(reset),
    .arg_a,
    .arg_a_parity,
    .arg_b,
    .arg_b_parity,
    .req,
    .ack,
    .result,
    .result_parity,
    .result_rdy,
    .arg_parity_error
);

endmodule : dut
