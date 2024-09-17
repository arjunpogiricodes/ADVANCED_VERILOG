// adavanced verilog 

/*
2'b00 = 25 paise
2'b01 = 50 paise
2'b10 = 100 paise or 1 rupee
2'b11 = no coin

after 5 sec it goes reset state

clk 256hz

1/256 = 
*/

`timescale 1ms/1us
module vending_machine(reset,clk,coin_in,pre_out);

// declaring the input and output ports
     
      input reset,clk;
	  input [1:0]coin_in;
      output pre_out;      	 

// state declaraiing 
     // parameter   paisa=2'b00,
		//		  pavala=2'b01,
		//		  rupee=2'b10,
		//		  no_coin=2'b11;
				  
      parameter   IDLE=3'b000,
				  PAISE25=3'b001,
				  PAISE50=3'b010,
				  PAISE75=3'b011,
				  PAISE100=3'b100;	 

	  reg [2:0]present,next;

      reg [7:0]clk_count;
      reg [2:0]seq_count;
   	  

// seq_count count logic for 5 sec

      always@(posedge clk)
            begin
                if(reset)
                        clk_count <= 0;
                else 
				begin
				if((coin_in == 2'b11) && (present == PAISE25 || present == PAISE50 || present == PAISE75 )) 
				    clk_count <= clk_count +1'b1;
				else	
                     clk_count <= 0; 		     
			    end	
        	end

// clk_count logic for 1 sec pulse counting

       always@(posedge clk)
            begin
            	if(reset)
                        seq_count <= 0;
                else
                    begin  				
						if(coin_in != 2'b11)
						 begin
						 seq_count <= 0;
						 end
						else
						    begin
							   if(clk_count == 255 )
								 begin 
									  if(seq_count == 5)
										 seq_count <= 0;
									  else
										 seq_count <= seq_count + 1'b1;
								 end	
							end	 
								 
 			        end
            end					
              	  

// present state sequential logic 

      always@(posedge clk)
             begin
                  if(reset)
                           present <= IDLE;
                  else
                           present    <= next;
             end
 
// next state combinational logic

       always@(*)
              begin
                 case(present)
				   IDLE:
				        if(coin_in == 2'b00)
				            next = PAISE25;
                        else if(coin_in == 2'b01)
                            next = PAISE50;
                        else if(coin_in == 2'b10)
                            next = PAISE100;
                        else if(coin_in == 2'b11 )
                            next = IDLE;
                        else if(seq_count == 5)
                            next = IDLE;						
                    
                   PAISE25:
				        if(coin_in == 2'b00)
				            next = PAISE50;
                        else if(coin_in == 2'b01)
                            next = PAISE75;
                        else if(coin_in == 2'b10)
                            next = PAISE100;
                        else if(coin_in == 2'b11 )
                            next = PAISE25;
                        else if(seq_count == 5)
                            next = IDLE;							
				   
				   PAISE50:
                        if(coin_in == 2'b00)
				            next = PAISE75;
                        else if(coin_in == 2'b01)
                            next = PAISE100;
                        else if(coin_in == 2'b10)
                            next = PAISE100;
                        else if(coin_in == 2'b11 )
                            next = PAISE50;
                        else if(seq_count == 5)
                            next = IDLE;							

                   PAISE75:
  				        if(coin_in == 2'b00)
				            next = PAISE100;
                        else if(coin_in == 2'b01)
                            next = PAISE100;
                        else if(coin_in == 2'b10)
                            next = PAISE100;
                        else if(coin_in == 2'b11 )
                            next = PAISE75;
                        else if(seq_count == 5)
                            next = IDLE;							
    
                   PAISE100:
				            next = IDLE;
				
                   default :next = IDLE;
                endcase
            end

// output combinational logic

        assign pre_out = (present == PAISE100)?1'b1:1'b0;

endmodule		
                   				   
				   
			  