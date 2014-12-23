module routing_table(id, table_addr, table_data);
//  	`include "constants.v"
 	input [`ADDR_SZ-1:0] id;
 	input [`ADDR_SZ-1:0] table_addr;
	output [`BITS_DIR-1:0] table_data;
	
	wire [1:0] x_local, y_local, x_dest, y_dest;
	
	return_x local_x(id, x_local, y_local);
	
	return_x dest_xy(table_addr, x_dest, y_dest);
	
    assign table_data = 
		  (x_dest > x_local) ? `EAST  : (
		  (x_dest < x_local) ? `WEST  : (
		  (y_dest > y_local) ? `SOUTH : (
		  (y_dest < y_local) ? `NORTH: `LOCAL
		  )));
	

endmodule



module return_xy(idx, x_coord ,y_coord);
  	input [`ADDR_SZ-1:0] idx;
 	output [1:0] x_coord;
    
	assign x_coord = 
		  (idx==0) ? 0 : (
		  (idx==1) ? 1 : (
		  (idx==2) ? 2 : (
		  (idx==3) ? 0 : (
		  (idx==4) ? 1 : (
		  (idx==5) ? 2 : (
		  (idx==6) ? 0 : (
		  (idx==7) ? 1 : (
		  (idx==8) ? 2 : 0
		  ))))))));
 	output [1:0] y_coord;
 	
    assign y_coord = 
		  (idx==0) ? 0 : (
		  (idx==1) ? 0 : (
		  (idx==2) ? 0 : (
		  (idx==3) ? 1 : (
		  (idx==4) ? 1 : (
		  (idx==5) ? 1 : (
		  (idx==6) ? 2 : (
		  (idx==7) ? 2 : (
		  (idx==8) ? 2 : 0
		  )))))))); 
endmodule

