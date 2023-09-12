module full_adder(input_1, input_2, carry_in, sum, carry_out);
    input input_1, input_2, carry_in;
    output reg sum, carry_out;

    always@ (input_1 or input_2 or carry_in)
    begin   
        sum = (input_1 + input_2 + carry_in)%2;
        carry_out = (input_1 + input_2 + carry_in)/2;
        // {carry_out, sum} = (input_1 + input_2 + carry_in);
    end
endmodule

module full_adder_subtractor(input_1, input_2, borrow_in, difference, borrow_out, m);
    input input_1, input_2, borrow_in, m;
    output reg difference, borrow_out;

    always@ (input_1 or input_2 or borrow_in)
    begin   
        if (m === 0) 
        begin
             difference = (input_1 + input_2 + borrow_in)%2; borrow_out = (input_1 + input_2 + borrow_in)/2;
        end
        
        else begin
             difference = (input_1 - input_2 - borrow_in);
             if (difference >= 0)
             begin
                borrow_out = 0;
             end
             else
             begin
                borrow_out = 1;
                difference = -difference;
             end
        end
    end
endmodule

module testbench;
    reg input_1, input_2, carry_in, m;
    wire sum, carry_out;

    // full_adder f1(input_1, input_2, carry_in,sum, carry_out );
    full_adder_subtractor f2(input_1, input_2, carry_in, sum, carry_out, m);

    initial
    begin
        $monitor($time," a=%b, b=%b, cin=%b, m = %b, sum=%b, cout=%b",input_1,input_2,carry_in, m, sum,carry_out);
        #0 input_1=1'b0;input_2=1'b1;
        #2 carry_in=1'b1; m = 1'b1;
        #5 carry_in=1'b0; m = 1'b0;
        #10 input_1=1'b1;input_2=1'b0; //2'b11, 2'd3
        #15 carry_in=1'b1; m = 1'b1;
        #20 carry_in=1'b0; m = 1'b0;
        #100 $finish;
    end
endmodule
