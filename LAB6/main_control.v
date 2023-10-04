module Main_control(op, RegDst, ALUSrc, MemtoReg,
RegWrite, MemRead, MemWrite, Branch, ALUOp1, ALUOp2);

    input [5:0] op;
    output reg RegDst, ALUSrc, MemtoReg,RegWrite, MemRead, MemWrite, Branch, ALUOp1, ALUOp2;

    always @(op)
    begin
        case(op)
            //R-TYPE
            6'b000000: RegDst <= 1; ALUSrc <= 0; MemtoReg <= 0; RegWrite <= 1; MemRead <= 0; MemWrite <= 0; Branch <= 0; ALUOp1 <= 1; ALUop2 <= 0;
            //LOAD WORD
            6'b100011: RegDst <= 0; ALUSrc <= 1; MemtoReg <= 1; RegWrite <= 1; MemRead <= 1; MemWrite <= 0; Branch <= 0; ALUOp1 <= 0; ALUop2 <= 0;
            //STORE WORD
            6'b101011: RegDst <= 1; ALUSrc <= 1; MemtoReg <= 1; RegWrite <= 1; MemRead <= 0; MemWrite <= 1; Branch <= 0; ALUOp1 <= 0; ALUop2 <= 0;
            //BRANCH
            6'b000100: RegDst <= 1; ALUSrc <= 0; MemtoReg <= 1; RegWrite <= 0; MemRead <= 0; MemWrite <= 0; Branch <= 1; ALUOp1 <= 0; ALUop2 <= 1;
        endcase
    end
endmodule;
