

/*(* dont_touch = "true" *) */module dclk_rx (rclk, wclk, reset, valid, channel_busy, item_read, serial_in, parallel_out);
 	`include "constants.v"
// 	parameter routerid=-1;
	parameter port="unknown";

	input rclk, wclk, reset, item_read, serial_in;
	
	output valid, channel_busy;	
	
	reg channel_busy;
	
	output [`HDR_SZ + `PL_SZ + `ADDR_SZ-1:0] parallel_out;
	
	reg [1:0] state; // 0 = idle, 1 = receiving, 2 = delivering item
	
	/*(* dont_touch = "true" *)*/ reg [`HDR_SZ + `PL_SZ + `ADDR_SZ:0] item;
	
	/*(* dont_touch = "true" *)*/ reg [`HDR_SZ + `PL_SZ + `ADDR_SZ-1:0] parallel_out;
	
	reg [1:0] valid_reg;
	
	reg validw;
	
	// assign parallel_out = item;
	
	// assign validw = (state == 2);
	
	assign valid =  valid_reg[1];  // synchronised to rclk
	
	
	// assign channel_busy = (state != 0);
	
	 always @(posedge rclk or negedge reset) begin
	
		valid_reg[0] <= validw;  // synchronise "valid" to rclk
		valid_reg[1] <= valid_reg[0];
		
	
		if (reset) begin

		    item <= 0;
		    
		    state <= 0;
		    
		    valid_reg <= 0 ;
		    
		end else begin
		
		    channel_busy <= (state != 0);
	
		
		    if (state == 2 & item_read) begin
		    
			    // item transferred, switch back to 'idle'
		    
			    state <= 0;
			    
			    item <= 0;
			    
			    valid_reg <= 0 ;
			    
		    end
		
		end
	
	end

	
	always @(posedge wclk) begin
	
		if (reset) begin

			item <= 0;
			
			state <= 0;
			
			validw <= 0;
			
		end else begin
		
			validw <= (state == 2);
			
			if (state == 0 & serial_in) begin
			
				// transition from 'idle' to 'receiving' on arrival of flit head (high bit)
			
				state <= 1;				
			
			end else if (state == 1) begin
			
				// continue receiving and shifting
			
				item[`HDR_SZ + `PL_SZ + `ADDR_SZ-1:0] <= item [`HDR_SZ + `PL_SZ + `ADDR_SZ:1];
				
				item[`HDR_SZ + `PL_SZ + `ADDR_SZ] <= serial_in;
				
				if (item[0]) begin
				
					state <= 2; // item received when LSB is 1
					
					parallel_out <= item [`HDR_SZ + `PL_SZ + `ADDR_SZ-1:0];
					
				end
			
			end 

		
		end
	
	end

	
endmodule



