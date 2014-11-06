module routing_table(reset, table_addr, table_data);

	parameter NODE_ID=0;
 	input reset;
	input [`ADDR_SZ-1:0] table_addr;
	output [`BITS_DIR-1:0] table_data;
	
	reg [`BITS_DIR-1:0] mem [`NUM_NODES-1:0];
	
always @(posedge reset) begin
	if (NODE_ID == 0) begin 
		mem[0] <= 4;
		mem[1] <= 1;
		mem[2] <= 1;
		mem[3] <= 2;
		mem[4] <= 1;
		mem[5] <= 1;
		mem[6] <= 2;
		mem[7] <= 1;
		mem[8] <= 1;
	end	 
	else if (NODE_ID == 1) begin 
		mem[0] <= 3;
		mem[1] <= 4;
		mem[2] <= 1;
		mem[3] <= 3;
		mem[4] <= 2;
		mem[5] <= 1;
		mem[6] <= 3;
		mem[7] <= 2;
		mem[8] <= 1;
	end	 
	else if (NODE_ID == 2) begin 
		mem[0] <= 3;
		mem[1] <= 3;
		mem[2] <= 4;
		mem[3] <= 3;
		mem[4] <= 3;
		mem[5] <= 2;
		mem[6] <= 3;
		mem[7] <= 3;
		mem[8] <= 2;
	end	 
	else if (NODE_ID == 3) begin 
		mem[0] <= 0;
		mem[1] <= 1;
		mem[2] <= 1;
		mem[3] <= 4;
		mem[4] <= 1;
		mem[5] <= 1;
		mem[6] <= 2;
		mem[7] <= 1;
		mem[8] <= 1;
	end	 
	else if (NODE_ID == 4) begin 
		mem[0] <= 3;
		mem[1] <= 0;
		mem[2] <= 1;
		mem[3] <= 3;
		mem[4] <= 4;
		mem[5] <= 1;
		mem[6] <= 3;
		mem[7] <= 2;
		mem[8] <= 1;
	end	 
	else if (NODE_ID == 5) begin 
		mem[0] <= 3;
		mem[1] <= 3;
		mem[2] <= 0;
		mem[3] <= 3;
		mem[4] <= 3;
		mem[5] <= 4;
		mem[6] <= 3;
		mem[7] <= 3;
		mem[8] <= 2;
	end	 
	else if (NODE_ID == 6) begin 
		mem[0] <= 0;
		mem[1] <= 1;
		mem[2] <= 1;
		mem[3] <= 0;
		mem[4] <= 1;
		mem[5] <= 1;
		mem[6] <= 4;
		mem[7] <= 1;
		mem[8] <= 1;
	end	 
	else if (NODE_ID == 7) begin 
		mem[0] <= 3;
		mem[1] <= 0;
		mem[2] <= 1;
		mem[3] <= 3;
		mem[4] <= 0;
		mem[5] <= 1;
		mem[6] <= 3;
		mem[7] <= 4;
		mem[8] <= 1;
	end	 
	else if (NODE_ID == 8) begin 
		mem[0] <= 3;
		mem[1] <= 3;
		mem[2] <= 0;
		mem[3] <= 3;
		mem[4] <= 3;
		mem[5] <= 0;
		mem[6] <= 3;
		mem[7] <= 3;
		mem[8] <= 4;
	end
end

	
	assign table_data = mem[table_addr];

	//assign table_data = `DIR_LOCAL;

endmodule
