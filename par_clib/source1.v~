

module serial_source (clk, reset, serial_out, busy, pir);
 	parameter DEST_ID=`NUM_NODES-1;
	parameter NODE_ID=0;
	input clk, reset, busy;
	input [7:0] pir;
	output serial_out;
	
	wire [`ADDR_BITS-1:0] data;
	
	source #(.DEST_ID(DEST_ID), .NODE_ID(NODE_ID)) s1 (clk, reset, data, req, tx_busy, pir);
	
	tx tx1 (clk, reset, req, tx_busy, busy, data, serial_out);

endmodule

module source (clk, reset, data, req, busy, pir);
	parameter DEST_ID=`NUM_NODES-1;
	parameter NODE_ID=0;
	
	input clk, reset, busy;
	
	input [7:0] pir;
	
	output req;

	output [`ADDR_BITS-1:0] data;

	
	reg [`ADDR_BITS-1:0] data;
	
	reg [7:0] counter;
	
	reg req;	
	
	always @(posedge clk or posedge reset) begin

		if (reset) begin
			data <= 0;
			req <= 0;
			counter <= 0;
		end 
		else begin
				if(counter > pir) begin
					if (!busy) begin
						data <=DEST_ID;
						req <=1;
						counter <=0;
					end
				end
				else begin
					counter = counter + 1;
					req <=0;
				end
		end  // else reset
	end // always

endmodule
