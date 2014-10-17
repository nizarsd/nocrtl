
module par_tx (clk, reset, req, tx_busy, channel_busy, parallel_in, item_out, valid);


	parameter routerid=-1;
	
	parameter port="unknown";

	input clk, reset, req, channel_busy;
	
	output tx_busy;
	
	output valid;

	
	input [`PAYLOAD_SIZE+`ADDR_BITS-1:0] parallel_in;
	
	output [`PAYLOAD_SIZE+`ADDR_BITS-1:0] item_out;
	
	assign item_out = parallel_in;
	
	assign tx_busy = channel_busy;
	
	assign valid = req;
	
endmodule
