
module serial_moody_sink (clk, reset, channel_busy, serial_in);

	parameter id = -1;
	
	parameter hospitality = 0; // min 0, max 255
	
	input clk, reset, serial_in;
	
	output channel_busy;
	
	wire [`PAYLOAD_SIZE+`ADDR_BITS-1:0] data;
	
	moody_sink #(id, hospitality) s1 (.clk(clk), .reset(reset), .data(data), .req(req), .busy(busy));

	rx rx1 (.clk(clk), .reset(reset), .valid(req), .channel_busy(channel_busy), .item_read(!busy), .serial_in(serial_in), .parallel_out(data) );

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
			busy <= 1;
			rand <= 0;
		end else begin
			rand <= $random;
			if (req & !busy) begin
				register <= data[`PAYLOAD_SIZE+`ADDR_BITS-1:`ADDR_BITS];
				dest_addr <= data[`ADDR_BITS-1:0];
// 				if (id != -1) $display ("sink %d rx  : %c <<--", id, data[`PAYLOAD_SIZE+`ADDR_BITS-1:`ADDR_BITS]);
				if (id != -1) $display ("##,rx,%d,%d",id, data[`PAYLOAD_SIZE+`ADDR_BITS-1:`ADDR_BITS]);
			end
			busy <= (rand > hospitality);
		end			
	
	end

endmodule
