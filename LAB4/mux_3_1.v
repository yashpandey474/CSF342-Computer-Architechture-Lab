module mux2to1 (out, sel, in1, in2);
    input in1, in2, sel;
    output out;

    wire not_sel, a1, a2;

    not(not_sel, sel);
    and(a1, sel, in2);
    and(a2, not_sel, in1);

    or (out, a1, a2);

endmodule;


module mux3to1 (out, sel1, sel2, in1, in2, in3);
    input in1, in2, in3, sel;
    output out;


    wire out1;

    mux2to1 m1(out1, sel1, in1, in2);
    mux2to1 m2(out, sel2, out1, in3);
    
endmodule;