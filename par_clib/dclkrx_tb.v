`include "../constants.v"
`include "dclk_rx.v"
`include "tx.v"



module top ();

wire            rclk;    
wire            wclk;    
wire            reset;    
wire		serial_out;   
wire		channel_busy;   
wire		valid;
wire		item_read;
wire 		req;
wire 		tx_active;

wire  [`PAYLOAD_SIZE+`ADDR_BITS-1:0] parallel_out;  
wire  [`PAYLOAD_SIZE+`ADDR_BITS-1:0] item_in;  


// Connect the DUT
  generator #(2, 4)  g0(rclk, wclk, reset, item_in, req, item_read);

  
  dclk_rx #(2, "west")  dclk_rx0 (
			.rclk(rclk),
			.wclk(wclk), 
			.reset(reset), 
			.valid(valid),
			.channel_busy(channel_busy), 
			.item_read(item_read), 
			.serial_in(serial_in), 
			.parallel_out(parallel_out));
			
  tx  #(1, "east") tx0 (.clk(wclk), 
			.reset(reset), 
			.req(req), 
			.tx_busy(tx_busy), 
			.channel_busy(channel_busy), 
			.parallel_in(item_in), 
			.serial_out(serial_in), 
			.tx_active(tx_active));
  
endmodule


module generator(rclk, wclk, reset, item_in, req, item_read);
	output  rclk, wclk,  reset, req, item_read;
	output  [`PAYLOAD_SIZE+`ADDR_BITS-1:0] item_in;
	
	parameter RCLOCK_PERIOD = 10ns;
	parameter WCLOCK_PERIOD = 10ns;
	
	parameter WCLOCK_PHASE = 3;
	
	
	
	reg rclk, wclk,  reset, req, item_read;
	reg [`PAYLOAD_SIZE+`ADDR_BITS-1:0] item_in;
	
	initial 
	begin 
	
		rclk = 0;
		
		wclk = 1;
		
		item_in = 0;
		
		req = 0; 
		
		item_read = 0;
		
		#0 reset = 1; 
		
		#(RCLOCK_PERIOD) reset = 0;

	end 
	
	always 
	begin
		#(RCLOCK_PERIOD/2) rclk = !rclk;
		
	end
	
	always 
	begin
		#1 wclk = !wclk;
		#1 wclk =  wclk;
		#1 wclk = !wclk;
		#1 wclk =  wclk;
		
	end
	
	initial $display("Start of simulation ...");
	
	initial
        begin
        
		$dumpfile("dclk_rx.vcd");
	    
		$dumpvars();
	end

	
	initial     
	begin
// 		$display("Sending data ...");
		
		#11
		item_in = 1;
		req = 1;
		
		#4
		req = 0;
		
		#31
		item_read = 1;
		
		#4
		item_read = 0;
		
      
		#(RCLOCK_PERIOD*50)  $finish;
	end



endmodule
