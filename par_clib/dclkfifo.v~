
`define DCLK_FIFO_DEPTH_LOG2 3

`define DCLK_FIFO_DEPTH (1<<`DCLK_FIFO_DEPTH_LOG2)



module dclkfifo(rclk, wclk, reset, full, empty, item_in, item_out, write, read);

	parameter routerid=-1;
	parameter DCLK_FIFO_DSIZE = 4;

	input rclk, wclk, reset, write, read;
	
	output full, empty;
	
	reg [DCLK_FIFO_DSIZE -1:0] mem [`DCLK_FIFO_DEPTH-1:0];
	
	reg [`DCLK_FIFO_DEPTH_LOG2-1:0] read_ptr;
	
	reg [`DCLK_FIFO_DEPTH_LOG2-1:0] write_ptr;
	
	reg [`DCLK_FIFO_DEPTH_LOG2:0] count;
	
	wire [`DCLK_FIFO_DEPTH_LOG2-1:0] read_ptr_p1; assign read_ptr_p1 = read_ptr + 1;
	
	wire [`DCLK_FIFO_DEPTH_LOG2-1:0] write_ptr_p1; assign write_ptr_p1 = write_ptr + 1;
	
	input [DCLK_FIFO_DSIZE -1:0] item_in;
	
	output [DCLK_FIFO_DSIZE -1:0] item_out;
	
// 	reg full, empty;
	
	integer i;

	assign wclkn = !wclk;  // for write clock 

	
	assign full= (count == `DCLK_FIFO_DEPTH - 1);
	
	assign empty= (count == 0);
	
// 	writing clock
	always @(posedge wclkn) begin
	
		if (reset) begin
		
			write_ptr <= 0;
			
			read_ptr <= 0;
			
			count <= 0;			

		end 
		else begin 

		    if (write & !full) begin
		    
			mem [write_ptr] <= item_in;
			    
			write_ptr <= write_ptr_p1;
			    
			count <= count + 1;
			    
// 			if (!read) count <= count+1;

			if (routerid > -1) $display("router %d fifo push : %d", routerid, item_in);

		    end
		
		end
	
	end
	
	// reading clock
	always @(posedge rclk) begin
	
		if (reset) begin
			
			write_ptr <= 0;
		
			read_ptr <= 0;
			
			count <= 0;			

		end else begin
		
			if (read & !empty) begin
				
				read_ptr <= read_ptr_p1;

 				count <= count - 1;

// 				if (!write) count <= count-1;
				
				if (routerid > -1) $display("router %d fifo pop : %d", routerid, item_out);
			
			end 

		end
	
	end
	
	assign item_out = mem [read_ptr];
	

endmodule


