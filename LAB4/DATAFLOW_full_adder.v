module FA_dataflow(Cout, Sum, In1, In2, Cin);

input Cin, In1, In2;
output Cout, Sum;

assign {Cout, Sum} = In1 + In2 + Cin;

endmodule

module FA_dataflow_32bit(Cout, Sum, In1, In2, Cin);
input [31: 0] In1, In2;
output [31: 0] Sum;
input Cin;
wire [31: 0] carry;
output Cout;
assign carry[0] = Cin;

genvar j;
generate for (j = 0; j<32; j = j + 1) begin: FA_loop
    if (j == 31)
    begin
        FA_dataflow FAj(Cout, Sum[j], In1[j], In2[j], carry[j]);
    end

    else
    begin
        FA_dataflow FAj(carry[j + 1], Sum[j], In1[j], In2[j], carry[j]);
    end
end
endgenerate
endmodule

