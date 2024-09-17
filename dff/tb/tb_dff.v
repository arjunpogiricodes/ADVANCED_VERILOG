/********************************************************************************************
Copyright 2019 - Maven Silicon Softech Pvt Ltd. 
 
All Rights Reserved.

This source code is an unpublished work belongs to Maven Silicon Softech Pvt Ltd.

It is not to be shared with or used by any third parties who have not enrolled for our paid training 

courses or received any written authorization from Maven Silicon.


Webpage     :      www.maven-silicon.com

Filename    :	   tb_dff.v   

Description :      DFF Testbench

Author Name :      Susmita Nayak

Version     :      1.0
*********************************************************************************************/
module tb_dff;

   //Global variables declared for driving the DUT
   reg d0,d1,sel,rst,clk;
   wire q;
		
   //Define setup and hold time
   //Define clock time-period
   parameter THOLD  = 5,
	     TSETUP = 5,
	     CYCLE  = 100;

   //Step1 : Instantiate the dff design by order based

   dff DUT(d0,d1,sel,rst,clk,q);
  
  always
     begin 
     #(CYCLE/2);
     clk = 1'b0;
     #(CYCLE/2);
     clk =1'b1;
     end
  


   //Step2 : Write clock generation logic with period of 100ns
 /* task initilize;
	  begin
          clk=0;
         end
   endtask */
  
// always #50 clk =~clk;

 
   /*Step3 : Define the following tasks with self-checking features
             'sync_reset' for resetting the dff
             'load_d0' and 'load_d1' for loading input values */

    task sync_reset;
        begin
        rst =1'b1;
        d0 =1'b1;
        d1 =1'b1;
        sel=$random;
      @(posedge clk)
      #(THOLD);
      if(q !== 0)
        begin
        $display(" RESET IS NOT WORKING ");
        $display(" ERROR at TIME = %t ",$time);
        $stop;
        end
      	
        $display(" RESET IS  WORKING ");
        //$display(" ERROR at TIME = %t ",$time);
        rst = 1'bx;
        d0 =1'bx;
        d1 =1'bx;
        sel=2'bx;
	#(CYCLE-THOLD-TSETUP);
        end
     endtask

   task load_d0;
   input reg data;
   begin
      rst =1'b0;
      d0 = data;
      d1 =~data;
      sel=1'd0;
      @(posedge clk)
      #(THOLD);
      if(q !== data)
       begin
       $display(" LOAD DO IS not WORKING ");
       $display(" ERROR at TIME = %t ",$time);
       $stop;
       end
       
       $display(" LOAD DO IS  WORKING ");

       d0 = 1'bx;
       d1 = 1'bx;
       rst = 1'bx;
       	#(CYCLE-THOLD-TSETUP);

    end
    endtask
    
   task load_d1;
   input reg data;
   begin
      rst =1'b0;	   
      d1 = data;
      d0 =~data;
      sel = 1'd1;
      @(posedge clk)
      #(THOLD);
      if(q !== data)
       begin
       $display(" LOAD D1 IS not WORKING ");
       $display(" ERROR at TIME = %t ",$time);
       $stop;
       end

      $display(" LOAD D1 IS  WORKING ");

       d0 = 1'bx;
       d1 = 1'bx;
       rst = 1'bx;
       	#(CYCLE-THOLD-TSETUP);

    end
    endtask
    

     	       

   //Process to generate stimulus by calling the tasks & passing values
   initial
      begin         
	 sync_reset;
	 load_d0(1'b1);
	 sync_reset;
	 load_d1(1'b1);
	 load_d0(1'b0);
	 load_d1(1'b0);
	 load_d1(1'b1);
	 load_d0(1'b0);
	 load_d1(1'b0);
	 load_d1(1'b1);
	 load_d0(1'b0);
	 load_d1(1'b0);
	 load_d1(1'b1);
	 load_d0(1'b0);
	 load_d1(1'b0);
	 
	 sync_reset;   
	 #1000 $finish;
      end       
			
		
			
endmodule
