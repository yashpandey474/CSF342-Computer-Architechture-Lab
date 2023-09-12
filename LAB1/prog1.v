// GATE LEVEL MODELLING
module mux2to1_gate(a, b, s, f);
    input a, b, s;
    output f;
    wire c, d, e;

    not n1(not_s, s);
    and a1(a_and_s, a, s);
    and a2(b_and_s, b, s);
    or o1(f, a_and_s, b_and_s);
endmodule

//DATA FLOW MODELLING
module mux2to1_df(a, b, s, f);
    input a,b,s;
    output f;
    assign f = s ? a: b;
endmodule

// BEHAVIOURAL MODELLING
module mux2to1_beh(a, b, s, f);
    input a, b, s;
    output f;
    reg f;
    always@ (s or a or b)
        if(s == 1) f = a;
        else f = b;
endmodule

// TESTBENCH
module testbench;
    reg  a, b, s;
    wire f;

    mux2to1_gate mux_gate(a, b, s, f);
    initial
        begin
            $monitor (, $time, " a = %b, b = %b, s = %b, f = %b", a, b, s, f);
            #0 a = 1'b0;b=1'b1;
            #2 s = 1'b1;
            #5 s = 1'b0;
            #10 a = 1'b1;b=1'b0;
            #15 s = 1'b1;
            #20 s = 1'b0;
            #100 $finish;
        end

    initial
        begin
            $dumpfile("waveform.vcd"); 
            $dumpvars;
        end
endmodule

