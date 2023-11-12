package misc_pkg;

// debug print
function void dprint(string str);
    `ifdef DEBUG
        $display(str);
    `endif
endfunction

/* Type defs */
typedef struct packed {
    bit signed   [15:0]  arg_a;
    bit                  arg_a_parity;
    bit signed   [15:0]  arg_b;
    bit                  arg_b_parity;
} t_data_packet;

typedef struct packed{
    logic signed [31:0] mult_res;
    logic par_error;
    logic result_par;
} t_s_output_vect;

endpackage