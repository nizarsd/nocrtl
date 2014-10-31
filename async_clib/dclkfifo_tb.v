
`include "dclkfifo.v"
module top ();

wire             rclk;    
wire            wclk;    
wire            reset;    
wire            full;   
wire            empty;   
wire 		write;
wire 		read;

wire   [3:0]    item_in;   
wire   [3:0]    item_out;  


// Connect the DUT
  generator #(2, 4)  g0(rclk, wclk, reset, item_in, write, read);
  
  dclkfifo dclkfifo0 (rclk, wclk, reset, full, empty, item_in, item_out, write, read);
  
endmodule


module generator(rclk, wclk, reset, item_in, write, read);
	output  rclk, wclk,  reset, write, read;
	output  [3:0] item_in;
	
	reg rclk, wclk,  reset, write, read;
	reg [3:0] item_in;
	
	initial 
	begin 
	
		rclk = 0;
		
		wclk = 1;
		
		item_in = 0;
		
		write = 0;
		
		read = 0; 
		
		#0 reset = 1; 
		
		#8 reset = 0;

	end 
	
	always 
	begin
		#2 rclk = !rclk;
		
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
        
		$dumpfile("fifodump.vcd");
	    
		$dumpvars();
	end

	
	initial     
	begin
// 		$display("Sending data ...");
		
		#11 
		item_in = 1;
		write = 1;
		
		#3
		read = 1;
		
		#1 
		item_in = 2;

		#3
		read = 0;
		
		#1
		item_in = 3;
		
		#3
		read = 1;
		
		#1
		item_in = 4;
		
		#3
		read = 0;

		#1
		item_in = 5;

// 		#4
// 		write = 0;

		#3
		read = 1;
		
		#4
		read = 0;

      
		#28  $finish;
	end



endmodule

