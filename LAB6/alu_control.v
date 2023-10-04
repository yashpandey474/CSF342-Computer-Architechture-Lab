module ALU_control (funct, ALUop, ALUcontrol);
    input [5:0] funct;
    input [1:0] ALUop;
    output [2:0] ALUcontrol;
    reg ALUcontrol;
    
    wire not1, not2, or1, and1, and2, or2, or3;

    or OR1(or1, funct[0], funct[3]);
    and AND1(ALUcontrol[0], ALUop[1], or1);
    and AND2(and2, ALUup[1], funct[1]);
    not NOT1(not1, ALUop[1]);
    not NOT2(not2, funct[2]);

    or OR2(ALUcontrol[1], not1, not2);
    or OR3(ALUcontrol[2], ALUop[0], and2);

endmodule