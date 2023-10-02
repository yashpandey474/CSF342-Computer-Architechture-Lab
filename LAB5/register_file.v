module mux4_1(regData, q1, q2, q3, q4, reg_no);
    input [31: 0] q1, q2, q3, q4;
    output reg [31: 0]  regData;
    input [1:0] reg_no;


    wire not_sel1, not_sel0;

    always @(reg_no[0] or reg_no[1])
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
    input [1: 0] register;
    output [3: 0] reg_no;

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
    output [31: 0] q;
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
    output [31: 0] readdata1, readdata2;
    input [31: 0] writedata;
    input [1: 0] writereg, readreg1, readreg2;

    wire [3: 0][31: 0] registers;
    wire [3: 0] signals;
    wire [3: 0] clocks;
    decoder2_4 decode1(writereg, signals);

    genvar j;
    generate for (j = 0; j< 4; j = j + 1) begin: reg_loop
        and aj(clocks[j], clk, regWrite, signals[j]);
        reg_32bit regj (registers[j], writedata, clocks[j], reset);
    end
    endgenerate

    mux4_1 mux1(readdata1, registers[0], registers[1], registers[2], registers[3], readreg1);
    mux4_1 mux2(readdata2, registers[0], registers[1], registers[2], registers[3], readreg2);

endmodule;

module regfile_tb;
    reg regWrite, clk,reset;
    reg [1: 0] readreg1, readreg2, writereg;
    reg [31: 0] writedata;
    wire [31:0] readdata1, readdata2;
    regfile rf(clk, reset, readreg1, readreg2, writedata, writereg,
    regWrite, readdata1, readdata2
    );
    

    always @(clk)
        #5 clk<=~clk;
    initial
    begin
        $monitor($time, "READREG1 = %b, READREG2 = %b WRITEREG = %b, REGWRITE = %b, READDATA1 = %b, READDATA2 = %b CLOCK = %b RESET = %b", readreg1, readreg2, writereg, regWrite, readdata1, readdata2, clk, reset);
        clk= 1'b1;
        reset=1'b0;//reset the register
        #10 readreg1 = 2'b00; readreg2 = 2'b01; writereg = 2'b10; regWrite = 1'b0;
        #20 regWrite = 1'b1;
        #30 writedata = 32'd1000;
        #200 $finish;
    end

endmodule