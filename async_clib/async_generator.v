
// `define NUM_NODES 9

module async_gen(clk, reset, send);
	parameter SIM_CYLES = 500000;
	parameter COOLDOWN_CYCLES = 500;

	output [`NUM_NODES-1 : 0] clk;
	output reset, send;
	
	reg [`NUM_NODES-1 : 0] clk;
	reg reset, send;
	
	parameter CLK_PHASE_0 = 0;
	parameter CLK_PHASE_1 = 0;
	parameter CLK_PHASE_2 = 0;
	parameter CLK_PHASE_3 = 0;
	parameter CLK_PHASE_4 = 0;
	parameter CLK_PHASE_5 = 0;
	parameter CLK_PHASE_6 = 0;
	parameter CLK_PHASE_7 = 0;
	parameter CLK_PHASE_8 = 0;
		
	
	parameter CLK_PERIOD_0 = 4;
	parameter CLK_PERIOD_1 = 4;
	parameter CLK_PERIOD_2 = 4;
	parameter CLK_PERIOD_3 = 4;
	parameter CLK_PERIOD_4 = 4;
	parameter CLK_PERIOD_5 = 4;
	parameter CLK_PERIOD_6 = 4;
	parameter CLK_PERIOD_7 = 4;
	parameter CLK_PERIOD_8 = 4;
	
	integer i; 
	
	initial 
	begin 
		for (i = 0; i < `NUM_NODES; i = i +1) begin
		    clk[i] = 0;
		end
		#0 reset = 1; 
		
		#(CLK_PERIOD_0*5) reset = 0;

	end 
	
	always
	begin
		#((CLK_PERIOD_0 / 2) - CLK_PHASE_0) clk[0] = !clk[0];  
		#((CLK_PERIOD_0 / 2)) clk[0] = !clk[0];
		#(CLK_PHASE_0);
	end

	always
	begin
		#((CLK_PERIOD_1 / 2) - CLK_PHASE_1) clk[1] = !clk[1];  
		#((CLK_PERIOD_1 / 2)) clk[1] = !clk[1];
		#(CLK_PHASE_1);
	end

	always
	begin
		#((CLK_PERIOD_2 / 2) - CLK_PHASE_2) clk[2] = !clk[2];  
		#((CLK_PERIOD_2 / 2)) clk[2] = !clk[2];
		#(CLK_PHASE_2);
	end
	
	always
	begin
		#((CLK_PERIOD_3 / 2) - CLK_PHASE_3) clk[3] = !clk[3];  
		#((CLK_PERIOD_3 / 2)) clk[3] = !clk[3];
		#(CLK_PHASE_3);
	end
	
	always
	begin
		#((CLK_PERIOD_4 / 2) - CLK_PHASE_4) clk[4] = !clk[4];  
		#((CLK_PERIOD_4 / 2)) clk[4] = !clk[4];
		#(CLK_PHASE_4);
	end
	

	always
	begin
		#((CLK_PERIOD_5 / 2) - CLK_PHASE_5) clk[5] = !clk[5];  
		#((CLK_PERIOD_5 / 2)) clk[5] = !clk[5];
		#(CLK_PHASE_5);
	end
	
	always
	begin
		#((CLK_PERIOD_6 / 2) - CLK_PHASE_6) clk[6] = !clk[6];  
		#((CLK_PERIOD_6 / 2)) clk[6] = !clk[6];
		#(CLK_PHASE_6);
	end
	
	always
	begin
		#((CLK_PERIOD_7 / 2) - CLK_PHASE_7) clk[7] = !clk[7];  
		#((CLK_PERIOD_7 / 2)) clk[7] = !clk[7];
		#(CLK_PHASE_7);
	end
	

	always
	begin
		#((CLK_PERIOD_8 / 2) - CLK_PHASE_8) clk[8] = !clk[8];  
		#((CLK_PERIOD_8 / 2)) clk[8] = !clk[8];
		#(CLK_PHASE_8);
	end
	

	initial
        begin
		$display("Start of simulation ...");
		
		$dumpfile("dump.vcd");
		
		$dumpvars();
		
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


