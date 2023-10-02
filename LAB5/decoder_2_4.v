module decoder2_4 (register, reg_no);
    input [1: 0] register;
    output [3: 0] reg_no;

    wire not_r0, not_r1;

    not n1(not_r0, register[0]);
    not n2(not_r1, register[1]);

    and a1(reg_no[0], not_r0, not_r1);
    and a2(reg_no[1], register[0], not_r1);
    and a3(reg_no[2], not_r0, register[1]);
    and a4(reg_no[3], register[0], register[1]);
endmodule