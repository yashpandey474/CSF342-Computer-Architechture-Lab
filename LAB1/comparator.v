module 4bit_comparator(a, b, g, l, e);
    input a, b;
    output g, l, e;
    assign g = a > b ? 1 : 0;
    assign l = a < b ? 1: 0;
    assign e = a == b ? 1: 0;

endmodule


// TESTBENCH
module testbench;
    reg  a, b;
    wire g, l, e;

    4bit_comparator comparator(a, b, g, l, e);
    initial
        begin
            $monitor (, $time, " a = %b, b = %b, g = %b, l = %b, e = %b", a, b, g, l, e);
            #0 a = 1;b=1;
            #2 a = 0; b = 1;'
            #4 a = 1; b = 0
            #100 $finish;
        end

    initial
        begin
            $dumpfile("waveform1.vcd"); 
            $dumpvars;
        end
endmodule