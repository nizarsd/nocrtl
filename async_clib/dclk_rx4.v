
module dclk_rx (rclk, wclk, reset, valid, channel_busy, item_read, serial_in, parallel_out);
 //	`include "constants.v"
// 	parameter routerid=-1;
	parameter port="unknown";
	
	// states format: <generating clock domain>-STATE-<status>
	
	`define WR_STATE_IDLE	0
	`define WR_STATE_WRTNG	1
	`define RD_STATE_VALID	2
	`define RD_STATE_READ	3

	// states format: <generating clock domain>-STATE-<status>
	
	`define FLAG_WR 	0
	`define FLAG_RD 	1
	

	input rclk, wclk, reset, item_read, serial_in;
	
	output valid, channel_busy;	
	
	output [`HDR_SZ + `PL_SZ + `ADDR_SZ-1:0] parallel_out;

	// state 0 = idle, 1 = receiving, 2 = delivering item

	wire [1:0] gstate; // global state 
	
 	reg [1:0] rd_state; // read state
 	
 	reg [1:0] wr_state; // write state 
	
	
	reg [`HDR_SZ + `PL_SZ + `ADDR_SZ:0] item;

	reg [1:0] valid_reg;
	reg [1:0] read_reg;
	
	reg rd_wr_flag;   // reading/writing flag;
	
	wire validd, readd, read;
	
	assign parallel_out = item[`HDR_SZ + `PL_SZ + `ADDR_SZ-1:0];
	
	assign validd = (gstate == `RD_STATE_VALID);
	assign readd = (gstate == `RD_STATE_READ);
	
	
	assign valid =  valid_reg[1];  // synchronised to rclk (wr -> rd)
	assign read =  read_reg[1];    // synchronised to wclk (rd -> wr)
	
	assign gstate = (rd_wr_flag == `FLAG_WR) ? wr_state : rd_state;
	assign channel_busy = (gstate != `WR_STATE_IDLE);
	
	
	always @(posedge rclk) begin
	
		valid_reg[0] <= validd;  // synchronise "valid" to rclk
		
		valid_reg[1] <= valid_reg[0];
		
	
		if (reset) begin

 		    valid_reg <= 0 ;
 		    
 		    rd_state <= `RD_STATE_VALID;
			
		end else begin 
		    case (gstate)
			
			`RD_STATE_VALID:
					if (valid)
					    if (item_read)
					    begin
						valid_reg  <= 0;
						
						rd_state <= `RD_STATE_READ;
					      
					    end 
			  
		
			`WR_STATE_IDLE:
					begin
					    
					    rd_state <= `RD_STATE_VALID;

					end

		    endcase
		end
	end

	always @(posedge wclk) begin
		
		read_reg[0] <= readd;  // synchronise "read" to rclk
		
		read_reg[1] <= read_reg[0];
	
		if (reset) begin

			item <= 0;
			
			wr_state <= `WR_STATE_IDLE;
			
			rd_wr_flag <= `FLAG_WR;
			
		end else begin
			
		    case (gstate)
			
			`WR_STATE_IDLE: if (serial_in) // 'idle -> writing' on the arrival start-bit
				      begin
					  
					wr_state <= `WR_STATE_WRTNG;
				
					item[`HDR_SZ + `PL_SZ + `ADDR_SZ-1:0] <= item [`HDR_SZ + `PL_SZ + `ADDR_SZ:1];
					
					item[`HDR_SZ + `PL_SZ + `ADDR_SZ] <= serial_in;
					  
  				      end 
			
		
			`WR_STATE_WRTNG: begin
				
					  // continue receiving and shifting
				  
					  item[`HDR_SZ + `PL_SZ + `ADDR_SZ-1:0] <= item [`HDR_SZ + `PL_SZ + `ADDR_SZ:1];
					  
					  item[`HDR_SZ + `PL_SZ + `ADDR_SZ] <= serial_in;
					  
					  if (item[0])  // item received when LSB is 1
					  begin
					  
					      wr_state <= `WR_STATE_IDLE; 
						
					      rd_wr_flag <= `FLAG_RD;	
					      
					  end
					    
				      end 
			
			`RD_STATE_READ:  if (read) begin
			
					    rd_wr_flag <= `FLAG_WR;	
					    					    
					    read_reg <= 0;
					    
					    item <= 0;
					
				      end
				    
		      endcase  // case   

		
		end  // ! reset
	
	end // always


endmodule
	 