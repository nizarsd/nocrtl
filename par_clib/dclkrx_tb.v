`include "../constants.v"
`include "dclk_rx.v"
`include "dclk_tx.v"


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

wire  [`PAYLOAD_SIZE+`ADDR_SZ-1:0] parallel_out;  
wire  [`PAYLOAD_SIZE+`ADDR_SZ-1:0] item_in;  


// Connect the DUT
  generator g0(rclk, wclk, reset, item_in, req, item_read);

  
  dclk_rx #(2, "west")  dclk_rx0 (
			.rclk(rclk),
			.wclk(wclk), 
			.reset(reset), 
			.valid(valid),
			.channel_busy(channel_busy), 
			.item_read(item_read), 
			.serial_in(serial_in), 
			.parallel_out(parallel_out));
			
  dclk_tx  #(1, "east") tx0 (.clk(wclk), 
			.reset(reset), 
			.req(req), 
			.tx_busy(tx_busy), 
			.channel_busy(channel_busy), 
			.parallel_in(item_in), 
			.serial_out(serial_in), 
			.tx_active(tx_active));
  
endmodule


module generator(rclk, wclk, reset, item_in, req, item_read);
	parameter RCLOCK_PERIOD = 10;
	parameter WCLOCK_PERIOD = 12;

	parameter WCLOCK_PHASE = 2;
	output  rclk, wclk,  reset, req, item_read;
	output  [`PAYLOAD_SIZE+`ADDR_SZ-1:0] item_in;
	

	
	
	
	reg rclk, wclk,  reset, req, item_read;
	reg [`PAYLOAD_SIZE+`ADDR_SZ-1:0] item_in;
	
	initial 
	begin 
	
		rclk = 0;
		
		wclk = 1;
		
		item_in = 0;
		
		req = 0; 
		
		item_read = 0;
		
		#0 reset = 1; 
		
		#(RCLOCK_PERIOD*4) reset = 0;

	end 
	
	always 
	begin
		#(RCLOCK_PERIOD/2) rclk = !rclk;
		
	end
	
	
	always 
	begin
		#(WCLOCK_PHASE)  wclk = !wclk;  
		
		#(WCLOCK_PERIOD/2)   wclk = !wclk;
		
		#((WCLOCK_PERIOD/2) - WCLOCK_PHASE);
		
	end
	
	
	initial
        begin
		$display("Start of simulation ...");
	
		$dumpfile("dclk_rx.vcd");
	    
		$dumpvars();
	end
	
	// reading clock
	initial     
	begin
		#(RCLOCK_PERIOD*15.5)
		item_read = 1;
		#(RCLOCK_PERIOD)
		item_read = 0;
		
		#(RCLOCK_PERIOD*20 )
		item_read = 1;
		
		#(RCLOCK_PERIOD)
		item_read = 0;

		
	end

	// writing clock
	initial     
	begin
		
		#(WCLOCK_PERIOD*5.5 + WCLOCK_PHASE)
		item_in = 1;
		req = 1;
		
		#(WCLOCK_PERIOD)
		req = 0;
		
		#(WCLOCK_PERIOD*15)
		item_in = 2;
		req = 1;
		
		#(WCLOCK_PERIOD)
		req = 0;
		
		#(RCLOCK_PERIOD*40)  
		$display("Finished simulation.");
		$finish;
	end



endmodule

