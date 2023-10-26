`include "alu_4bit.v"
`include "encoder_8to3.v"
`include "evenParityGenerator.v"
`include "register_4bit_11bit.v"

module pipelineDatapath_3stage(
    functionCode, parityOutput, clock, reset,
    operandA, operandB
);
    input [7: 0] functionCode;
    input [3: 0] operandA, operandB;
    input clock, reset;
    output parityOutput;

    wire [2: 0] encodedOutput;
    wire [10: 0] register1Output;
    wire [3: 0] aluOut, register2Output;

    register_11bit Reg1(register1Output, {encodedOutput, operandA, operandB}, clock, clear);
    encoder_8to3 Encoder(functionCode, encodedOutput);
    alu_4bit ALU(operandA, operandB, encodedOutput, aluOut);
    register_4bit Reg2(register2Output, aluOut);
    even_parity_generator EPG(aluOut, parityOutput);

endmodule