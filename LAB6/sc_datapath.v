`include "full_adder.v"
`include "ALU.v"
`include "regfile.v"
`include "instruction_memory.v"
`include "main_control.v"
`include "data_memory.v"
`include "alu_control.v"
`include "sign_extender.v"
`include "left_shifter.v"

module SCDataPath(alu_output, PC, reset, clk);
    output [31:0] alu_output;
    input [31:0] PC;
    input reset, clk;

    wire [31:0] PCPlus4, readdata, write_data, instruction, Rs, Rt, ALUOut, writedata, sign_extended_offset, shifted_sign_extended_offset, ALU_source_2;
    wire RegDst, ALUSrc, MemtoReg,RegWrite, MemRead, MemWrite, Branch, cout;
    wire [1: 0] ALUOp;
    wire [2:0] ALUControl;
    wire [4: 0] write_register;
    wire [31:0] registers [3:0]; 


    //1. INSTRUCTION FETCH AND PC INCREMENT

    //FETCH THE INSTRUCTION FROM INSTRUCTION MEMORY
    instruction_memory IM(PC, clk, instruction);

    //PC = PC + 4
    full_adder_32bit PC_plus_4 (cout, PCPlus4, PC, 32'd4, 1'b0);

    //SIGN EXTEND THE OFFSET
    sign_extender SE(instruction[15:0], sign_extended_offset);

    //SHIFT THE SIGN EXTENDED OFFSET
    left_shifter SHIFT(sign_extended_offset, shifted_sign_extended_offset);

    //INITIALISE THE REGISTERS WITH THE REGISTER FILE
    regfile RF(clk, reset, registers);

    
module read_from_regfile(registers, readreg1, readreg2, readdata1, readdata2);

    //READ FROM THE REGISTERS [PASS RS AND RT OF INSTRUCTION]
    read_from_regfile Read_registers(registers, instruction[25:24], instruction[20:19], Rs, Rt);

    //MUX: RT OR RD TO WRITE PORT OF REGISTER FILE [PASS RT AND RD OF INSTRUCTION] [REGISTER CODE TRUNCATED TO 2 BITS INSTEAD OF 5 AS ONLY USING 4 REGISTERS]
    bit32_2to1mux RegDst_mux(write_register, RegDst, instruction[20: 19], instruction[15: 14]);
    
    //MUX: WRITE PC + 4 OR BRANCH TARGET TO PC
    bit32_2to1mux PcSrc_mux(PCPlus4, BranchTarget);
    
    //GET CONTROL SIGNALS FROM MAIN CONTROL [PASS OPCODE OF INSTRUCTION]
    Main_control Control(instruction[31: 26], RegDst, ALUSrc, MemtoReg,
RegWrite, MemRead, MemWrite, Branch, ALUOp[1], ALUOp[0]);

    //GET ALU CONTROL SIGNALS FROM ALU CONTROL [PASS FUNCT FIELAD OF INSTRUCTION]
    ALU_control Control_ALU(instruction[5:0], ALUOp, ALUControl);

    //MUX: RT OR SEO TO ALU
    bit32_2to1mux ALUSrc_MUX(ALU_source_2, ALUSrc, Rt, sign_extended_offset);

    //GET ALU OUTPUT
    ALU alu(Rs, ALU_source_2, ALUControl[2], ALUControl[2], ALUControl[1: 0], alu_output, cout);

    //WRITE DATA OR READ DATA FROM DATA MEMORY [ADDRESS IS OUTPUT OF ALU]
    data_memory DM(clk, alu_output, readdata, writedata, MemRead, MemWrite);


    //MUX: GET DATA TO WRIITE TO REGISTER FROM  MEMORY OUTPUT OF ALU OUTPUT
    bit32_2to1mux MemToReg_mux (write_data, MemtoReg, readdata, alu_output);

    //WRITE TO REGISTER FILE
    write_to_regfile Write_register(registers, write_register, write_data, RegWrite);


endmodule

module TestBench;
    wire [31:0] ALU_output;
    reg [31:0] PC;
    reg reset, clk;
    SCDataPath SCDP(ALU_output, PC,reset,clk);
    
    initial
        begin
            $monitor("at time %0d PC = %d, Reset = %d , CLK = %d , ALU Output = %d",$time, PC,reset,clk, ALU_output);
            #0 clk = 0; PC = 5;
            #120 reset = 1;
            #400 $stop;
        end
    always 
        begin
            #20 clk = ~clk; 
        end

endmodule