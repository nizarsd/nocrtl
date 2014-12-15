//Copyright 1986-2014 Xilinx, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2014.2 (lin64) Build 932637 Wed Jun 11 13:08:52 MDT 2014
//Date        : Thu Dec  4 15:15:25 2014
//Host        : elecpc228 running 64-bit Ubuntu 12.04.5 LTS
//Command     : generate_target design_1.bd
//Design      : design_1
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CORE_GENERATION_INFO = "design_1,IP_Integrator,{x_ipVendor=xilinx.com,x_ipLanguage=VERILOG,numBlks=1,numReposBlks=1,numNonXlnxBlks=0,numHierBlks=0,maxHierDepth=0,da_board_cnt=2}" *) 
module design_1
   (clk);
  input clk;

  wire GND_1;
  wire clk_1;

  assign clk_1 = clk;
GND GND
       (.G(GND_1));
design_1_ila_0_0 ila_0
       (.clk(clk_1),
        .probe0(GND_1),
        .probe1({GND_1,GND_1,GND_1,GND_1,GND_1,GND_1,GND_1,GND_1,GND_1,GND_1,GND_1,GND_1,GND_1,GND_1,GND_1,GND_1,GND_1,GND_1,GND_1,GND_1,GND_1,GND_1,GND_1,GND_1,GND_1,GND_1,GND_1,GND_1,GND_1,GND_1,GND_1,GND_1}),
        .probe10({GND_1,GND_1,GND_1,GND_1,GND_1,GND_1,GND_1,GND_1,GND_1,GND_1,GND_1,GND_1,GND_1,GND_1,GND_1,GND_1,GND_1,GND_1,GND_1,GND_1,GND_1,GND_1,GND_1,GND_1,GND_1,GND_1,GND_1,GND_1,GND_1,GND_1,GND_1,GND_1}),
        .probe11(GND_1),
        .probe12(GND_1),
        .probe13({GND_1,GND_1}),
        .probe14({GND_1,GND_1,GND_1,GND_1,GND_1,GND_1,GND_1,GND_1,GND_1,GND_1,GND_1,GND_1,GND_1,GND_1,GND_1,GND_1,GND_1,GND_1,GND_1,GND_1,GND_1,GND_1,GND_1,GND_1,GND_1,GND_1,GND_1,GND_1,GND_1,GND_1,GND_1,GND_1}),
        .probe15({GND_1,GND_1,GND_1,GND_1}),
        .probe16(GND_1),
        .probe17(GND_1),
        .probe18(GND_1),
        .probe19(GND_1),
        .probe2({GND_1,GND_1}),
        .probe20(GND_1),
        .probe21({GND_1,GND_1,GND_1,GND_1,GND_1,GND_1,GND_1,GND_1}),
        .probe22(GND_1),
        .probe23({GND_1,GND_1,GND_1}),
        .probe24({GND_1,GND_1}),
        .probe25(GND_1),
        .probe26(GND_1),
        .probe27({GND_1,GND_1,GND_1,GND_1,GND_1,GND_1,GND_1,GND_1}),
        .probe28({GND_1,GND_1,GND_1}),
        .probe29({GND_1,GND_1}),
        .probe3(GND_1),
        .probe30(GND_1),
        .probe31({GND_1,GND_1,GND_1,GND_1}),
        .probe32({GND_1,GND_1,GND_1,GND_1}),
        .probe33({GND_1,GND_1,GND_1,GND_1}),
        .probe34({GND_1,GND_1,GND_1,GND_1}),
        .probe35(GND_1),
        .probe36({GND_1,GND_1,GND_1,GND_1}),
        .probe37({GND_1,GND_1,GND_1,GND_1}),
        .probe38(GND_1),
        .probe39(GND_1),
        .probe4(GND_1),
        .probe41(GND_1),
        .probe42(GND_1),
        .probe43(GND_1),
        .probe44(GND_1),
        .probe5({GND_1,GND_1,GND_1,GND_1,GND_1,GND_1,GND_1,GND_1,GND_1,GND_1,GND_1,GND_1,GND_1,GND_1,GND_1,GND_1,GND_1,GND_1,GND_1,GND_1,GND_1,GND_1,GND_1,GND_1,GND_1,GND_1,GND_1,GND_1,GND_1,GND_1,GND_1,GND_1}),
        .probe6({GND_1,GND_1,GND_1}),
        .probe7({GND_1,GND_1,GND_1}),
        .probe8(GND_1),
        .probe9(GND_1));
endmodule
