//AND MODULE
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

module full_adder(cout, sum, in1, in2, cin);
    input in1, in2;
    input cin;
    output sum, cout;

    assign {cout, sum} = in1 + in2 + cin;
endmodule

module full_adder_32bit(cout, sum, in1, in2, cin);
    input [31: 0] in1, in2;
    output [31: 0] sum;

    input cin;
    output cout;

    wire [31: 0] carry;

    assign carry[0] = cin;

    genvar j;

    generate for (j = 0; j < 32; j = j + 1) begin: full_adder_loop
        if ( j == 31)
        begin
            full_adder fa1(cout, sum[j], in1[j], in2[j], carry[j]);
        end
        else
        begin
            full_adder fa1(carry[j + 1], sum[j], in1[j], in2[j], carry[j]);
        end
    end
    endgenerate


endmodule

module mux2to1 (out, sel, in1, in2);
    input in1, in2, sel;
    output out;

    wire not_sel, a1, a2;

    not(not_sel, sel);
    and(a1, sel, in2);
    and(a2, not_sel, in1);

    or (out, a1, a2);

endmodule

module bit8_2to1mux(out, sel, in1, in2);
    input [7:0] in1, in2;
    output [7:0] out;

    input sel;

    //GENERATE STATEMENT AND FOR LOOP FOR 8 MUX
    genvar j;

    generate for (j = 0; j<8; j = j + 1) begin: mux_loop
        mux2to1 mj(out[j], sel, in1[j], in2[j]);
    end
    endgenerate

endmodule

module bit32_2to1mux(out, sel, in1, in2);
    input [31:0] in1, in2;
    output [31:0] out;

    input sel;

    genvar j;

    generate for (j = 0; j<4; j = j + 1) begin: mux_loop
        bit8_2to1mux mj(out[7 + j*8:j*8], sel, in1[7 + j*8:j*8], in2[7 + j*8:j*8]);
    end
    endgenerate
endmodule



module mux3to1 (out, sel1, sel2, in1, in2, in3);
    input in1, in2, in3, sel1, sel2;
    output out;


    wire out1;

    mux2to1 m1(out1, sel1, in1, in2);
    mux2to1 m2(out, sel2, out1, in3);

endmodule

module bit8_3to1mux(out, sel1, sel2, in1, in2, in3);
    input [7:0] in1, in2, in3;
    output [7:0] out;

    input sel1, sel2;

    //GENERATE STATEMENT AND FOR LOOP FOR 8 MUX
    genvar j;

    generate for (j = 0; j<8; j = j + 1) begin: mux_loop
        mux3to1 mj(out[j], sel1, sel2, in1[j], in2[j], in3[j]);
    end
    endgenerate

endmodule

module bit32_3to1mux(out, sel1, sel2, in1, in2, in3);
    input [31:0] in1, in2, in3;
    output [31:0] out;

    input sel1, sel2;

    genvar j;

    generate for (j = 0; j<4; j = j + 1) begin: mux_loop
        bit8_3to1mux mj(out[7 + j*8:j*8], sel1, sel2, in1[7 + j*8:j*8], in2[7 + j*8:j*8], in3[7 + j*8:j*8]);
    end
    endgenerate
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

module tbALU;
    reg Binvert,Carryin;
    reg [1:0] Operation;
    reg [31:0] a,b;
    wire [31:0] Result;
    wire CarryOut;
    ALU alu(a,b,Binvert,Carryin,Operation,Result,CarryOut);

    initial
    begin
        a=32'd10;
        b=32'd10;
        Operation=2'b00;
        Binvert=1'b0;
        Carryin=1'b0; //must perform AND resulting in zero

        $monitor($time, "A = %d, B = %d OP = %b BINVERT = %b CIN = %b COUT = %b RESULT = %d", a, b, Operation, Binvert, Carryin, CarryOut, Result);

        #100 Operation=2'b01; //OR
        #100 Operation=2'b10; //ADD
        #100 Binvert=1'b1; Carryin = 1'b1;
        #200 $finish;
    end
endmodule
