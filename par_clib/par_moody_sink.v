
module par_moody_sink (clk, reset, channel_busy, item_in, valid);

	parameter id = -1;
	
	parameter hospitality = 0; // min 0, max 255
	
	input clk, reset, valid;
	
	input [`PAYLOAD_SIZE+`ADDR_BITS-1:0] item_in;
	
	output channel_busy;
	
	moody_sink #(id, hospitality) s1 (.clk(clk), .reset(reset), .data(item_in), .req(valid), .busy(channel_busy));

endmodule


module moody_sink (clk, reset, data, req, busy);

	parameter id = -1;

	parameter hospitality = 0; // min 0, max 255

	input clk, reset, req;
	
	output busy;
	
	input [`PAYLOAD_SIZE+`ADDR_BITS-1:0] data;
	
	reg [`PAYLOAD_SIZE-1:0] register;

	reg [`ADDR_BITS-1:0] dest_addr;
	
	reg busy;
	
	reg [7:0] rand;
	
	always @(posedge clk or posedge reset) begin
	
		if (reset) begin
			register <= 0;
			busy <= 0;
			rand <= 0;
		end else begin
			rand <= $random;
			if (req & !busy) begin
				register <= data[`PAYLOAD_SIZE+`ADDR_BITS-1:`ADDR_BITS];
				dest_addr <= data[`ADDR_BITS-1:0];
// 				if (id != -1) $display ("sink %d rx  : %c <<--", id, data[`PAYLOAD_SIZE+`ADDR_BITS-1:`ADDR_BITS]);
				if (id != -1) $display ("##,rx,%d,%d",id, data[`PAYLOAD_SIZE+`ADDR_BITS-1:`ADDR_BITS]);
				
				busy <= 1;
			end else 
			busy <= 0;//(rand > hospitality);
		end			
	
	end

endmodule
