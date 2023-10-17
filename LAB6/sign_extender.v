module sign_extender(offset, sign_extended_offset);
input [0: 15] offset;
output [0: 31] sign_extended_offset;
reg [0: 31] sign_extended_offset;

always @ (offset)
begin
    if (offset[0])
        begin
            sign_extended_offset <= {16'hFFFF, offset};
        end

    else
        begin
            sign_extended_offset <= {16'b0, offset};
        end
end
endmodule