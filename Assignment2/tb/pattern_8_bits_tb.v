


// pattern printing  test bench
/* 0000_0001,0000_0010,0000_0001,0000_0100.....1000_0000,0000_0001*/


module pattern_tb();

// declaring the input and output ports

      reg clk,reset;
	  wire  [7:0]out;
	  
// instantiating 

    pattern DUT(reset,clk,out);	  
	
// task for reset 

    task reset_n;
         begin
          @(negedge clk)
            reset =1'b1;
          @(negedge clk)
            reset =1'b0;
         end
     endtask

// iniitlize the initial values

    task initialize;
         begin    
            clk=0;
         end
     endtask

// generating clock

    always #10 clk = ~clk;

// generating stimulus

     initial
         begin 
             initialize;
             reset_n;
			 $monitor(" dut present =%b next state = %b " ,DUT.pre,DUT.next);
			 #1000 $finish;
         end
		 
endmodule		 
		 
	
	  
	  