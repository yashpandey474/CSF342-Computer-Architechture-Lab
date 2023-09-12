module jk_flip_flop(clock, j, k, out);
    input j, k, clock;
    output reg out;

    always @ (posedge clock)
    begin
        case ({j, k}) 
            2'b00: out <= out;
            2'b01: out <= 1'b0;
            2'b10: out <= 1'b1;
            2'b11: out <= ~out; 
        endcase
    end
endmodule

module 4_bit_counter(clock);
    input clock;
    output reg q0, q1, q2, q3;
    reg and_1, and_2;

    jk_flip_flop jk1(clock, a, b, q0);
    jk_flip_flop jk2(clock, q0, q0, q1);
    and(and_1, q0, q1);
    jk_flip_flop jk3(clock, and_1, and_1, q2);
    and(and_2, q2, and_1);
    jk_flip_flop jk4 (clock, and_2, and_2, q3);

endmodule



module testbench;
    reg clock;
    reg a, b;
    wire q3, q0, q1, q2, and_1, and_2;
    
    
    initial
    forever begin
        #5 clock = ~clock;
    end
        

    initial
    begin
        clock = 0;
        $monitor($time, "CLOCK = %b, COUNT = %b", clock, q0);
        #5 a=1'b0; b=1'b1;
        #15 a=1'b1; b=1'b0;
        #30 $finish;
    end

endmodule
