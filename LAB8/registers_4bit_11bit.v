`include "dFlipFlop.v"

module register_4bit(q, d, clock, clear);
    input [3: 0] d;
    input clock, clear;
    output [3: 0] q;

    genvar j;

    generate for (j = 0; j<4; j = j + 1) begin: register_loop
        d_ff dj(q[j], d[j], clock, clear);
    end
    endgenerate
endmodule

module register_11bit(q, d, clock, clear);
    input [10: 0] d;
    input clock, clear;
    output [10: 0] q;

    genvar j;
    generate for (j = 0; j<11; j = j + 1) begin: registe_loop_2
        d_ff dj2(q[j], d[j], clock, clear);
    end
    endgenerate
endmodule
