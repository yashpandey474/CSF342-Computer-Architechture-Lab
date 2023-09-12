reg a, b, c;
initial
fork
        #5 a = 1'b1;
        #10 b = 1'b0;
        #15 c = 1'b1;

join
