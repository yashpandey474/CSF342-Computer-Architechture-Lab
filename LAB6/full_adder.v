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