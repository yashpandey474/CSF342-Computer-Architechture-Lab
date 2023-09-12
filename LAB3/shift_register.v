module shiftreg(enable, in, clock, out);
    parameter n = 4;
    input enable, in, clock;
    output reg [n - 1: 0] out;

    initial
        out = 4'd10;

        always @ (posedge clock)
            begin
                if (enable) out = {in, out[n - 1: 1]};
            end
endmodule


    