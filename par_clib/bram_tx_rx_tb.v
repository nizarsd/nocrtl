  `timescale 10ns/1ns
 `include "constants.v"
 `include "dclk_rx_bram.v"
 `include "dclk_tx_bram.v"
module bram_tx_rx_tb ();


//   wire almost_empty;
//   wire almost_full; 
  reg  [39:0]item_in;
  wire [39:0]item_out;
//   wire empty;
//   wire full;
  wire [7:0]fifo_count;
  wire valid;
  
  wire rd_clk;
  wire wr_clk;

  wire channel_busy, data_serial;
  
  reg req;
  reg item_read;
  

  parameter ITEMS =5;

  reg [1 : 0] clk;
  reg reset;
  
  assign rd_clk=clk[1];
  assign wr_clk=clk[0];
  
  parameter CLK_PHASE_WR = 1;
  parameter CLK_PHASE_RD = 0;

  
  parameter CLK_PERIOD_WR = 4;
  parameter CLK_PERIOD_RD = 6;
  
  integer i; 
  
  initial 
  begin 
  	  item_read = 0;
	  req = 0;
	  item_in = 0;
	  reset = 1;	 
	  clk = 0;
	  i=1;
	  #(CLK_PERIOD_WR*5) reset = 0;

  end 
  
  always
  begin
	  #((CLK_PERIOD_WR / 2) - CLK_PHASE_WR) clk[0] = !clk[0];  
	  #((CLK_PERIOD_WR / 2)) clk[0] = !clk[0];
	  #(CLK_PHASE_WR);
  end

  always
  begin
	  #((CLK_PERIOD_RD / 2) - CLK_PHASE_RD) clk[1] = !clk[1];  
	  #((CLK_PERIOD_RD / 2)) clk[1] = !clk[1];
	  #(CLK_PHASE_RD);
  end


  initial
  begin
	  $dumpfile("dump.vcd");
		
	  $dumpvars();
	  
	  $display("Start of simulation ...");
	  
	  #(CLK_PERIOD_WR*6 + CLK_PHASE_WR )
	  
	  while (i < ITEMS + 1) 
	    begin
   	    #(CLK_PERIOD_WR);

	    if (!tx_busy)
		
		begin
		  
		  item_in = i;
		  
		  i = i + 1;
		  
		  req = 1;
		   
		   #(CLK_PERIOD_WR);
		   
		  req = 0;

		
		end
		
	  end

  end

  initial
  begin
  	  #(CLK_PHASE_RD)
	  #(CLK_PERIOD_RD*(ITEMS*2 + 5));
	  

	  while (item_out < ITEMS) 
	      begin
	      
	      #(CLK_PERIOD_RD)
	      
	      if (valid)  
	      begin
	      
		  item_read = 1;
		  
		  #(CLK_PERIOD_RD);
		  
		  item_read = 0;
		
	      end
		  
	    end
	  
	  
          #(CLK_PERIOD_RD*300);
	  
	  $display("End of simulation.");  	  

	  $finish;

  end
  
  dclk_rx_bram  rx0(
		.en(1'b1),
		.rd_clk(rd_clk),
		.wr_clk(wr_clk),
		.reset(reset),
		.valid(valid),
		.channel_busy(channel_busy),
		.fifo_read(item_read),
		.fifo_count(fifo_count),
		.serial_in(data_serial),
		.item_out(item_out));

  dclk_tx_bram tx0(
		.en(1'b1),
		.clk(wr_clk),
		.reset(reset),
		.req(req),
		.tx_busy(tx_busy),
		.channel_busy(channel_busy),
		.parallel_in(item_in),
		.serial_out(data_serial));
 	
    
endmodule






