module multicycle_control(clock, opcode, state, MemRead, ALUSrcA, IorD, IRWrite, ALUSrcB, PCWrite, PCSource, ALUOp)

output reg PCWriteCond, MemtoReg,  MemRead, MemWrite, RegWrite, RegDst, IorD, IRWrite, PCWrite, ALUSrcA;
output reg [1: 0] ALUOp;
output reg [1: 0] ALUSrcB, PCSource;
input [5: 0] opcode;
input reg [3: 0] state;
input clock;
parameter FETCH = 4'd0, DECODE = 4'd1, BRANCH_COMPLETION = 4'd2, R_TYPE_COMPLETION = 4'd3, R_TYPE_EXE = 4'd4, JUMP_COMPLETION = 4'd5, ADDRESS_COMPUTATION: 4'd6, MEMORY_READ = 4'd7, MEMORY_WRITE = 4'd8, WRITE_BACK = 4'd9; 

FETCH:
begin
    MemRead = 1'b1;
    ALUSrcA = 1'b0;
    ALUSrcB = 2'b01;
    ALUOp = 2'b00;
    PCWrite = 1'b1;
    PCSource = 2'b00;
    IRWrite = 1'b1;
    IorD = 1'b0;
end

DECODE:
begin
    ALUSrcA = 1'b0;
    ALUSrcB = 2'b11;
    ALUOp = 2'b00;
end

JUMP_COMPLETION:
begin
    PCWrite = 1'b1;
    PCSource = 2'b10;
end

BRANCH_COMPLETION:
begin
    ALUSrcA = 1'b1;
    ALUSrcB = 2'b00;
    ALUOp = 2'b01;
    PCWriteCond = 1'b1;
    PCSource = 2'b01;
end

R_TYPE_EXE:
begin
    ALUSrcA = 1'b1;
    ALUSrcB = 2'b00;
    ALUOp = 2'b10;
end

R_TYPE_COMPLETION:
begin
    RegDst = 1'b1;
    RegWrite = 1'b1;
    MemtoReg = 1'b0;
end

ADDRESS_COMPUTATION:
begin
    ALUSrcA = 1'b1;
    ALUSrcB = 2'b10;
    ALUOp = 2'b00;
end

MEMORY_READ:
begin
    MemRead = 1'b1;
    IorD = 1'b1;
end

WRITE_BACK:
begin
    RegDst = 1'b0;
    RegWrite = 1'b1;
    MemtoReg = 1'b1;
end
    
MEMORY_WRITE:
begin
    MemWrite = 1'b1;
    IorD = 1'b1;
end

always @ (posedge clock)
begin
case(state)
    FETCH: next_state = DECODE;

    DECODE:case(opcode)
        6'b100011: next_state = ADDRESS_COMPUTATION; //LW
        6'b101011: next_state = ADDRESS_COMPUTATION; //SW
        6'b000000: next_state = R_TYPE_EXE; //R-TYPE
        6'b000100: next_state = BRANCH_COMPLETION; //BEQ
        default: next_state = FETCH;
    endcase

    ADDRESS_COMPUTATION: case(opcode)
        6'b100011: next_state = MEMORY_READ; //LW
        6'b101011: next_state = MEMORY_WRITE; //SW
        default: next_state = FETCH;
    endcase     

    MEMORY_READ: next_state = WRITE_BACK;
    
    MEMORY_WRITE: next_state = FETCH;
    
    WRITE_BACK: next_state = FETCH;
    
    BRANCH_COMPLETION: next_state = FETCH;
    
    R_TYPE_EXE: next_state = R_TYPE_COMPLETION;
    
    R_TYPE_COMPLETION: next_state = FETCH;
    
    JUMP_COMPLETION: next_state = FETCH;
endcase
end


endmodule