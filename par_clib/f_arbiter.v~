module f_arbiter(gnt_valid,
	req_n, busy_n, gnt_n, 
	req_e, busy_e, gnt_e, 
	req_s, busy_s, gnt_s, 
	req_w, busy_w, gnt_w, 
	req_l, busy_l, gnt_l, 
	);
input req_n, req_e, req_s, req_w, req_l; 

input busy_n, busy_e, busy_s, busy_w, busy_l; 

output gnt_n, gnt_e, gnt_s, gnt_w, gnt_l; 

output gnt_valid;


	assign gnt_n = req_n & !busy_n;
	assign gnt_e = !n_valid & s_valid;
	assign gnt_s = !n_valid & !s_valid & e_valid;
	assign gnt_w = !n_valid & !s_valid & !e_valid & w_valid;
	assign gnt_l = !n_valid & !s_valid & !e_valid & !w_valid & l_valid;
	
endmodule