

module serial_source_from_memory (clk, reset, serial_out, busy);

	parameter id = -1;

	parameter flits = 16;
	
	parameter traffic_file = "";
	
	input clk, reset, busy;
	
	output serial_out;
	wire tx_active;
	
	wire [`SIZE-1:0] data;
	
	source_from_memory #(id, flits, traffic_file) s1 (clk, reset, data, req, tx_busy);
	
	tx tx1 (clk, reset, req, tx_busy, busy, data, serial_out,tx_active);

endmodule


module source_from_memory (clk, reset, data, req, busy);

	parameter id = -1;
	
	parameter flits = 16;
	
	parameter traffic_file = "";

	input clk, reset, busy;
	
	output req;
	
	output [`SIZE-1:0] data;
	
	reg [`SIZE-1:0] data;
	
	reg [4:0] counter;
	
	reg req;
	
	reg done;
	
	reg [4:0] index;
	
	reg [`SIZE-1:0] memory [flits-1:0];
	
	initial $readmemh(traffic_file, memory, 0, flits-1) ;

	
	always @(posedge clk or posedge reset) begin
	
		if (reset) begin
			
			data <= 0;
			
			req <= 0;
			
			counter <= 1;
			
			index <= 0;
			
			done <= 0;
			
		end else begin
			
			if (counter == 0) begin
			
				if (!busy & !done) begin
			
					data <= memory[index];
					
					if (id != -1) $display ("source %d tx : %d  -->>", id, memory[index]);
					if (id != -1) $display ("##,tx");
					
					counter <= 1;
					
					index <= index + 1;
					
					req <= 1;
					
					if (index == flits-1) begin
						done <= 1;
					end else begin
											
					end
				
				end
				
			end else begin
		
				req <= 0;
				
				counter <= counter + 1;
				
			end
			
		end
	
	end

endmodule
