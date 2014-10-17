assign rx_data[1][3] = tx_data[0][1];
assign tx_busy[0][1] = rx_busy[1][3];

assign rx_data[0][1] = tx_data[1][3];
assign tx_busy[1][3] = rx_busy[0][1];

assign rx_data[2][3] = tx_data[1][1];
assign tx_busy[1][1] = rx_busy[2][3];

assign rx_data[1][1] = tx_data[2][3];
assign tx_busy[2][3] = rx_busy[1][1];

assign rx_data[4][3] = tx_data[3][1];
assign tx_busy[3][1] = rx_busy[4][3];

assign rx_data[3][1] = tx_data[4][3];
assign tx_busy[4][3] = rx_busy[3][1];

assign rx_data[5][3] = tx_data[4][1];
assign tx_busy[4][1] = rx_busy[5][3];

assign rx_data[4][1] = tx_data[5][3];
assign tx_busy[5][3] = rx_busy[4][1];

assign rx_data[7][3] = tx_data[6][1];
assign tx_busy[6][1] = rx_busy[7][3];

assign rx_data[6][1] = tx_data[7][3];
assign tx_busy[7][3] = rx_busy[6][1];

assign rx_data[8][3] = tx_data[7][1];
assign tx_busy[7][1] = rx_busy[8][3];

assign rx_data[7][1] = tx_data[8][3];
assign tx_busy[8][3] = rx_busy[7][1];

assign rx_data[3][0] = tx_data[0][2];
assign tx_busy[0][2] = rx_busy[3][0];

assign rx_data[0][2] = tx_data[3][0];
assign tx_busy[3][0] = rx_busy[0][2];

assign rx_data[4][0] = tx_data[1][2];
assign tx_busy[1][2] = rx_busy[4][0];

assign rx_data[1][2] = tx_data[4][0];
assign tx_busy[4][0] = rx_busy[1][2];

assign rx_data[5][0] = tx_data[2][2];
assign tx_busy[2][2] = rx_busy[5][0];

assign rx_data[2][2] = tx_data[5][0];
assign tx_busy[5][0] = rx_busy[2][2];

assign rx_data[6][0] = tx_data[3][2];
assign tx_busy[3][2] = rx_busy[6][0];

assign rx_data[3][2] = tx_data[6][0];
assign tx_busy[6][0] = rx_busy[3][2];

assign rx_data[7][0] = tx_data[4][2];
assign tx_busy[4][2] = rx_busy[7][0];

assign rx_data[4][2] = tx_data[7][0];
assign tx_busy[7][0] = rx_busy[4][2];

assign rx_data[8][0] = tx_data[5][2];
assign tx_busy[5][2] = rx_busy[8][0];

assign rx_data[5][2] = tx_data[8][0];
assign tx_busy[8][0] = rx_busy[5][2];

assign tx_busy[0][0] = 0;
assign rx_data[0][0] = 0;
assign tx_busy[6][2] = 0;
assign rx_data[6][2] = 0;
assign tx_busy[1][0] = 0;
assign rx_data[1][0] = 0;
assign tx_busy[7][2] = 0;
assign rx_data[7][2] = 0;
assign tx_busy[2][0] = 0;
assign rx_data[2][0] = 0;
assign tx_busy[8][2] = 0;
assign rx_data[8][2] = 0;
assign tx_busy[0][3] = 0;
assign rx_data[0][3] = 0;
assign tx_busy[2][1] = 0;
assign rx_data[2][1] = 0;
assign tx_busy[3][3] = 0;
assign rx_data[3][3] = 0;
assign tx_busy[5][1] = 0;
assign rx_data[5][1] = 0;
assign tx_busy[6][3] = 0;
assign rx_data[6][3] = 0;
assign tx_busy[8][1] = 0;
assign rx_data[8][1] = 0;
assign rx_data[0][4] = source_data[0];
assign source_busy[0] = rx_busy[0][4];

assign sink_data[0] = tx_data[0][4];
assign tx_busy[0][4] = sink_busy[0];

assign rx_data[1][4] = source_data[1];
assign source_busy[1] = rx_busy[1][4];

assign sink_data[1] = tx_data[1][4];
assign tx_busy[1][4] = sink_busy[1];

assign rx_data[2][4] = source_data[2];
assign source_busy[2] = rx_busy[2][4];

assign sink_data[2] = tx_data[2][4];
assign tx_busy[2][4] = sink_busy[2];

assign rx_data[3][4] = source_data[3];
assign source_busy[3] = rx_busy[3][4];

assign sink_data[3] = tx_data[3][4];
assign tx_busy[3][4] = sink_busy[3];

assign rx_data[4][4] = source_data[4];
assign source_busy[4] = rx_busy[4][4];

assign sink_data[4] = tx_data[4][4];
assign tx_busy[4][4] = sink_busy[4];

assign rx_data[5][4] = source_data[5];
assign source_busy[5] = rx_busy[5][4];

assign sink_data[5] = tx_data[5][4];
assign tx_busy[5][4] = sink_busy[5];

assign rx_data[6][4] = source_data[6];
assign source_busy[6] = rx_busy[6][4];

assign sink_data[6] = tx_data[6][4];
assign tx_busy[6][4] = sink_busy[6];

assign rx_data[7][4] = source_data[7];
assign source_busy[7] = rx_busy[7][4];

assign sink_data[7] = tx_data[7][4];
assign tx_busy[7][4] = sink_busy[7];

assign rx_data[8][4] = source_data[8];
assign source_busy[8] = rx_busy[8][4];

assign sink_data[8] = tx_data[8][4];
assign tx_busy[8][4] = sink_busy[8];

