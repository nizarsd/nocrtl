//----------------------------------------------------
// A four level, round-robin arbiter. 
// Nizar Dahir 2014
//----------------------------------------------------
module rr_arbiter (
  clk,    
  reset,    
  req0,   
  req1,   
  req2,   
  req3,   
  gnt0,   
  gnt1,   
  gnt2,   
  gnt3
);

// --------------Port Declaration----------------------- 
input           clk;    
input           reset;    

input           req0;   
input           req1;   
input           req2;   
input           req3;   
// input [1:0]     id; 
output  reg        gnt0;   
output  reg        gnt1;   
output  reg        gnt2;   
output  reg        gnt3;   

//--------------state register ----------------------- 
reg [1:0] state;

//--------------Code Starts Here----------------------- 
always @(posedge clk or posedge reset) begin
    if (reset) begin
	  
	  gnt0  <=  0;
	  gnt1  <=  0;
	  gnt2  <=  0;
	  gnt3  <=  0;
	  state <=  0;
	  
    end 
    else  begin   
      if (state==0)
	    begin 
		gnt0 <= req0;
		gnt1 <= req1 & !req0;
		gnt2 <= req2 & !req1 & !req0;
		gnt3 <= req3 & !req2 & !req1 & !req0;
		if (req0 | req1 | req2 | req3 ) state <= 1;
	     end
        else if (state==1)
	    begin
		gnt1 <= req1;
		gnt2 <= !req1 & req2;
		gnt3 <= !req2 & !req1 & req3;
		gnt0 <= !req3 & !req2 & !req1 & req0;
		if (req0 | req1 | req2 | req3 ) state <= 2;
	     end
        else if (state==2)
	    begin
		gnt2 <= req2;
		gnt3 <= !req2 & req3;
		gnt0 <= !req3 & !req2 & req0;
		gnt1 <= !req0 & !req3 & !req2 & req1;
		if (req0 | req1 | req2 | req3 ) state <= 3;

	    end
        else if (state==3)
	    begin
		gnt3 <= req3;
		gnt0 <= !req3 & req0;
		gnt1 <= !req3 & !req0 & req1;
		gnt2 <= !req3 & !req0 & !req1 & req2;
		if (req0 | req1 | req2 | req3 ) state <= 0;
	    end
    end
end
    
endmodule