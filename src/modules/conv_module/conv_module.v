/*
* conv_module.v
*/

module conv_module 
  #(
    parameter integer C_S00_AXIS_TDATA_WIDTH = 32
  )
  (
    input wire clk,
    input wire rstn,

    output wire S_AXIS_TREADY,
    input wire [C_S00_AXIS_TDATA_WIDTH-1 : 0] S_AXIS_TDATA,
    input wire [(C_S00_AXIS_TDATA_WIDTH/8)-1 : 0] S_AXIS_TKEEP, 
    input wire S_AXIS_TUSER, 
    input wire S_AXIS_TLAST, 
    input wire S_AXIS_TVALID, 

    input wire M_AXIS_TREADY, 
    output wire M_AXIS_TUSER, 
    output wire [C_S00_AXIS_TDATA_WIDTH-1 : 0] M_AXIS_TDATA, 
    output wire [(C_S00_AXIS_TDATA_WIDTH/8)-1 : 0] M_AXIS_TKEEP, 
    output wire M_AXIS_TLAST, 
    output wire M_AXIS_TVALID, 

    input conv_start, 
    output reg conv_done,

    //////////////////////////////////////////////////////////////////////////
    // TODO : Add ports if you need them
    //////////////////////////////////////////////////////////////////////////
    input [2:0] COMMAND,    // IDLE : 3'b000  //    Feature receive, 3'b001  // Bias receive :   3'b010 // Calculation start  3'b011 // Data Transmit 3'b100 //
    input [8:0] InCh,        // Number of Input Channel -> Maximum : 256
    input [8:0] OutCh,       // Number of Output Channel -> Maximum : 256
    input [5:0] FLength,    // Columb Size of Input Feature Map -> Maximum : 32
    output F_writedone,
    output B_writedone,
    output rdy_to_transmit,
    output transmit_done,
    input  F_writedone_respond,
    input  B_writedone_respond,
    input  rdy_to_transmit_respond,
    input  transmit_done_respond

  );
  
  reg                                           m_axis_tuser;
  reg [C_S00_AXIS_TDATA_WIDTH-1 : 0]            m_axis_tdata;
  reg [(C_S00_AXIS_TDATA_WIDTH/8)-1 : 0]        m_axis_tkeep;
  reg                                           m_axis_tlast;
  reg                                           m_axis_tvalid;
  wire                                          s_axis_tready;
  
  assign S_AXIS_TREADY = s_axis_tready;
  assign M_AXIS_TDATA = m_axis_tdata;
  assign M_AXIS_TLAST = m_axis_tlast;
  assign M_AXIS_TVALID = m_axis_tvalid;
  assign M_AXIS_TUSER = 1'b0;
  assign M_AXIS_TKEEP = {(C_S00_AXIS_TDATA_WIDTH/8) {1'b1}};

  ////////////////////////////////////////////////////////////////////////////
  // TODO : Write your code here
  ////////////////////////////////////////////////////////////////////////////

  
endmodule
