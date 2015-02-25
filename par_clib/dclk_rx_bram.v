
module dclk_rx_bram (en, rd_clk, wr_clk, reset, valid, channel_busy, fifo_read, fifo_count, serial_in, item_out);
 	`define STATE_IDLE	0
	`define STATE_SHFT	1
	`define STATE_FNSH	2

	parameter routerid=-1;
	parameter port="unknown";

	input wr_clk,  rd_clk, en, reset, fifo_read, serial_in;
	
	output valid, channel_busy;	
	
	output [7:0] fifo_count;
	
	output [`HDR_SZ + `PL_SZ + `ADDR_SZ-1:0] item_out;
	
	reg [1:0] state; // 0 = idle, 1 = receiving, 2 = delivering item
	
	reg [`HDR_SZ + `PL_SZ + `ADDR_SZ:0] item;
	
	wire [`HDR_SZ + `PL_SZ + `ADDR_SZ - 1 : 0] packet_in;
	
	assign packet_in = item [`HDR_SZ + `PL_SZ + `ADDR_SZ-1 : 0];
	
	wire wr_clk_n, wr_en, finish, wr_ack, full, almost_full, almost_empty;
	
	assign finish = (state == `STATE_FNSH);
	
 	assign wr_en = finish & (!wr_ack);
	assign channel_busy = (state != `STATE_IDLE);
	
	assign wr_clk_n = wr_clk;

	assign wr_ack =1;
	
	assign item_out = packet_in;

	
// 	  design_1_wrapper design_1_wrapper0
// 	      ( .almost_empty(almost_empty),
// 		.almost_full(almost_full),
// 		.din(packet_in),
// 		.dout(item_out),
// 		.empty(empty),
// 		.full(full),
// 		.rd_clk(rd_clk),
// 		.rd_data_count(fifo_count),
// 		.rd_en(fifo_read),
// 		.rst(reset),
// 		.valid(valid),
// 		.wr_clk(wr_clk_n),
// 		.wr_ack(wr_ack),
// 		.wr_en(wr_en)
// 		);
// 		
	
	always @(posedge wr_clk_n or posedge reset) begin
	
		if (reset) begin

			item <= 0;
			
			state <= `STATE_IDLE;
			
		end 
		else if (en) begin
		
		
		    case (state)
			
			`STATE_IDLE: 
			    begin
			    // 'idle -> shifting' on the arrival start-bit
				if (serial_in)
				  begin
				    state <= `STATE_SHFT;			
				    
				    item[`HDR_SZ + `PL_SZ + `ADDR_SZ-1:0] <= item [`HDR_SZ + `PL_SZ + `ADDR_SZ:1];
				    
				    item[`HDR_SZ + `PL_SZ + `ADDR_SZ] <= serial_in;
				    
				  end
			
			    end 
			`STATE_SHFT: 
			    begin
		
				// receiving and shifting
			
				item[`HDR_SZ + `PL_SZ + `ADDR_SZ-1:0] <= item [`HDR_SZ + `PL_SZ + `ADDR_SZ:1];
				
				item[`HDR_SZ + `PL_SZ + `ADDR_SZ] <= serial_in;
				
				if (item[0])  state <= `STATE_FNSH; // item received when LSB is 1
				
			    end 
			`STATE_FNSH: 
			    begin
				// item transferred, switch back to 'idle'
				if (wr_ack)
				 begin
				 
				    state <= `STATE_IDLE;
				    
				    item <= 0;
				    
				 end
				  
			    end
		
		    endcase
	
		end  // en
	end // always

endmodule
