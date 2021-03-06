
module par_moody_sink (clk, reset, channel_busy, item_in, valid);

	parameter id = -1;
	
	parameter hospitality = 0; // min 0, max 255
	
	input clk, reset, valid;
	
	input [`HDR_SZ + `PL_SZ + `ADDR_SZ-1:0] item_in;
	
	output channel_busy;
	
	moody_sink #(id, hospitality) s1 (.clk(clk), .reset(reset), .data(item_in), .req(valid), .busy(channel_busy));

endmodule


module moody_sink (clk, reset, data, req, busy);

	parameter id = -1;

	parameter hospitality = 0; // min 0, max 255

	input clk, reset, req;
	
	output busy;
	
	input [`HDR_SZ + `PL_SZ + `ADDR_SZ-1:0] data;
	
	reg [`PL_SZ-1:0] register;

	reg [`ADDR_SZ-1:0] dest_addr;
	
	reg busy;
	
// 	reg [7:0] rand;
	
	always @(posedge clk or posedge reset) begin
	
		if (reset) begin
			register <= 0;
			busy <= 0;
// 			rand <= 0;
		end else begin
// 			rand <= $random;
			if (req & !busy) begin
				register <= data[`PL_SZ + `ADDR_SZ-1:`ADDR_SZ] ;
				dest_addr <= data[`ADDR_SZ-1:0];
				if (id != -1) $display ("##,rx,%d,%d",id, data[`PL_SZ + `ADDR_SZ-1:`ADDR_SZ]);
				if (id != data[`ADDR_SZ-1:0]) $display ("*****rx violation in %d, %d -> %d @ %d",id,  data[`HDR_SZ + `PL_SZ + `ADDR_SZ-1:`PL_SZ + `ADDR_SZ],data[`ADDR_SZ-1:0],$time );
// 				busy <= 1;
			end else 
			busy <= 0;//(rand > hospitality);
		end			
	
	end

endmodule
