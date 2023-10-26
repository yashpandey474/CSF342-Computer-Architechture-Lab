module d_ff(q, d, clock, clearb);
    input d, clearb, clock;
    output reg q;

    always @ (posedge clock) 
    begin
        if (!clearb) q <= 1'b0;
        else q <= d; 
    end
endmodule