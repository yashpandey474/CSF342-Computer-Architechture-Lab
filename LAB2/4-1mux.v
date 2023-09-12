module 4_1_mux(a0, a1, a2, a3, s0, s1, f);
    input a0, a1, a2, a3, s0, s1;
    output f;
    wire not_s1, not_s0, a0_and, a1_and, a2_and, a3_and;

    not n(not_s1, s1);
    not nn(not_s0, s0);

    and (a0_and, a0, not_s0, not_s1);
    and (a1_and, a1, s0, not_s1);

    and (a2_and, a2, not_s0, s0);
    and (a3_and, a3, s0, s1);

    or or1(f, a0_and, a1_and, a2_and, a3_and);

endmodule;