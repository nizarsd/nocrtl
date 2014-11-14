//Copyright 1986-2014 Xilinx, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2014.2 (lin64) Build 932637 Wed Jun 11 13:08:52 MDT 2014
//Date        : Tue Oct 21 16:29:31 2014
//Host        : elecpc228 running 64-bit Ubuntu 12.04.5 LTS
//Command     : generate_target design_1_wrapper.bd
//Design      : design_1_wrapper
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

module design_1_wrapper
   (clock_rtl,
    data_in_from_pins,
    data_in_to_device,
    reset_rtl);
  input clock_rtl;
  input [0:0]data_in_from_pins;
  output [0:0]data_in_to_device;
  input reset_rtl;

  wire clock_rtl;
  wire [0:0]data_in_from_pins;
  wire [0:0]data_in_to_device;
  wire reset_rtl;

design_1 design_1_i
       (.clock_rtl(clock_rtl),
        .data_in_from_pins(data_in_from_pins),
        .data_in_to_device(data_in_to_device),
        .reset_rtl(reset_rtl));
endmodule
