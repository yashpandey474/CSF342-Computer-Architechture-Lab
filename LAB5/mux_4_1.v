module mux4_1(regData, q1, q2, q3, q4, reg_no);
    input [31: 0] q1, q2, q3, q4;
    output [31: 0] regData;
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