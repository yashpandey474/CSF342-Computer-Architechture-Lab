module mux2to1 (out, sel, in1, in2);
    input in1, in2, sel;
    output out;

    wire not_sel, a1, a2;

    not(not_sel, sel);
    and(a1, sel, in2);
    and(a2, not_sel, in1);

    or (out, a1, a2);

endmodule;

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

module testbench;
    reg[7:0] INP1, INP2;
    reg SEL;

    wire [7:0] out;
    bit8_2to1mux MUX(out, SEL, INP1, INP2);

    initial
    begin
        
        INP1 = 8'b10101010;
        INP2 = 8'b01010101;
        SEL = 1'b0;
        $monitor($time, "INP1 = %b, INP2 = %b SEL = %b OUT = %b", INP1, INP2, SEL, out);

        #100 SEL = 1'b1;
        #1000 $finish;
    end
endmodule