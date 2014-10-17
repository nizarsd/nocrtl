module routing_table(reset, table_addr, table_data);

	parameter NODE_ID=0;
 	input reset;
	input [`ADDR_BITS-1:0] table_addr;
	output [`BITS_DIR-1:0] table_data;
	
	reg [`BITS_DIR-1:0] mem [`NUM_NODES-1:0];
	
//	initial $readmemh(table_file, memory, 0, 15) ;
always @(posedge reset) begin
	  if(NODE_ID==0) begin
			 mem[0]<=4; 
			 mem[1]<=1; 
			 mem[2]<=1; 
			 mem[3]<=1; 
			 mem[4]<=2; 
			 mem[5]<=1; 
			 mem[6]<=1; 
			 mem[7]<=1; 
			 mem[8]<=2;  
			 mem[9]<=1;  
			 mem[10]<=1;  
			 mem[11]<=1;  
			 mem[12]<=2;  
			 mem[13]<=1;  
			 mem[14]<=1;  
			 mem[15]<=1;
		 end 
		 else if(NODE_ID==1) begin
			 mem[0]<=3; 
			 mem[1]<=4; 
			 mem[2]<=1; 
			 mem[3]<=1; 
			 mem[4]<=3; 
			 mem[5]<=2; 
			 mem[6]<=1; 
			 mem[7]<=1; 
			 mem[8]<=3; 
			 mem[9]<=2; 
			 mem[10]<=1; 
			 mem[11]<=1; 
			 mem[12]<=3; 
			 mem[13]<=2; 
			 mem[14]<=1; 
			 mem[15]<=1;
		 end 
		 else if(NODE_ID==2) begin
			 mem[0]<=3; 
			 mem[1]<=3; 
			 mem[2]<=4; 
			 mem[3]<=1; 
			 mem[4]<=3; 
			 mem[5]<=3; 
			 mem[6]<=2; 
			 mem[7]<=1; 
			 mem[8]<=3; 
			 mem[9]<=3; 
			 mem[10]<=2; 
			 mem[11]<=1; 
			 mem[12]<=3; 
			 mem[13]<=3; 
			 mem[14]<=2; 
			 mem[15]<=1;
		 end 
		 else if(NODE_ID==3) begin
			 mem[0]<=3; 
			 mem[1]<=3; 
			 mem[2]<=3; 
			 mem[3]<=4; 
			 mem[4]<=3; 
			 mem[5]<=3; 
			 mem[6]<=3; 
			 mem[7]<=2; 
			 mem[8]<=3; 
			 mem[9]<=3; 
			 mem[10]<=3; 
			 mem[11]<=2; 
			 mem[12]<=3; 
			 mem[13]<=3; 
			 mem[14]<=3; 
			 mem[15]<=2;
		 end 
		 else if(NODE_ID==4) begin
			 mem[0]<=0; 
			 mem[1]<=1; 
			 mem[2]<=1; 
			 mem[3]<=1; 
			 mem[4]<=4; 
			 mem[5]<=1; 
			 mem[6]<=1; 
			 mem[7]<=1; 
			 mem[8]<=2; 
			 mem[9]<=1; 
			 mem[10]<=1; 
			 mem[11]<=1; 
			 mem[12]<=2; 
			 mem[13]<=1; 
			 mem[14]<=1; 
			 mem[15]<=1;
		 end 
		 else if(NODE_ID==5) begin
			 mem[0]<=3; 
			 mem[1]<=0; 
			 mem[2]<=1; 
			 mem[3]<=1; 
			 mem[4]<=3; 
			 mem[5]<=4; 
			 mem[6]<=1; 
			 mem[7]<=1; 
			 mem[8]<=3; 
			 mem[9]<=2; 
			 mem[10]<=1; 
			 mem[11]<=1; 
			 mem[12]<=3; 
			 mem[13]<=2; 
			 mem[14]<=1; 
			 mem[15]<=1;
		 end 
		 else if(NODE_ID==6) begin
			 mem[0]<=3; 
			 mem[1]<=3; 
			 mem[2]<=0; 
			 mem[3]<=1; 
			 mem[4]<=3; 
			 mem[5]<=3; 
			 mem[6]<=4; 
			 mem[7]<=1; 
			 mem[8]<=3; 
			 mem[9]<=3; 
			 mem[10]<=2; 
			 mem[11]<=1; 
			 mem[12]<=3; 
			 mem[13]<=3; 
			 mem[14]<=2; 
			 mem[15]<=1;
		 end 
		 else if(NODE_ID==7) begin
			 mem[0]<=3; 
			 mem[1]<=3; 
			 mem[2]<=3; 
			 mem[3]<=0; 
			 mem[4]<=3; 
			 mem[5]<=3; 
			 mem[6]<=3; 
			 mem[7]<=4; 
			 mem[8]<=3; 
			 mem[9]<=3; 
			 mem[10]<=3;
			 mem[11]<=2; 
			 mem[12]<=3; 
			 mem[13]<=3; 
			 mem[14]<=3; 
			 mem[15]<=2;
		 end 
		 else if(NODE_ID==8) begin
			 mem[0]<=0; 
			 mem[1]<=1; 
			 mem[2]<=1; 
			 mem[3]<=1; 
			 mem[4]<=0; 
			 mem[5]<=1; 
			 mem[6]<=1; 
			 mem[7]<=1; 
			 mem[8]<=4; 
			 mem[9]<=1; 
			 mem[10]<=1; 
			 mem[11]<=1; 
			 mem[12]<=2; 
			 mem[13]<=1; 
			 mem[14]<=1; 
			 mem[15]<=1;
		 end 
		 else if(NODE_ID==9) begin
			 mem[0]<=3; 
			 mem[1]<=0; 
			 mem[2]<=1; 
			 mem[3]<=1; 
			 mem[4]<=3; 
			 mem[5]<=0; 
			 mem[6]<=1; 
			 mem[7]<=1; 
			 mem[8]<=3; 
			 mem[9]<=4; 
			 mem[10]<=1; 
			 mem[11]<=1; 
			 mem[12]<=3; 
			 mem[13]<=2; 
			 mem[14]<=1; 
			 mem[15]<=1;
		 end 
		 else if(NODE_ID==10) begin
			 mem[0]<=3; 
			 mem[1]<=3; 
			 mem[2]<=0; 
			 mem[3]<=1; 
			 mem[4]<=3; 
			 mem[5]<=3; 
			 mem[6]<=0; 
			 mem[7]<=1; 
			 mem[8]<=3; 
			 mem[9]<=3; 
			 mem[10]<=4; 
			 mem[11]<=1; 
			 mem[12]<=3; 
			 mem[13]<=3; 
			 mem[14]<=2;
			 mem[15]<=1;
		 end 
		 else if(NODE_ID==11) begin
			 mem[0]<=3; 
			 mem[1]<=3; 
			 mem[2]<=3; 
			 mem[3]<=0; 
			 mem[4]<=3; 
			 mem[5]<=3; 
			 mem[6]<=3; 
			 mem[7]<=0; 
			 mem[8]<=3; 
			 mem[9]<=3; 
			 mem[10]<=3; 
			 mem[11]<=4; 
			 mem[12]<=3; 
			 mem[13]<=3; 
			 mem[14]<=3; 
			 mem[15]<=2;
		 end 
		 else if(NODE_ID==12) begin
			 mem[0]<=0; 
			 mem[1]<=1; 
			 mem[2]<=1; 
			 mem[3]<=1; 
			 mem[4]<=0; 
			 mem[5]<=1; 
			 mem[6]<=1; 
			 mem[7]<=1; 
			 mem[8]<=0; 
			 mem[9]<=1; 
			 mem[10]<=1;
			 mem[11]<=1;
			 mem[12]<=4; 
			 mem[13]<=1; 
			 mem[14]<=1;
			 mem[15]<=1;
		 end 
		 else if(NODE_ID==13) begin
			 mem[0]<=3;
			 mem[1]<=0; 
			 mem[2]<=1;
			 mem[3]<=1; 
			 mem[4]<=3; 
			 mem[5]<=0; 
			 mem[6]<=1; 
			 mem[7]<=1; 
			 mem[8]<=3; 
			 mem[9]<=0; 
			 mem[10]<=1;
			 mem[11]<=1; 
			 mem[12]<=3; 
			 mem[13]<=4;
			 mem[14]<=1; 
			 mem[15]<=1;
		 end 
		 else if(NODE_ID==14) begin
			 mem[0]<=3; 
			 mem[1]<=3; 
			 mem[2]<=0; 
			 mem[3]<=1; 
			 mem[4]<=3; 
			 mem[5]<=3; 
			 mem[6]<=0; 
			 mem[7]<=1; 
			 mem[8]<=3;
			 mem[9]<=3; 
			 mem[10]<=0;
			 mem[11]<=1; 
			 mem[12]<=3;
			 mem[13]<=3;
			 mem[14]<=4; 
			 mem[15]<=1;
		 end 
		 else if(NODE_ID==15) begin
			 mem[0]<=3;
			 mem[1]<=3;
			 mem[2]<=3;
			 mem[3]<=0; 
			 mem[4]<=3; 
			 mem[5]<=3; 
			 mem[6]<=3; 
			 mem[7]<=0;
			 mem[8]<=3; 
			 mem[9]<=3; 
			 mem[10]<=3;
			 mem[11]<=0;
			 mem[12]<=3; 
			 mem[13]<=3; 
			 mem[14]<=3;
			 mem[15]<=4;
		 end 
		 
end

	
	assign table_data = mem[table_addr];

	//assign table_data = `DIR_LOCAL;

endmodule
