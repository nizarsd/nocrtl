// Longer start of packet
(* dont_touch = "true" *) module dclk_tx (clk, reset, req, tx_busy, channel_busy, parallel_in, serial_out, tx_active);
 	`include "constants.v"
// 	parameter routerid=-1;
	parameter port="unknown";

	input clk, reset, req, channel_busy;
	
	output tx_busy, serial_out;
	
	input [`HDR_SZ + `PL_SZ + `ADDR_SZ-1:0] parallel_in;
	
	output reg tx_active;
	
	reg [`HDR_SZ + `PL_SZ + `ADDR_SZ + 3 : 0] item;
	
	reg [`HDR_SZ + `PL_SZ + `ADDR_SZ - 1 : 0] temp;
	
	reg [1:0] busy_reg;
	
	wire busy_sync;
	
	assign busy_sync = busy_reg[1];
	
	
	assign serial_out = item[0] & tx_active;
	
	assign tx_busy = tx_active | busy_sync;
	
	always @(posedge clk or posedge reset) begin
	
		if (reset) begin
		
			item <= 0;
			tx_active <= 0;
			temp <= 0;
			busy_reg<=0;
		
		end else begin
			busy_reg[0] <= channel_busy;  // synchronise "channel_busy" to clk
			busy_reg[1] <= busy_reg[0];
			
			if (!tx_active) begin
			
				if (!busy_sync & req) begin
				
					// switch to 'transmitting' state
			
					tx_active <= 1;
					
					item[`HDR_SZ + `PL_SZ + `ADDR_SZ + 2 : 3] <= parallel_in;
					
					temp <= parallel_in;
					
					item[`HDR_SZ + `PL_SZ + `ADDR_SZ + 3] <= 1;
					
					item[2:0] <= 3'b111;
					
				end
			
			end else begin

				item <= (item >> 1);
				
				if ((item>>1) == 1) begin  // the last (stop bit) ?
					
					// end transmission when the currently transmitted bit is the last
					
					tx_active <= 0;
					
					item <= 0;
				end
			
			end
		
		end
	
	end

endmodule
