
module tx (clk, reset, req, tx_busy, channel_busy, parallel_in, serial_out, tx_active);

	parameter routerid=-1;
	parameter port="unknown";

	input clk, reset, req, channel_busy;
	
	output tx_busy, serial_out;
	
	input [`PAYLOAD_SIZE+`ADDR_BITS-1:0] parallel_in;
	
	output reg tx_active;
	
	reg [`PAYLOAD_SIZE+`ADDR_BITS+1:0] item;
	
	reg [`PAYLOAD_SIZE+`ADDR_BITS-1:0] temp;
	
	assign serial_out = item[0] & tx_active;
	
	assign tx_busy = tx_active | channel_busy;
	
	always @(posedge clk or posedge reset) begin
	
		if (reset) begin
		
			item <= 0;
			tx_active <= 0;
			temp <= 0;
		
		end else begin
		
			if (!tx_active) begin
			
				if (!channel_busy & req) begin
				
					// switch to 'transmitting' state
			
					tx_active <= 1;
					
					item[`PAYLOAD_SIZE+`ADDR_BITS:1] <= parallel_in;
					temp <= parallel_in;
					item[`PAYLOAD_SIZE+`ADDR_BITS+1] <= 1;
					item[0] <= 1;
					
					//if (!tx_active && (routerid > -1)) $display("router %d %s tx : %d", routerid, port, parallel_in);
					
					//item <= {1'b1, parallel_in[`ADDR_BITS-1:0], 1'b1}; // leading one is the start bit of the flit
					
				end
			
			end else begin

				item <= (item >> 1);
				
				if ((item>>1) == 1) begin
					
					// end transmission when the currently transmitted bit is the last
					
					tx_active <= 0;
					item <= 0;
				end
			
			end
		
		end
	
	end

endmodule
