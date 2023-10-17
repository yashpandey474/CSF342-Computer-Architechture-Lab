
`include "3_1mux.v"
`include "2_1mux.v"

module bit32AND (out, in1, in2);
    input [31: 0] in1, in2;
    output [31: 0] out;

    assign out = in1 & in2;

endmodule


module bit32OR (out, in1, in2);
    input [31: 0] in1, in2;
    output [31: 0] out;

    assign out = in1 | in2;

endmodule

module bit32NOT(out, in1);
    input [31: 0] in1, in2;
    output [31: 0] out;

    assign out = ~in1;
endmodule

module ALU (in1, in2, binvert, cin, operation, result, cout);
    input [31: 0] in1, in2;
    output [31: 0] result;

    input [1: 0] operation;
    input binvert;

    output cout;
    input cin;

    wire[31: 0] and_res, or_res, fa_res;
    wire[31: 0] final_input;
    wire[31: 0] not_input;



    bit32NOT not1(not_input, in2);

    bit32_2to1mux mux2(final_input, binvert, in2, not_input);

    bit32AND a1(and_res, in1, final_input);
   
    bit32OR or1(or_res, in1, final_input);
   
    full_adder_32bit fa1(cout, fa_res, in1, final_input, cin);

    bit32_3to1mux mux1(result, operation[0], operation[1], and_res, or_res, fa_res);
endmodule