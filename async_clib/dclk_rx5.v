
module dclk_rx (rclk, wclk, reset, valid, channel_busy, item_read, serial_in, parallel_out);
 	`include "constants.v"
// 	parameter routerid=-1;
	parameter port="unknown";
	
	// states format: <generating clock domain>-STATE-<status>
	
	`define STATE_IDLE	0
	`define STATE_WRTNG	1
	`define STATE_VALID	2

	

	input rclk, wclk, reset, item_read, serial_in;
	
	output valid, channel_busy;	
	
	output [`HDR_SZ + `PL_SZ + `ADDR_SZ-1:0] parallel_out;

	// state 0 = idle, 1 = receiving, 2 = delivering item
	
 	reg [1:0] state; // write state 
	
	reg [1:0] valid_reg;
	
	reg [1:0] read_reg;
	
	reg [`HDR_SZ + `PL_SZ + `ADDR_SZ:0] item;

	wire rd_valid, wr_valid, wr_read;
	
	reg rd_read;
	
	assign parallel_out = item[`HDR_SZ + `PL_SZ + `ADDR_SZ-1:0];
	
	assign rd_valid = valid_reg[1];
	
	assign wr_read =  read_reg[1];    // synchronised to wclk (rd -> wr)
	
		
	assign channel_busy = (state != `STATE_IDLE);
	
	assign wr_valid = (state == `STATE_VALID);

	assign valid =  rd_valid & !rd_read;  // synchronised to rclk (wr -> rd)
	
	always @(posedge rclk) begin
	
		
	
		if (reset) 
		  begin

		      valid_reg <= 0 ;
		      
		      rd_read <= 0;
		      
		  end   
		else 
		begin
		      valid_reg[0] <= wr_valid;  // synchronise "valid" to rclk
		      
		      valid_reg[1] <= valid_reg[0];
			
		      if (item_read)  
			  begin
			
			      rd_read <= 1;
			      
			  end 
		      else 
		      if (!rd_valid & rd_read) 
			  begin
			    
			    rd_read <= 0;
			    
			  end
			  
		end
	end


	
	always @(negedge wclk) begin

		if (reset) begin

			item <= 0;
			
			state <= `STATE_IDLE;
			
			read_reg <= 0; 
			
		end else begin
		
		    read_reg[0] <= rd_read;  // synchronise "read" to rclk
		    
		    read_reg[1] <= read_reg[0];
		
		    case (state)
			
			`STATE_IDLE: if (serial_in) // 'idle -> writing' on the arrival start-bit
				      begin
					  
					state <= `STATE_WRTNG;
				
					item[`HDR_SZ + `PL_SZ + `ADDR_SZ-1:0] <= item [`HDR_SZ + `PL_SZ + `ADDR_SZ:1];
					
					item[`HDR_SZ + `PL_SZ + `ADDR_SZ] <= serial_in;
					  
  				      end 
			
		
			`STATE_WRTNG: begin
				
					  // continue receiving and shifting
				  
					  item[`HDR_SZ + `PL_SZ + `ADDR_SZ-1:0] <= item [`HDR_SZ + `PL_SZ + `ADDR_SZ:1];
					  
					  item[`HDR_SZ + `PL_SZ + `ADDR_SZ] <= serial_in;
					  
					  if (item[0])  // item received when LSB is 1
					  begin
					  
					      state <= `STATE_VALID; 
					  end
					    
				      end 
			
			`STATE_VALID:  if (wr_read) begin
			
					  state <= `STATE_IDLE; 
					  
					  item <= 0;
					  
				      end
				    
		      endcase  // case   


		
		end  // ! reset
	
	end // always


endmodule

	 