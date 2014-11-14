//Copyright 1986-2014 Xilinx, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2014.2 (lin64) Build 932637 Wed Jun 11 13:08:52 MDT 2014
//Date        : Tue Oct 21 16:29:31 2014
//Host        : elecpc228 running 64-bit Ubuntu 12.04.5 LTS
//Command     : generate_target design_1.bd
//Design      : design_1
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CORE_GENERATION_INFO = "design_1,IP_Integrator,{x_ipVendor=xilinx.com,x_ipLanguage=VERILOG,numBlks=2,numReposBlks=2,numNonXlnxBlks=0,numHierBlks=0,maxHierDepth=0,da_board_cnt=2}" *) 
module design_1
   (clock_rtl,
    data_in_from_pins,
    data_in_to_device,
    reset_rtl);
  input clock_rtl;
  input [0:0]data_in_from_pins;
  output [0:0]data_in_to_device;
  input reset_rtl;

  wire GND_1;
  wire clk_wiz_0_clk_out1;
  wire clock_rtl_1;
  wire [0:0]data_in_from_pins_1;
  wire reset_rtl_1;
  wire [0:0]selectio_wiz_0_data_in_to_device;

  assign clock_rtl_1 = clock_rtl;
  assign data_in_from_pins_1 = data_in_from_pins[0];
  assign data_in_to_device[0] = selectio_wiz_0_data_in_to_device;
  assign reset_rtl_1 = reset_rtl;
GND GND
       (.G(GND_1));
design_1_clk_wiz_0_0 clk_wiz_0
       (.clk_in1(clock_rtl_1),
        .clk_out1(clk_wiz_0_clk_out1),
        .reset(reset_rtl_1));
design_1_selectio_wiz_0_0 selectio_wiz_0
       (.clk_in(clk_wiz_0_clk_out1),
        .data_in_from_pins(data_in_from_pins_1),
        .data_in_to_device(selectio_wiz_0_data_in_to_device),
        .io_reset(GND_1));
endmodule
