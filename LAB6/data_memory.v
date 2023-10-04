module data_memory(address, readdata, writedata, memread, memwrite);
    input memread, memwrite;
    input [31: 0] address, writedata;
    output [31: 0] readdata;

    reg readdata;
    reg [31: 0] memory [31: 0];
    integer addr;
    initial begin
        memory[0] = 32'd100;
        memory[1] = 32'd1000;
        memory[2] = 32'd500;
    end

    always @(posedge clock) begin
        addr = address[31: 0];
        if (memread)begin
            readdata = memory[addr/4];
        end

        if (memwrite) begin
            memory[addr/4] = writedata;
        end
    end

endmodule
