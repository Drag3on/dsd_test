/*
* fc_apb.v
*/

module fc_apb
  (
    input wire PCLK,
    input wire PRESETB,        // APB asynchronous reset (0: reset, 1: normal)
    input wire [31:0] PADDR,   // APB address
    input wire PSEL,           // APB select
    input wire PENABLE,        // APB enable
    input wire PWRITE,         // APB write enable
    input wire [31:0] PWDATA,  // APB write data
    output wire [31:0] PRDATA,  // CPU interface out

    input wire [31:0] clk_counter,
    input wire [31:0] max_index,
    input wire [0:0] fc_done,
    output reg [0:0] fc_start,

    //////////////////////////////////////////////////////////////////////////
    // TODO : Add ports as you need
    output reg [2:0] COMMAND,       //000 nothing, 001 read feature, 010 read bias, 100 read weight, 101 write result
    input wire       start_response,
    input wire       F_writedone,
    input wire       B_writedone,
    input wire       W_writedone,
    output reg [20:0]    receive_size,
    output reg       done_response, //not using, may be need to use...
    input wire       cal_done,
    
    //used for test
    input wire [2:0] read_state,
    input wire [2:0] cal_state,
    input wire [2:0] send_state,
    input wire [17:0] bram_addr,
    input wire [31:0] sending_data,
    input wire [18:0] INPUT_SIZE,
    input wire [20:0] OUTPUT_SIZE,
    input wire [95:0] test_data
    //////////////////////////////////////////////////////////////////////////
    
  );

  wire state_enable;
  wire state_enable_pre;
  reg [31:0] prdata_reg;
  
  assign state_enable = PSEL & PENABLE;
  assign state_enable_pre = PSEL & ~PENABLE;
  
  ////////////////////////////////////////////////////////////////////////////
  // TODO : Write your code here
  ////////////////////////////////////////////////////////////////////////////
  
  // READ OUTPUT
  always @(posedge PCLK, negedge PRESETB) begin
    if (PRESETB == 1'b0) begin
      prdata_reg <= 32'h00000000;
    end
    else begin
      if (~PWRITE & state_enable_pre) begin
        case ({PADDR[31:2], 2'h0})
          /*READOUT*/
          32'h00000008 : prdata_reg <= clk_counter; // Do not fix!
          32'h0000000c : prdata_reg <= fc_done;
          32'h00000010 : prdata_reg <= max_index;
          32'h00000014 : prdata_reg <= F_writedone;
          32'h00000018 : prdata_reg <= B_writedone;
          32'h0000001c : prdata_reg <= W_writedone;
          32'h00000100 : prdata_reg <= {8'd0,5'd0,read_state,5'd0,cal_state,5'd0,send_state};
          32'h00000200 : prdata_reg <= bram_addr;
          32'h00000300 : prdata_reg <= {31'd0,fc_start};
          32'h00000400 : prdata_reg <= {7'd0, F_writedone,7'd0,B_writedone,7'd0,W_writedone,7'd0,cal_done};
          32'h00000500 : prdata_reg <= INPUT_SIZE;
          32'h00000600 : prdata_reg <= OUTPUT_SIZE;
          32'h00000700 : prdata_reg <= test_data[31:0];
          32'h00000800 : prdata_reg <= test_data[63:32];
          32'h00000900 : prdata_reg <= test_data[95:64];
          
          32'h00000a00 : prdata_reg <= sending_data;
          default: prdata_reg <= 32'h0;
        endcase
      end
      else begin
        prdata_reg <= 32'h0;
      end
    end
  end
  
  assign PRDATA = (~PWRITE & state_enable) ? prdata_reg : 32'h00000000;
  
  // WRITE ACCESS
  always @(posedge PCLK, negedge PRESETB) begin
    if (PRESETB == 1'b0) begin
      /*WRITERES*/
      fc_start <= 1'b0;
      
    end
    else begin
      if (PWRITE & state_enable) begin
        case ({PADDR[31:2], 2'h0})
          /*WRITEIN*/
          32'h00000000 : begin
            if(PWDATA == 32'h00000005) begin
              fc_start <= 1'b1;
              done_response <= 1'b0;
            end else if(PWDATA == 32'h00000001)begin
              COMMAND <= 3'b001;
              fc_start <= 1'b0;
            end else if(PWDATA == 32'h00000002)begin
              COMMAND <= 3'b010;
            end else if(PWDATA == 32'h00000004)begin
              COMMAND <= 3'b100;
            end else if(PWDATA == 32'h00000006)begin
              COMMAND <= 3'b101;
            end else if(PWDATA == 32'h00000000)begin
              done_response <= 1'b1;
            end
          end
          32'h00000004 : begin
            receive_size <= PWDATA;            
          end
          default:;
        endcase
      end
    end
  end
endmodule
  
