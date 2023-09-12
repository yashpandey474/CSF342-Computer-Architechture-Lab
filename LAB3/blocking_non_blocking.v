module nonblocking(in, clk, out);
    input in, clk;
    output out;
    reg q1, q2, out;

    always @ (posedge clk)
        begin
            q1 <= in;
            q2 <= q1;
            out <= q2;

        end

endmodule


module blocking(in, clk, out);
    input in, clk;
    output out;
    reg q1, q2, out;

    always @ (posedge clk)
        begin
            q1 = in;
            q2 = q1;
            out = q2;
        end

endmodule

