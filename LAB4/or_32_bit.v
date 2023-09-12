module bit32OR (out, in1, in2);
    input [31: 0] in1, in2;
    output [31: 0] out;

    assign out = in1 | in2;

endmodule


module tb32bitor;
    reg [31:0] INP1, INP2;
    wire [31:0] OUT;

    bit32OR or1(OUT, INP1, INP2);
    initial
    begin
        INP1 = 32'hA5A5;
        INP2 = 32'h5A5A;

        $monitor($time, "INP1 = %d, INP2 = %d OUT = %b", INP1, INP2, OUT);

        #100 INP1 = 32'h5A51;
        #400 $finish;
    end
endmodule