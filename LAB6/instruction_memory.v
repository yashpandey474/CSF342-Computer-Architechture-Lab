module instruction_memory(PC, clock, instruction);
    //EACH INSTRUCTION: 32 BITS
    //SAY, MEMORY HOLDS 3 INSTRUCTIONS

    input [31:0] PC;
    output [31:0] instruction;
    
    reg [31: 0] memory [31: 0];
    reg [31: 0] instruction;

    //INTEGER FOR INDEX IN MEMORY CORRRESPONDING TO VALUE IN PC REGISTER
    integer address;
    initial begin
        memory[0]  = 32'd0; //NOP
        memory[1] = 32'd0; //NOP
        memory[2] = 32'b10001100000100010000000000001000;
    end

    always @(posedge clock) begin
        address = PC[31: 0];
        instruction = memory[address/4];
    end

endmodule