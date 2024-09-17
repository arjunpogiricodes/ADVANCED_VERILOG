

// pattern printing 
/* 0000_0001,0000_0010,0000_0001,0000_0100.....1000_0000,0000_0001*/

module pattern(reset,clk,out);

// declaring the input and output ports

      input clk,reset;
	  output  [7:0]out;

// declaraing the regs for pattern recognize

      reg [7:0]pre,next;

// logic for update the pattern 

    always@(posedge clk)
           begin
                if(reset)
                        next <= 8'd1;
				else if(next[0] == 1)
                        next <= pre;
                else
                        next <= 8'd1;				
			end


// logic for shift after 0000_0001 state using next[0] bit

    always@(posedge clk)
            begin
                 if(reset)
                         pre <= 8'd1;
                 else if(next[0] == 1)
                         pre <= pre << 1;
                 else if(pre [7] == 1)
                         pre <= 8'd2;
                 else
                         pre <= pre;
            end
			
/*
    always@(posedge clk)
            begin
                 if(reset)
                         pre <= 8'd1;
                 else if(next[0] == 1)
                         pre <= pre ;
                 else if(pre [7] == 1)
                         pre <= 8'd2;
                 else
                         pre <= pre<<1'b1;
            end			

*/
			
    assign out = next;

endmodule	