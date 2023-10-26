//8-bit function code of the operation to be performed in the instruction is given as
//input to the encoder, encoder encodes the function code and outputs the
//corresponding 3-bit op-code

module encoder_8to3(functionCode, encodedOutput);
    input [7: 0] functionCode;
    output reg [2: 0] encodedOutput;

    always @ (*)
    begin
        case(functionCode)
            8'b00000000: encodedOutput = 3'd0;
            8'b00000010: encodedOutput = 3'd1;
            8'b00000100: encodedOutput = 3'd2;
            8'b00001000: encodedOutput = 3'd3;
            8'b00010000: encodedOutput = 3'd4;
            8'b00100000: encodedOutput = 3'd5;
            8'b01000000: encodedOutput = 3'd6;
            8'b10000000: encodedOutput = 3'd7;
            default: encodedOutput = 3'd0;
        endcase
    end
endmodule