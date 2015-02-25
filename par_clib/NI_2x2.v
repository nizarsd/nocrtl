 module NI(id, clk, reset, item_out, req, channel_busy, send_en, item_in, valid, busy, errors, led);
 	`include "constants.v"
 	
    parameter tg_count = 500;
        
    input [`ADDR_SZ-1:0] id;
    
    input clk, reset, channel_busy, valid, send_en;
    
    output req, busy, led;
    
    output [3:0] errors;
    
    output  [`HDR_SZ + `PL_SZ + `ADDR_SZ-1:0] item_out;
    
     input   [`HDR_SZ + `PL_SZ + `ADDR_SZ-1:0] item_in;
    
    reg   [`HDR_SZ + `PL_SZ + `ADDR_SZ-1:0] item_out;
    
//     reg   [`HDR_SZ + `PL_SZ + `ADDR_SZ-1:0] item_in;
    
    reg [`PL_SZ-1:0] counter;
    
    reg busy, led, req;
    
    reg [3:0] errors;
    
      reg  [`HDR_SZ-2 : 0] header; 
    
//     input [`ADDR_SZ-1:0] dest;
    
    wire [`PL_SZ-1:0] data_in;
    
    wire [`HDR_SZ + `PL_SZ + `ADDR_SZ - 2:0] packet;
    
    
     assign data_in = item_in[`PL_SZ + `ADDR_SZ-1:`ADDR_SZ];
    
   //  assign dest = (id == 0) ? 1 : 0;
    
     wire [`PL_SZ-1:0] payload;
   
     assign packet = {header, payload, dest};
   
     assign payload = counter; 
    
    reg [22:0] rst_delay; 
    
    reg [1:0] dest_cntr;
    
    wire [`ADDR_SZ-1:0] dest;
    
   assign dest = {2'b0,dest_cntr}
   
   assign en_noc = (rst_delay == 0);


    always @(posedge clk or posedge reset) begin
	
	if (reset) begin
		
	    item_out <= 0;
	    
	    req <= 0;
	    
	    counter <= 0;
	    
	    busy <= 0;
	    
	    errors <= 0 ;
	    
	    led <= 0 ;
	    
	    header <= 0;
	    
	    dest_cntr <= 0;
	    
	    rst_delay <= tg_count;
		
	end 
	else begin 
	
	   if (rst_delay > 0) rst_delay <= rst_delay -1;
	   
	   if (send_en)  // sender
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
			  
			      if (dest == id) 
				  
				  counter <= counter + 1;
			      
			      else begin
			      
				  item_out[`HDR_SZ + `PL_SZ + `ADDR_SZ - 2 : 0] <= packet;
				  
				  item_out[`HDR_SZ + `PL_SZ + `ADDR_SZ-1] <= ^packet;  // parity bit

				  req <= 1;
				  
				  busy <= 1;
			      end
			      
			  end
			  
			dest_cntr <= dest_cntr +1;
	
		    end 
		  
		  else 
		    begin 
		    
			req <= 0;
			
			busy <= 0;
			
		    end
	      end 
	    else  // reciever 
	      begin
		  if (valid)
		    begin
			counter <= data_in;

			if (counter > tg_count-1) led = !led;
			
			if ((data_in > 0) & ((data_in - counter) != 1) & en_noc) errors <= errors + 1; 	      
		    end
		    
	      end
	      
	end // !reset
	
    end // always


endmodule

   