
module dclk_rx (rclk, wclk, reset, valid, channel_busy, item_read, serial_in, parallel_out);
 	`include "constants.v"
// 	parameter routerid=-1;
	parameter port="unknown";
	
	`define STATE_IDLE	0
	`define STATE_WRTNG     1
	`define STATE_VALID  	2
	`define STATE_READ  	3
	`define MOD_WR		0
	`define MOD_RD 		1
	

	input rclk, wclk, reset, item_read, serial_in;
	
	output valid, channel_busy;	
	
	output [`HDR_SZ + `PL_SZ + `ADDR_SZ-1:0] parallel_out;

	// state 0 = idle, 1 = receiving, 2 = delivering item

	wire [1:0] gstate; // global state 
	
 	reg [1:0] rd_state; // read state
 	
 	reg [1:0] wr_state; // write state 
	
	
	reg [`HDR_SZ + `PL_SZ + `ADDR_SZ:0] item;

	reg [1:0] valid_reg;
	
	reg writing;   // reading wiriting flag;
	
	wire validd;
	
	assign parallel_out = item[`HDR_SZ + `PL_SZ + `ADDR_SZ-1:0];
	
	assign validd = (gstate == `STATE_VALID);
	
	assign valid =  valid_reg[1];  // synchronised to rclk
	
	assign gstate = (writing == `MOD_WR) ? wr_state : rd_state;
	
	assign channel_busy = (gstate != `STATE_IDLE);
	
	always @(posedge rclk) begin
	
		valid_reg[0] <= validd;  // synchronise "valid" to rclk
		
		valid_reg[1] <= valid_reg[0];
		
	
		if (reset) begin

 		    valid_reg <= 0 ;
 		    
 		    rd_state <= `STATE_VALID;
			
		end else begin 
		    case (gstate)
			
			`STATE_VALID: if (item_read)
				      begin
					  // transition from 'idle' to 'receiving' on arrival of flit head (high bit)
					  valid_reg  <= 0;
					  
					  rd_state <= `STATE_READ;
					
				      end 
			
		
			`STATE_IDLE:  rd_state <= `STATE_VALID;

		    endcase
		end
	end

	
	always @(posedge wclk) begin
	
		if (reset) begin

			item <= 0;
			
			wr_state <= `STATE_IDLE;
			
			writing <= `MOD_WR;
			
		end else begin
			
		    case (gstate)
			
			`STATE_IDLE: if (serial_in)
				      begin
					  // transition from 'idle' to 'receiving' on arrival of flit head (high bit)
					wr_state <= `STATE_WRTNG;
				
					item[`HDR_SZ + `PL_SZ + `ADDR_SZ-1:0] <= item [`HDR_SZ + `PL_SZ + `ADDR_SZ:1];
					
					item[`HDR_SZ + `PL_SZ + `ADDR_SZ] <= serial_in;
					  
  // 					      writing <= `MOD_WR;				
					  
				      end 
			
		
			`STATE_WRTNG: begin
				
					  // continue receiving and shifting
				  
					  item[`HDR_SZ + `PL_SZ + `ADDR_SZ-1:0] <= item [`HDR_SZ + `PL_SZ + `ADDR_SZ:1];
					  
					  item[`HDR_SZ + `PL_SZ + `ADDR_SZ] <= serial_in;
					  
					  if (item[0])  
					  begin
					  
					    wr_state <= `STATE_IDLE; // item received when LSB is 1
					      
					    writing <= `MOD_RD;	
					      
					  end
					    
				      end 
			
			`STATE_READ:  begin
			
					    writing <= `MOD_WR;	
					    
					    item <= 0;
					
				      end
				    
		      endcase  // case   


		
		end  // ! reset
	
	end // always

	
endmodule


	 