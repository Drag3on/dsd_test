// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2022.2 (win64) Build 3671981 Fri Oct 14 05:00:03 MDT 2022
// Date        : Sat Dec  2 17:29:18 2023
// Host        : DESKTOP-UA3I8HH running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode synth_stub
//               c:/Users/Jsangwook/Desktop/DSD_Project/dsd-final-project-team11/src/common_ip/clk_gen/clk_gen_stub.v
// Design      : clk_gen
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7a100tcsg324-1
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
module clk_gen(clk_100mhz, clk_200mhz, clk_325mhz, resetn, 
  clk_in1)
/* synthesis syn_black_box black_box_pad_pin="clk_100mhz,clk_200mhz,clk_325mhz,resetn,clk_in1" */;
  output clk_100mhz;
  output clk_200mhz;
  output clk_325mhz;
  input resetn;
  input clk_in1;
endmodule
