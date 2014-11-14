//Copyright 1986-2014 Xilinx, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2014.1 (win64) Build 881834 Fri Apr  4 14:15:54 MDT 2014
//Date        : Thu Nov 13 16:51:20 2014
//Host        : ELECPC228 running 64-bit Service Pack 1  (build 7601)
//Command     : generate_target clk_src.bd
//Design      : clk_src
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CORE_GENERATION_INFO = "clk_src,IP_Integrator,{x_ipVendor=xilinx.com,x_ipLanguage=VERILOG,numBlks=1,numReposBlks=1,numNonXlnxBlks=0,numHierBlks=0,maxHierDepth=0,da_board_cnt=2}" *) 
module clk_src
   (CLK05,
    reset_rtl,
    sys_diff_clock_clk_n,
    sys_diff_clock_clk_p);
  output CLK05;
  input reset_rtl;
  input sys_diff_clock_clk_n;
  input sys_diff_clock_clk_p;

  wire clk_wiz_0_clk_out1;
  wire reset_rtl_1;
  wire sys_diff_clock_1_CLK_N;
  wire sys_diff_clock_1_CLK_P;

  assign CLK05 = clk_wiz_0_clk_out1;
  assign reset_rtl_1 = reset_rtl;
  assign sys_diff_clock_1_CLK_N = sys_diff_clock_clk_n;
  assign sys_diff_clock_1_CLK_P = sys_diff_clock_clk_p;
clk_src_clk_wiz_0_1 clk_wiz_0
       (.clk_in1_n(sys_diff_clock_1_CLK_N),
        .clk_in1_p(sys_diff_clock_1_CLK_P),
        .clk_out1(clk_wiz_0_clk_out1),
        .reset(reset_rtl_1));
endmodule
