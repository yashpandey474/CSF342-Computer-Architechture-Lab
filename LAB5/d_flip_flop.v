module d_ff(q, d, clk, reset);
    input clk, reset, d;
    output reg d;

    always @ (posedge clk)
    begin
        case (d) 
            1'b0: q <= ~q;
            1'b1: q <= q; 
        endcase
    end
endmodule
