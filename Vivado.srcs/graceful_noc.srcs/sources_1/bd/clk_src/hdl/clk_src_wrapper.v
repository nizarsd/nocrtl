//Copyright 1986-2014 Xilinx, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2014.2 (lin64) Build 932637 Wed Jun 11 13:08:52 MDT 2014
//Date        : Tue Dec  9 16:39:24 2014
//Host        : elecpc228 running 64-bit Ubuntu 12.04.5 LTS
//Command     : generate_target clk_src_wrapper.bd
//Design      : clk_src_wrapper
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

module clk_src_wrapper
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

  wire CLK05;
  wire CLK100;
  wire reset_rtl;
  wire sys_diff_clock_clk_n;
  wire sys_diff_clock_clk_p;

clk_src clk_src_i
       (.CLK05(CLK05),
        .CLK100(CLK100),
        .reset_rtl(reset_rtl),
        .sys_diff_clock_clk_n(sys_diff_clock_clk_n),
        .sys_diff_clock_clk_p(sys_diff_clock_clk_p));
endmodule
