(* dont_touch = "true" *) module NI(id, clk, reset, item_out, req, channel_busy, send_en, item_in, valid, busy, error, led);

     `include "constants.v"   
//     parameter id = -1;


        
    input [`ADDR_SZ-1:0] id;
    
    input clk, reset, channel_busy, valid, send_en;
    
    output req, busy, error, led;
    
    output  [`HDR_SZ + `PL_SZ + `ADDR_SZ-1:0] item_out;
    
    input   [`HDR_SZ + `PL_SZ + `ADDR_SZ-1:0] item_in;
    
    reg   [`HDR_SZ + `PL_SZ + `ADDR_SZ-1:0] item_out;
    
//     reg   [`HDR_SZ + `PL_SZ + `ADDR_SZ-1:0] item_in;
    
    reg [`PL_SZ-1:0] counter;
    
    reg busy, error, led;
    
    reg req;
    
   (* dont_touch = "true" *) reg  [`HDR_SZ-2 : 0] header; 
    
    wire [`ADDR_SZ-1:0] dest;
    
    wire [`PL_SZ-1:0] data_in;
    
    wire [`HDR_SZ + `PL_SZ + `ADDR_SZ - 2:0] packet;
    
    
    
    assign packet = {header, counter, dest};
    
    assign data_in = item_in[`PL_SZ + `ADDR_SZ-1:`ADDR_SZ];
    
//     assign  item_out[`HDR_SZ + `PL_SZ + `ADDR_SZ-1] = ^item_out [`HDR_SZ + `PL_SZ + `ADDR_SZ-2:0];
    
    
    assign dest = (id == 0) ? 1 : 0;
    
    reg started, done; 
    
    wire [`ADDR_SZ-1:0] dest_ini;
    
//     assign dest_ini=(id==0)? 1 : 0;
        
    always @(posedge clk) begin
	
	if (reset) begin
		
		  item_out <= 0;
		  
		  req <= 0;
		  
		  counter <= 0;
		  
		  busy <= 0;
		  
		  done <= 0;
		  
		  started <= 0 ;
		  
		  error <= 0 ;
		  
		  led <= 0 ;
		  
		  header <= 0;
		
	end 
	else begin
	      
	      // receive 
	    if (valid & !busy & !done) begin
		    // counter increment takes ~ 100 cycles 	
		    if ( (counter > 50000)  &&  id==0) begin
		    
// 			  $display ("counter = %d, time = %d, id=%d", counter, $time, id);

			  counter <= 0;
			  
			  led <= !led;
			  
// 			  done <= 1;

			  started <= 0;

		    end else begin
		    
			  counter <= item_in[`PL_SZ + `ADDR_SZ - 1 : `ADDR_SZ] + 1;
			  
// 			  if (started & id==0) $display ("##rx %d:  %d,%d @%d",id, counter, item_in[`PL_SZ + `ADDR_SZ-1:`ADDR_SZ], $time);

			  if (started & id==0 & !((data_in - counter)==1)) error <= 1;
		    
		    end
		    
		    busy <= 1;
	      		    
		    if (started == 0) started <= 1;
      
	      end 
	      
//	       process and send_en 

// 	      if (!channel_busy & req) $display ("##,tx,%d,%d @ %d",item_out[`ADDR_SZ-1:0],id,$time );
	      
	      if (!channel_busy & send_en) begin
	      
		    if (busy | (id==0 & !started)) begin
			    
			  item_out[`HDR_SZ + `PL_SZ + `ADDR_SZ - 2 : 0] <= packet;
  			  
  			  item_out[`HDR_SZ + `PL_SZ + `ADDR_SZ-1] <= ^packet;  // parity bit

			  req <= 1;
			  
			  busy <= 0;
			  
			  if (started == 0) started <= 1;
		     end  
		     else   req <= 0;
		
	      end /* channel_busy */ 
	      else   req <= 0;
		
	end // !reset
	
    end // always


endmodule

   