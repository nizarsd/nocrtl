assign rx_data[1][3] = tx_data[0][1];
assign tx_busy[0][1] = rx_busy[1][3];
assign wclk[1][3] = clk_fw[0];

assign rx_data[0][1] = tx_data[1][3];
assign tx_busy[1][3] = rx_busy[0][1];
assign wclk[0][1] = clk_fw[1];

assign tx_busy[0][0] = 0;
assign rx_data[0][0] = 0;
assign wclk[0][0] = 0;
assign tx_busy[0][2] = 0;
assign rx_data[0][2] = 0;
assign wclk[0][2] = 0;
assign tx_busy[1][0] = 0;
assign rx_data[1][0] = 0;
assign wclk[1][0] = 0;
assign tx_busy[1][2] = 0;
assign rx_data[1][2] = 0;
assign wclk[1][2] = 0;
assign tx_busy[0][3] = 0;
assign rx_data[0][3] = 0;
assign wclk[0][3] = 0;
assign tx_busy[1][1] = 0;
assign rx_data[1][1] = 0;
assign wclk[1][1] = 0;
assign rx_l_data[0] = source_data[0];
assign rx_l_valid[0] = source_valid[0];
assign source_busy[0] = rx_busy[0][4];

assign sink_data[0] = tx_l_data[0];
assign sink_valid[0] = tx_l_valid[0];
assign tx_busy[0][4] = sink_busy[0];

assign rx_l_data[1] = source_data[1];
assign rx_l_valid[1] = source_valid[1];
assign source_busy[1] = rx_busy[1][4];

assign sink_data[1] = tx_l_data[1];
assign sink_valid[1] = tx_l_valid[1];
assign tx_busy[1][4] = sink_busy[1];

