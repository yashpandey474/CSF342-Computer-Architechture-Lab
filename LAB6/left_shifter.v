module left_shifter(sign_extended_offset, shifted_offset);
    input [0: 31] sign_extended_offset;
    output [0: 31] shifted_offset;
    reg [0: 31] shifted_offset;

    always @ (*)
    begin
        shifted_offset = {sign_extended_offset, 2'b00};
    end
endmodule