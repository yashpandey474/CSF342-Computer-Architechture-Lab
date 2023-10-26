module PLA_multi_cycle_control(
    opcode,
    currState,
    PCWrite, 
    PCWriteCond,
    IorD, MemRead, MemWrite, IRWrite,
    MemtoReg, PCSource1, PCSource0,
    ALUOp1, ALUOp0, ALUSrcB1, ALUSrcB0,
    ALUSrcA, RegWrite, RegDst;

);
input [5: 0] opcode;
input [3: 0] currState;
output [3: 0] nextState;

output PCWrite, PCWriteCond, IorD, MemRead, MemWrite, IRWrite, MemtoReg, PCSource1, PCSource0, ALUOp1, ALUOp0, ALUSrcB1, ALUSrcB0, ALUSrcA, RegWrite, RegDst;

//PUT LOGIC OF NOTS, ANDS AND ORS
wire [16: 0] lines;

always @ (*)
begin
    lines[0] = (~currState[3]) & (~currState[2]) & (~currState[1]) &(~currState[0]);
    lines[1] = (~currState[3]) & (~currState[2]) & (~currState[1]) &(currState[0]);
    lines[2] = (~currState[3]) & (~currState[2]) & (currState[1]) &(~currState[0]);
    lines[3] = (~currState[3]) & (~currState[2]) & (currState[1]) &(currState[0]);
    lines[4] = (~currState[3]) & (currState[2]) & (~currState[1]) &(~currState[0]);
    lines[5] = (~currState[3]) & (currState[2]) & (~currState[1]) &(currState[0]);
    lines[6] = (~currState[3]) & (currState[2]) & (currState[1]) &(~currState[0]);
    lines[7] = (~currState[3]) & (currState[2]) & (currState[1]) &(currState[0]);
    lines[8] = (currState[3]) & (~currState[2]) & (~currState[1]) &(~currState[0]);
    lines[9] = (~currState[3]) & (currState[2]) & (currState[1]) &(currState[0]);

    lines[12] = (~currState[3]) & (~currState[2]) & (~currState[1]) &(currState[0]);
    lines[13] = (~currState[3]) & (~currState[2]) & (currState[1]) &(~currState[0]);
    lines[14] = (~currState[3]) & (~currState[2]) & (~currState[1]) &(currState[0]);
    lines[15] = (~currState[3]) & (~currState[2]) & (~currState[1]) &(currState[0]);
    lines[16] = (~currState[3]) & (~currState[2]) & (currState[1]) &(~currState[0]);
    
end


endmodule