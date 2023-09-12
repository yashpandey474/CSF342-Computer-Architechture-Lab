module mealy(clock, reset, in, out);
    input clock, reset, in;
    output out;
    reg [1: 0] state;
    reg out;

    always @ (posedge clock, posedge reset)
        begin
            if (reset) 
            begin
                state <= 2'b00;
                out <= 0;
            end

            else
            begin
                case(state)
                2'b00:
                    begin
                        if (in)
                        begin
                            state <= 2'b01;
                            out <= 0;
                        end


                        else
                        begin
                            state <= 2'b10;
                            out <= 0;

                        end
                    end
                2'b01:
                    begin
                        if (in)
                        begin
                            state <= 2'b00;
                            out <= 1;
                        end


                        else
                        begin
                            state <= 2'b10;
                            out <= 0;
                        end
                    end
                2'b10:
                    begin
                        if (in)
                        begin
                            state <= 2'b01;
                            out <= 0;
                        end


                        else
                        begin
                            state <= 2'b00;
                            out <= 1;

                        end
                    end
                default:
                begin
                    state <= 2'b00;
                    out <= 0;
                end
                endcase

            end
        end
        endmodule
                        
