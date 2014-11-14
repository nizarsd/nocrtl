
module par_tx (clk, reset, req, tx_busy, channel_busy, parallel_in, item_out, valid);


// 	parameter routerid=-1;
	
	parameter port="unknown";

	input clk, reset, req, channel_busy;
	
	output tx_busy;
	
	output valid;

	
	input [`HDR_SZ + `PL_SZ + `ADDR_SZ-1:0] parallel_in;
	
	output [`HDR_SZ + `PL_SZ + `ADDR_SZ-1:0] item_out;
	
	assign item_out = parallel_in;
	
	assign tx_busy = channel_busy;
	
	assign valid = req;
	
endmodule
