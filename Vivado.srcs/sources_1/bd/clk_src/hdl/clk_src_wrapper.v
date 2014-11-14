//Copyright 1986-2014 Xilinx, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2014.1 (win64) Build 881834 Fri Apr  4 14:15:54 MDT 2014
//Date        : Thu Nov 13 16:51:20 2014
//Host        : ELECPC228 running 64-bit Service Pack 1  (build 7601)
//Command     : generate_target clk_src_wrapper.bd
//Design      : clk_src_wrapper
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

module clk_src_wrapper
   (CLK05,
    reset_rtl,
    sys_diff_clock_clk_n,
    sys_diff_clock_clk_p);
  output CLK05;
  input reset_rtl;
  input sys_diff_clock_clk_n;
  input sys_diff_clock_clk_p;

  wire CLK05;
  wire reset_rtl;
  wire sys_diff_clock_clk_n;
  wire sys_diff_clock_clk_p;

clk_src clk_src_i
       (.CLK05(CLK05),
        .reset_rtl(reset_rtl),
        .sys_diff_clock_clk_n(sys_diff_clock_clk_n),
        .sys_diff_clock_clk_p(sys_diff_clock_clk_p));
endmodule
