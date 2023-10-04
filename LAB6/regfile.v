module mux4_1(regData, q1, q2, q3, q4, reg_no); //Tested
    input [31:0] q1, q2, q3, q4;
    output reg [31:0] regData;
    input [1:0] reg_no;

    //wire not_sel1, not_sel0; 
    //Correction 1: What is the use of this? Select line is reg_no right? Have commented this

    //always @(reg_no[0] or reg_no[1]) 
    //Correction 2: The always block should also run when any of the input data is also changed i.e. q1-q4
    //Replaced the code with always @(*)
    
    always @ (*)
    begin
        case (reg_no) 
            2'b00: regData <= q1;
            2'b01: regData <= q2;
            2'b10: regData <= q3;
            2'b11: regData <= q4; 
        endcase
    end
endmodule;

module decoder2_4 (register, reg_no); //Tested
    input [1:0] register;
    output [3:0] reg_no;

    wire not_r0, not_r1;

    not n1(not_r0, register[0]);
    not n2(not_r1, register[1]);

    and a1(reg_no[0], not_r0, not_r1);
    and a2(reg_no[1], register[0], not_r1); 
    and a3(reg_no[2], not_r0, register[1]);
    and a4(reg_no[3], register[0], register[1]);

endmodule

module d_ff(q, d, clock, clearb); //Tested
    input d, clearb, clock;
    output q;
    reg q;
    always @ (posedge clock) 
    begin
        if (!clearb) q <= 1'b0;
        else q <= d; 
    end
endmodule

module reg_32bit (q, d, clk, reset); //Tested
    input [31:0] d;
    output [31:0] q;
    input clk, reset;

    genvar j;

    generate for (j = 0; j < 32; j = j + 1) begin: register_loop
        d_ff dj(q[j], d[j], clk, reset);
    end
    endgenerate
endmodule


module regfile(clk, reset, readreg1, readreg2, writedata, writereg,
regWrite, readdata1, readdata2);


    input clk, reset, regWrite;
    output [31:0] readdata1, readdata2; //Data read
    input [31:0] writedata; //Data to be written
    input [1:0] writereg, readreg1, readreg2; //Addresses 

    //wire [3: 0][31: 0] registers; 
    //Correction 3: This is a wrong way of creating memory (or arrays) in Verilog. 
    //Use the following Syntax.
    wire [31:0] registers [3:0]; 
    //[31:0] defines the no of bits in each register and [3:0] specify the number of registers.
    //This defines an array of 4 registers each with 32 bits.
    //Each element of array (a register in this case) can be accessed using registers[0], registers[1] and so on..

    wire [3:0] signals; //Write Enable Signals
    wire [3:0] clocks; 

    //Write Logic:    
    decoder2_4 decode1 (writereg, signals); //Seems correct

    genvar j;
    generate for (j = 0; j < 4; j = j + 1) begin: reg_loop
        and aj(clocks[j], clk, regWrite, signals[j]);
        reg_32bit regj (registers[j], writedata, clocks[j], reset);
    end
    endgenerate

    //Read Logic: 
    mux4_1 mux1(readdata1, registers[0], registers[1], registers[2], registers[3], readreg1);
    mux4_1 mux2(readdata2, registers[0], registers[1], registers[2], registers[3], readreg2);

endmodule;