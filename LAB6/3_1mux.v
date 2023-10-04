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