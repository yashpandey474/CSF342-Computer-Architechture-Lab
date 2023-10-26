//SET EVEN PARITY IF NUMBER OF ONES IN INPUT IS ODD
module even_parity_generator(aluOut, parity);

    input [3: 0] aluOut;
    output reg parity;

    always @ (*)
    begin
        parity = ^aluOut;
    end 

endmodule