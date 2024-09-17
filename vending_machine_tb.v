

// test bench for vendgin machine
`timescale 1ms/1us
module vending_machine_tb();

// delcaring the reg and wires

       reg reset,clk;
	   reg [1:0]coin_in;
	   wire pre_out;

//module instantiation

       vending_machine  DUT(reset,clk,coin_in,pre_out);
	  
// task for initial values

       task initialize;
           begin
            clk = 0;
           end
       endtask

// generating clk

     always #1.954 clk =~clk;

// task for reset

       task reset_n;
            begin 
				 @(negedge clk)
					 reset =1'b1;
				 @(negedge clk)
					 reset =1'b0;
            end
       endtask

// driving inputs vending_machine

       task inputs(input [1:0]m);
             begin 	
			      @(negedge clk)
				  coin_in = m;
             end
       endtask

// giving values to stimulus

       initial
          begin
            initialize;
            reset_n;
            inputs(2'b00);
            inputs(2'b01);
            inputs(2'b00);
            inputs(2'b10);
            inputs(2'b01);
            inputs(2'b01);
			inputs(2'b00);
            inputs(2'b10);
            inputs(2'b01);
            inputs(2'b01);
			inputs(2'b11);
			#5010;
            inputs(2'b00); 
            inputs(2'b11); 			
          end
        initial
           $monitor("present = %b  pre_out = %b " ,DUT.present,pre_out);
		initial   
           #50000 $finish;
endmodule			
	   