


module dual_port_ram_tb ();

                       reg clk,reset;
                       reg [7:0]data_in;
                       reg we_enb,re_enb;
                       reg [3:0]rd_addr,wr_addr;
                       wire [7:0]data_out;
                       reg [7:0]temp;
           parameter THOLD=5,
		     TSETUP=5,
		     CYCLE = 50;   		       

//instantiating module

   dual_port_ram DUT(clk,reset,data_in,we_enb,re_enb,rd_addr,wr_addr,data_out);
 
// creating task for initilize the values
   
     task initialize;
	     begin
		 clk = 0;
            end
     endtask

// generating clk 

   always #CYCLE clk = ~clk;

// CREATING TASK FOR RESET
 
   task sync_reset;
	   begin
               reset = 1'b0;
	      @(posedge clk)
	      #(THOLD);
	      if(data_out !== 0)
	          begin
                     $display(" RESET IS NOT WORKING");
		     $display(" ERROR AT TIME = %t ",$time);
		     $stop;
		    end
	         $display(" RESET IS WOTKING");
                 reset =1'bx;
                // data_out = 8'bx;
               #(CYCLE-THOLD-TSETUP);
             end
     endtask
// writing operation 

    task writing(input we,input[3:0]wa,input [7:0]m);
	    begin
            @(negedge clk)	    
            we_enb = we;
            wr_addr = wa;
            data_in = m;
	    reset =1'b1;
	    temp = data_in;
	    #(CYCLE-THOLD-TSETUP);
            end 
    endtask  
// READING OPERATION
   
    task reading;
	  begin
	  we_enb  =1'b0;	  
          re_enb  = 1'b1;
	  rd_addr = wr_addr;
	  @(posedge clk)
	  #(THOLD);
	  if(temp !== data_out)
	     begin
	       $display(" DATA MIS MATCHED");
	       $display(" ERROR AT TIME=%t",$time);
               $stop;	       
             end
	   $display(" DATA MATCHED ");
	   #(CYCLE-THOLD-TSETUP);
	    data_in =  8'bx;
	   temp    = 8'bx;
	    wr_addr =4'bx;
	    we_enb = 1'bx;
	   end
   endtask

  // givimg all to stimulus


   initial
        begin
		initialize;
		sync_reset;
		writing(1'b1,4'b1011,8'b1111_0011);
		reading;
		$monitor(" data_in = %b data_out = %b ",data_in,data_out);
		#1000 $finish;
        end
endmodule 	

                
         

	     
            	    

           		   

