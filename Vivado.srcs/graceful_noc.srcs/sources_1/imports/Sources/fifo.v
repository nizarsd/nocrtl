(* dont_touch = "true" *) module fifo(clk, reset, full, empty, item_in, item_out, write, read);
       `include "constants.v"

      `define FIFO_DEPTH_LOG2 `FIFO_LOG2

      `define FIFO_DEPTH (1<<`FIFO_DEPTH_LOG2)
// 	parameter routerid=-1;

	input clk, reset, write, read;
	
	output full, empty;
	
	reg [`HDR_SZ + `PL_SZ + `ADDR_SZ-1:0] mem [`FIFO_DEPTH-1:0];
	
	reg [`FIFO_DEPTH_LOG2-1:0] read_ptr;
	
	reg [`FIFO_DEPTH_LOG2-1:0] write_ptr;
	
	wire [`FIFO_DEPTH_LOG2-1:0] read_ptr_p1; assign read_ptr_p1 = read_ptr + 1;
	
	wire [`FIFO_DEPTH_LOG2-1:0] write_ptr_p1; assign write_ptr_p1 = write_ptr + 1;
	
	reg [`FIFO_DEPTH_LOG2:0] count;
	
	input [`HDR_SZ + `PL_SZ + `ADDR_SZ-1:0] item_in;
	
	output [`HDR_SZ + `PL_SZ + `ADDR_SZ-1:0] item_out;
	
	reg full, empty;
	
	integer i;

	(* mark_debug = "true" *)  wire [`HDR_SZ + `PL_SZ + `ADDR_SZ-1:0]  fifo_itemrd_dbg;
	(* mark_debug = "true" *)  wire [`HDR_SZ + `PL_SZ + `ADDR_SZ-1:0]  fifo_itemrd1_dbg;
	(* mark_debug = "true" *)  wire [`HDR_SZ + `PL_SZ + `ADDR_SZ-1:0]  fifo_item0_dbg;
	(* mark_debug = "true" *)  wire [`HDR_SZ + `PL_SZ + `ADDR_SZ-1:0]  fifo_item1_dbg;
	(* mark_debug = "true" *)  wire [`FIFO_DEPTH_LOG2-1:0] fifo_read_dbg;
	
	
// 	assign fifo_itemrd_dbg = mem[read_ptr];
// 	assign fifo_itemrd1_dbg = mem[read_ptr-1];
// 	assign fifo_item0_dbg = mem[0];
// 	assign fifo_item1_dbg = mem[1];
// 	assign fifo_read_dbg = read_ptr;
	
	// parity check sum
	wire p_ok;
	wire [`HDR_SZ + `PL_SZ + `ADDR_SZ - 2:0] packet;
	assign packet = item_in[`HDR_SZ + `PL_SZ + `ADDR_SZ - 2 : 0];
	assign p_ok = (item_in[`HDR_SZ + `PL_SZ + `ADDR_SZ-1] == (^packet));
	
// 	assign full= (count==`FIFO_DEPTH);
// 	assign empty= (count==0);
	always @(posedge clk or posedge reset) begin
	
		if (reset) begin
		
			read_ptr <= 0;
			
			write_ptr <= 0;
			
			empty <= 1;
			
			full <= 0;
			
			count <= 0;			

			for (i=0; i<`FIFO_DEPTH; i=i+1) begin
				mem[i] <= 0;
			end

		end else begin
		
			if (read & !empty) begin
				
				full <= 0;
				
				read_ptr <= read_ptr_p1;

// 				if (!write) count <= count-1;

				if (read_ptr_p1 == write_ptr) empty <= 1;
				
				//if  $display("router %d fifo pop : %d", routerid, item_out);
			
			end 
			
			if (write & !full & p_ok) begin
			
				mem [write_ptr] <= item_in;
				
				//if  $display("router %d fifo push : %d", routerid, item_in);
				
				empty <= 0;
				
				write_ptr <= write_ptr_p1;
				

// 				if (!read) count <= count+1;
				
				if (read_ptr == write_ptr_p1) full <= 1;
		
			end
			
			if (actual_read & !actual_write)
				count <= count-1;
			else if (actual_write & !actual_read)
				count <= count+1;
				
		
		end
	
	end
	
	assign item_out = mem [read_ptr];
	
	wire actual_read = read & !empty;
	wire actual_write = write & !full;


endmodule

