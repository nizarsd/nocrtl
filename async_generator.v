
module generator(clk, reset, send);
	parameter SIM_CYLES = 100000;
	parameter COOLDOWN_CYCLES = 10000;

	output clk, reset, send;
	
	reg clk, reset, send;

	initial 
	begin 
		clk = 0;
		#0 reset = 1; 
		#2 reset = 0;
	end 
	
	always 
	begin
		#1 clk = !clk;
	end
	
	initial $display("Start of simulation ...");
	
	  initial
         begin
            $dumpfile("dump1.vcd");
            $dumpvars(0,testbench);
         end

	
	initial     begin
		$display("Sending data ...");
		send=1;
		#(SIM_CYLES)
		$display("Cooling down ...");
		send=0;
		#(COOLDOWN_CYCLES)
		$display("End of simulation.");
		$finish;
	end


endmodule


