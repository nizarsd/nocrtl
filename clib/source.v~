
module serial_source (en_w, ip_traffic, clk, reset, serial_out, busy, pir);
 	//parameter DEST_ID=`NUM_NODES-1;
	parameter NODE_ID=0;
	
	input clk, reset, busy, en_w;
	input [7:0] pir;
	input [`NUM_NODES-1:0] ip_traffic;
	
	output serial_out;
	
	wire [`ADDR_BITS-1:0] data;
	
	source #(.NODE_ID(NODE_ID)) s1 (en_w, ip_traffic, clk, reset, data, req, tx_busy, pir);
	
	tx tx1 (clk, reset, req, tx_busy, busy, data, serial_out);

endmodule

module source (en_w, ip_traffic, clk, reset, data, req, busy, pir);
	//parameter DEST_ID=`NUM_NODES-1;
	parameter NODE_ID=0;
	
	
	input clk, reset, busy, en_w;
	
	input [7:0] pir;
	input [`NUM_NODES-1:0] ip_traffic;
	
	
	
	output req;

	output [`ADDR_BITS-1:0] data;

	
	reg [`NUM_NODES-1:0] reg_traffic;
	reg [`ADDR_BITS-1:0] data;
	reg [7:0] counter;
	reg [`ADDR_BITS:0] dest_counter; // When you need a counter to span all the nodes it size must be `ADDR_BITS not `ADDR_BITS-1 !!
	
	reg req;	
	reg delay;
	
	always @(posedge clk or posedge reset) begin

		if (reset) begin
			data <= 0;
			req <= 0;
			counter <= 0;
			dest_counter<=0;
			delay <=0;
		end 
		else begin
			if (en_w) begin
				reg_traffic <= ip_traffic;
			end
			
			if (req) begin
				req<=0;
			end
			
			if(counter > pir) begin
				if (dest_counter < `NUM_NODES) begin
					if (reg_traffic[dest_counter]) begin
						if (!busy ) begin
							if ((delay)) begin
								delay<=0;
								req <=1;
								data <= dest_counter;
								dest_counter <= dest_counter+1;
							end
							else begin
								delay<=1;
							end
						end 
					end //reg_traffic
					else begin
						dest_counter <= dest_counter+1;
					end
				end  // dest_counter
				else begin  
						counter <=0;
						dest_counter<=0;
					end
			end
			else begin
				counter <= counter + 1;
			end
	end  // else reset
	end // always

endmodule


