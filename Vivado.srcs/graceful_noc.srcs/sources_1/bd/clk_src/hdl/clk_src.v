//Copyright 1986-2014 Xilinx, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2014.2 (lin64) Build 932637 Wed Jun 11 13:08:52 MDT 2014
//Date        : Tue Dec  9 16:39:24 2014
//Host        : elecpc228 running 64-bit Ubuntu 12.04.5 LTS
//Command     : generate_target clk_src.bd
//Design      : clk_src
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CORE_GENERATION_INFO = "clk_src,IP_Integrator,{x_ipVendor=xilinx.com,x_ipLanguage=VERILOG,numBlks=1,numReposBlks=1,numNonXlnxBlks=0,numHierBlks=0,maxHierDepth=0}" *) 
module clk_src
   (CLK05,
    CLK100,
    reset_rtl,
    sys_diff_clock_clk_n,
    sys_diff_clock_clk_p);
  output CLK05;
  output CLK100;
  input reset_rtl;
  input sys_diff_clock_clk_n;
  input sys_diff_clock_clk_p;

  wire clk_wiz_0_clk_out1;
  wire clk_wiz_0_clk_out3;
  wire reset_rtl_1;
  wire sys_diff_clock_1_CLK_N;
  wire sys_diff_clock_1_CLK_P;

  assign CLK05 = clk_wiz_0_clk_out1;
  assign CLK100 = clk_wiz_0_clk_out3;
  assign reset_rtl_1 = reset_rtl;
  assign sys_diff_clock_1_CLK_N = sys_diff_clock_clk_n;
  assign sys_diff_clock_1_CLK_P = sys_diff_clock_clk_p;
clk_src_clk_wiz_0_1 clk_wiz_0
       (.clk_in1_n(sys_diff_clock_1_CLK_N),
        .clk_in1_p(sys_diff_clock_1_CLK_P),
        .clk_out1(clk_wiz_0_clk_out1),
        .clk_out2(clk_wiz_0_clk_out3),
        .reset(reset_rtl_1));
endmodule
