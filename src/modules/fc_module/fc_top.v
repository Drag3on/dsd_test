/* 
* fc_top.v
*/

`timescale 1ns / 1ps

module fc_top 
  #(
    parameter integer C_S00_AXIS_TDATA_WIDTH = 32
  )
  (
    input wire CLK,
    input wire RESETN,

    // AXIS protocol
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

    // APB protocol
    input wire [31:0] PADDR, 
    input wire PENABLE, 
    input wire PSEL, 
    input wire PWRITE, 
    input wire [31:0] PWDATA, 
    output wire [31:0] PRDATA, 
    output wire PREADY, 
    output wire PSLVERR
  );
  
  // For FC control path
  wire fc_start;
  wire fc_done;
  wire [31:0] clk_counter;
  wire [31:0] max_index;
  assign PREADY = 1'b1;
  assign PSLVERR = 1'b0;
  
  //todo myself
  wire [2:0] COMMAND;       //000 nothing, 001 read feature, 010 read bias, 100 read weight, 101 write result
  wire start_response;
  wire F_writedone;
  wire B_writedone;
  wire W_writedone;
  wire [20:0] receive_size;
  wire done_response;
  wire cal_done;  
  
  //used for test
  wire [2:0] test_read_state;
  wire [2:0] test_cal_state;
  wire [2:0] test_send_state;
  wire [17:0] test_bram_addr;
  wire [31:0] test_sending_data;
  wire [18:0] test_INPUT_SIZE;
  wire [20:0] test_OUTPUT_SIZE;
  wire [95:0] test_data;
  assign test_sendgin_data = M_AXIS_TDATA;
  
  clk_counter_fc u_clk_counter(
    .clk   (CLK),
    .rstn  (RESETN),
    .start (fc_start),
    .done  (fc_done),

    .clk_counter (clk_counter)
  );
  
  fc_apb u_fc_apb(
    .PCLK    (CLK),
    .PRESETB (RESETN),
    .PADDR   ({16'd0,PADDR[15:0]}),
    .PSEL    (PSEL),
    .PENABLE (PENABLE),
    .PWRITE  (PWRITE),
    .PWDATA  (PWDATA),
    .PRDATA  (PRDATA),

    .fc_start    (fc_start),
    .fc_done     (fc_done),
    .clk_counter (clk_counter),
    .max_index   (max_index),

    //////////////////////////////////////////////////////////////////////////
    // TODO : Add ports as you need
    .COMMAND       (COMMAND),      //000 nothing, 001 read feature, 010 read bias, 100 read weight, 101 write result
    .start_response(start_response),
    .F_writedone    (F_writedone),
    .B_writedone   (B_writedone),
    .W_writedone   (W_writedone),
    .receive_size  (receive_size),
    .done_response (done_response),
    .cal_done      (cal_done),
    
    //used for test
    .read_state(test_read_state),
    .cal_state(test_cal_state),
    .send_state(test_send_state),
    .bram_addr(test_bram_addr),
    .sending_data(test_sending_data),
    .INPUT_SIZE(test_INPUT_SIZE),
    .OUTPUT_SIZE(test_OUTPUT_SIZE),
    .test_data(test_data)
    //////////////////////////////////////////////////////////////////////////

  );
  
  fc_module u_fc_module(
    .clk  (CLK),
    .rstn (RESETN),

    .S_AXIS_TREADY (S_AXIS_TREADY),
    .S_AXIS_TDATA  (S_AXIS_TDATA),
    .S_AXIS_TKEEP  (S_AXIS_TKEEP),
    .S_AXIS_TUSER  (S_AXIS_TUSER),
    .S_AXIS_TLAST  (S_AXIS_TLAST),
    .S_AXIS_TVALID (S_AXIS_TVALID),

    .M_AXIS_TREADY (M_AXIS_TREADY),
    .M_AXIS_TUSER  (M_AXIS_TUSER),
    .M_AXIS_TDATA  (M_AXIS_TDATA),
    .M_AXIS_TKEEP  (M_AXIS_TKEEP),
    .M_AXIS_TLAST  (M_AXIS_TLAST),
    .M_AXIS_TVALID (M_AXIS_TVALID),

    .fc_start      (fc_start),
    .fc_done       (fc_done),
    //////////////////////////////////////////////////////////////////////////
    // TODO : Add ports as you need
    .COMMAND       (COMMAND),      //000 nothing, 001 read feature, 010 read bias, 100 read weight, 101 write result
    .start_response(start_response),
    .F_writedone    (F_writedone),
    .B_writedone   (B_writedone),
    .W_writedone   (W_writedone),
    .receive_size  (receive_size),
    .done_response (done_response),
    .cal_done      (cal_done),
    
    .max_index     (max_index),
    
    //used for test
    .test_read_state(test_read_state),
    .test_cal_state(test_cal_state),
    .test_send_state(test_send_state),
    .test_bram_addr(test_bram_addr),
    .test_INPUT_SIZE(test_INPUT_SIZE),
    .test_OUTPUT_SIZE(test_OUTPUT_SIZE),
    .test_data(test_data)
    
    //////////////////////////////////////////////////////////////////////////
  );
  
endmodule
