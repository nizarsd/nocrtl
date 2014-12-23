(* dont_touch = "true" *) module NI(id, clk, reset, item_out, req, channel_busy, send_en, item_in, valid, busy, error, led);
 	`include "constants.v"
 	
    parameter tg_count = 50000;
        
    input [`ADDR_SZ-1:0] id;
    
    input clk, reset, channel_busy, valid, send_en;
    
    output req, busy, error, led;
    
   (* dont_touch = "true" *) output  [`HDR_SZ + `PL_SZ + `ADDR_SZ-1:0] item_out;
    
   (* dont_touch = "true" *)  input   [`HDR_SZ + `PL_SZ + `ADDR_SZ-1:0] item_in;
    
    reg   [`HDR_SZ + `PL_SZ + `ADDR_SZ-1:0] item_out;
    
    
//     reg   [`HDR_SZ + `PL_SZ + `ADDR_SZ-1:0] item_in;
    
    reg [`PL_SZ-1:0] counter;
    
    reg busy, error, led;
    
    reg req;
    
     (* dont_touch = "true" *) reg  [`HDR_SZ-2 : 0] header; 
    
    wire [`ADDR_SZ-1:0] dest;
    
    wire [`PL_SZ-1:0] data_in;
    
    wire [`HDR_SZ + `PL_SZ + `ADDR_SZ - 2:0] packet;
    
    
   (* dont_touch = "true" *)  assign data_in = item_in[`PL_SZ + `ADDR_SZ-1:`ADDR_SZ];
    
   (* dont_touch = "true" *)  assign dest = (id == 0) ? 1 : 0;
    
   (* dont_touch = "true" *)  wire [`PL_SZ-1:0] payload;
   
   (* dont_touch = "true" *)  assign packet = {header, payload, dest};
   
   (* dont_touch = "true" *)  assign payload = counter; // 32'b01010101010101010101010101010101;
   //(* dont_touch = "true" *)  assign payload = 32'b0;
    
    reg started, done; 
    
    wire [`ADDR_SZ-1:0] dest_ini;

    always @(posedge clk or posedge reset) begin
	
	if (reset) begin
		
		  item_out <= 0;
		  
		  req <= 0;
		  
		  counter <= 0;
		  
		  busy <= 0;
		  
		  error <= 0 ;
		  
		  led <= 0 ;
		  
		  header <= 0;
		
	end 
	else begin
      //     counter increment takes ~ 100 cycles 		  
	   
	      
	   if (id == 1)  
	    begin
		if (valid)
		  begin
		      counter <= data_in;

		      if (counter > tg_count-1) led = !led;
		      error <= (((data_in-counter) == 1) | (data_in == 0)) ;
		      
		  end
		  
		  
	    end
		    
	   if (id==0) 
	    begin
	    
		if (!channel_busy & send_en & !busy) 
		  begin
			      
			  if (counter > tg_count)   
			    begin
			    
				  led = !led;
				  
				  counter <= 0;
				  
				  busy <= 0;
			    end
			  else  
			    begin
			    
				  counter <= counter + 1;
		      
				  item_out[`HDR_SZ + `PL_SZ + `ADDR_SZ - 2 : 0] <= packet;
				  
				  item_out[`HDR_SZ + `PL_SZ + `ADDR_SZ-1] <= ^packet;  // parity bit

				  req <= 1;
				  
				  busy <= 1;
			    end
			      
		  end 
		
		else 
		  begin 
		      req <= 0;
		      busy <= 0;
		  end
	    end
	      
	end // !reset
	
    end // always


endmodule

   