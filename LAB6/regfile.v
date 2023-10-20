module mux4_1(regData, q1, q2, q3, q4, reg_no);
    input [31:0] q1, q2, q3, q4;
    output reg [31:0] regData;
    input [1:0] reg_no;
    
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

module decoder2_4 (register, reg_no);
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

module d_ff(q, d, clock, clearb);
    input d, clearb, clock;
    output q;
    reg q;
    always @ (posedge clock) 
    begin
        if (!clearb) q <= 1'b0;
        else q <= d; 
    end
endmodule

module reg_32bit (q, d, clk, reset);
    input [31:0] d;
    output [31:0] q;
    input clk, reset;

    genvar j;

    generate for (j = 0; j < 32; j = j + 1) begin: register_loop
        d_ff dj(q[j], d[j], clk, reset);
    end
    endgenerate
endmodule



module read_from_regfile(readreg1, readreg2, readdata1, readdata2); 
    input [1:0] readreg1, readreg2;
    output [31:0] readdata1, readdata2;
    wire [31:0] registers [3:0]; 

    mux4_1 mux1(readdata1, registers[0], registers[1], registers[2], registers[3], readreg1);
    mux4_1 mux2(readdata2, registers[0], registers[1], registers[2], registers[3], readreg2);

endmodule

module write_to_regfile(writereg, writedata, regWrite, clk);

    input clk;
    input [1:0] writereg;
    input [31:0] writedata;
    wire [31:0] registers [3:0]; 
    input regWrite;

    wire [3:0] signals;
    wire [3:0] clocks; 

    decoder2_4 decode1 (writereg, signals);

    genvar j;
    generate for (j = 0; j < 4; j = j + 1) begin: reg_loop
        and aj(clocks[j], clk, regWrite, signals[j]);
        reg_32bit regj (registers[j], writedata, clocks[j], reset);
    end
    endgenerate

endmodule

module RegFile_Final (readreg1, readreg2, readdata1, readdata2, writereg, writedata, regWrite, clk, reset); 

    input [1:0] readreg1, readreg2;
    output [31:0] readdata1, readdata2;
    
    wire [31:0] registers [3:0];

    mux4_1 mux1(readdata1, registers[0], registers[1], registers[2], registers[3], readreg1);
    mux4_1 mux2(readdata2, registers[0], registers[1], registers[2], registers[3], readreg2);

    input clk, reset;
    input [1:0] writereg;
    input [31:0] writedata;
    input regWrite;
    wire [3:0] signals; 
    wire [3:0] clocks; 

    decoder2_4 decode1 (writereg, signals);

    genvar j;
    generate for (j = 0; j < 4; j = j + 1) begin: reg_loop
        and aj(clocks[j], clk, regWrite, signals[j]);
        reg_32bit regj (registers[j], writedata, clocks[j], reset);
    end
    endgenerate

endmodule


module testbench_regfile;

    reg [1:0] readreg1, readreg2, writereg; 
    reg regWrite, clk, reset;
    reg [31:0] writedata;
    wire [31:0] readdata1, readdata2;

    RegFile_Final DUT (readreg1, readreg2, readdata1, readdata2, writereg, writedata, regWrite, clk, reset);

    initial begin
        reset = 0;
        regWrite = 1'b1;
        #3 reset = 1;
    end

    initial begin
        clk = 0;
        forever begin
            #2 clk = ~clk;
        end 
    end

    initial begin 
        #4 writereg = 2'b00; writedata = 32'h1234;
        #4 writereg = 2'b01; writedata = 32'h4567;
        #4 writereg = 2'b10; writedata = 32'h89AB;
        #4 writereg = 2'b11; writedata = 32'hCDEF;

        #1 readreg1 = 2'b00; readreg2 = 2'b01;
        #1 readreg1 = 2'b10; readreg2 = 2'b11;
    end

    initial begin
        $monitor ($time, " READ:: readreg1 = %b, readreg2 = %b, readdata1 = %h, readdata2 = %h ::: Clock = %b, Reset = %b", readreg1, readreg2, readdata1, readdata2, clk, reset);
        #20 $finish;
    end

endmodule