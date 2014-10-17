
module par_rx (clk, reset, channel_busy, item_in, item_read, parallel_out);
	parameter routerid=-1;
	parameter port="unknown";

	input clk, reset, item_read;
	
	input [`PAYLOAD_SIZE+`ADDR_BITS-1:0] item_in;
		
	output  channel_busy;	
	
	output [`PAYLOAD_SIZE+`ADDR_BITS-1:0] parallel_out;
	
	assign parallel_out = item_in;
	
	assign channel_busy = (req & !item_read);
	
endmodule
