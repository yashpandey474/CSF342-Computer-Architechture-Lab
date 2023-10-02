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

module tb32reg;
    reg [31:0] d;
    reg clk,reset;
    wire [31:0] q;
    reg_32bit R(q,d,clk,reset);

    always @(clk)
        #5 clk<=~clk;
    initial
    begin
        $monitor($time, "D = %b, Q = %b, CLK = %b, RESET = %b", d, q, clk, reset);

        clk= 1'b1;
        reset=1'b0;//reset the register
        #20 reset=1'b1;
        #20 d=32'hAFAFAFAF;
        #50 d = 10'd100;
        #200 $finish;
    end
endmodule