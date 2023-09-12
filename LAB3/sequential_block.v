reg a, b, c;
initial
    begin
            a = 1'b1;
            b = 1'b0;
            c = 1'b1;
    end


reg a, b, c;
initial
    begin
        #5 a = 1'b1;
        #10 b = 1'b0;
        #15 c = 1'b1;

    end

