//Op-code, operand A and operand B
// are read from the first pipeline register and given as input to the AL

module alu_4bit(operandA, operandB, opCode, out);
    input [3: 0] operandA;
    input [3: 0] operandB;
    input [2: 0] opCode;

    output reg [3: 0] out;

    always @ (*)
    begin
        case(opCode)
            3'b000: out = (operandA + operandB);
            3'b001: out = (operandA - operandB);
            3'b010: out = (operandA ^ operandB);
            3'b011: out = (operandA | operandB);
            3'b100: out = (operandA & operandB);
            3'b101: out = ~(operandA | operandB);
            3'b110: out = ~(operandA & operandB);
            3'b111: out = ~(operandA ^ operandB);
        endcase
    end
endmodule