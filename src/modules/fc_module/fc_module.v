/*
* fc_module.v
*/

module fc_module
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

    input fc_start, 
    output reg fc_done,
    //////////////////////////////////////////////////////////////////////////
    // TODO : Add ports as you need
    input [2:0]     COMMAND,      //not using     //000 nothing, 001 read feature, 010 read bias, 100 read weight, 101 write result
    output reg      start_response,
    output reg      F_writedone,
    output reg      B_writedone,
    output reg      W_writedone,
    input [20:0]    receive_size, //not using
    input           done_response, //not using, may be need to use...
    output reg      cal_done,
    input [31:0]    max_index,
    
    //used for test
    output wire [2:0] test_read_state,
    output wire [2:0] test_cal_state,
    output wire [2:0] test_send_state,
    output wire [17:0] test_bram_addr,
    output wire [18:0]  test_INPUT_SIZE,
    output wire [20:0] test_OUTPUT_SIZE,
    output wire [95:0] test_data,
    output wire [17:0] test_send_bram_counter//
    
    //////////////////////////////////////////////////////////////////////////

  ); 
  //used for test
  assign test_read_state = read_state;
  assign test_cal_state = cal_state;
  assign test_send_state = send_state;
  assign test_bram_addr = bram_addr;
  assign test_INPUT_SIZE = INPUT_SIZE;
  assign test_OUTPUT_SIZE = OUTPUT_SIZE;
  assign test_send_bram_counter = send_bram_counter;
  reg [95:0] test_data_reg;
  assign test_data = test_data_reg;
  
  
  reg m_axis_tuser;
  reg [C_S00_AXIS_TDATA_WIDTH-1 : 0] m_axis_tdata;
  reg [(C_S00_AXIS_TDATA_WIDTH/8)-1 : 0] m_axis_tkeep;
  reg m_axis_tlast;
  reg m_axis_tvalid;
  reg s_axis_tready;
  
  assign S_AXIS_TREADY = s_axis_tready;
  assign M_AXIS_TDATA = m_axis_tdata;
  assign M_AXIS_TLAST = m_axis_tlast;
  assign M_AXIS_TVALID = m_axis_tvalid;
  assign M_AXIS_TUSER = 1'b0;
  assign M_AXIS_TKEEP = {(C_S00_AXIS_TDATA_WIDTH/8) {1'b1}};

  ////////////////////////////////////////////////////////////////////////////
  // TODO : Write your code here
  // mock cha
  // read data : read feature, read bias, read weight and save it to bram
  // read_state : IDLE, read feature, read bias, read weight
  // bram reg and address
  // bram of module
  // read state module and start_response
  // read working module
  
  //compute data and store result
  //calculate state
  //calculate answer reg with quantization

 //send state module
 //send working module
    
  //mock cha/

  // read data : read feature, read bias, read weight and save it to bram
  // read_state : IDLE, read feature, read bias, read weight
  reg [2:0] read_state;
  localparam READ_IDLE = 3'd0;
  localparam READ_FEATURE = 3'd1;
  localparam READ_BIAS = 3'd2;
  localparam READ_WEIGHT = 3'd3;
  
  //bram reg and address
  wire bram_en;
  wire bram_wen;
  wire [17:0] bram_addr;
  wire [31:0] bram_din;
  wire [31:0] bram_dout;
  
  reg read_bram_en;
  reg cal_bram_en;
  reg send_bram_en;
  
  reg read_bram_wen;
  reg cal_bram_wen;
  reg send_bram_wen;
  
  reg [17:0] read_bram_addr;
  reg [17:0] cal_bram_addr;
  reg [17:0] send_bram_addr;
  
  reg [31:0] read_bram_din;
  reg [31:0] cal_bram_din;
  
  assign bram_en = (send_state == SEND_IDLE)? ((cal_state == CAL_IDLE)? read_bram_en :cal_bram_en): send_bram_en;
  assign bram_wen = (send_state == SEND_IDLE)? ((cal_state == CAL_IDLE)? read_bram_wen :cal_bram_wen): send_bram_wen;  
  assign bram_addr = (send_state == SEND_IDLE)? ((cal_state == CAL_IDLE)? read_bram_addr :cal_bram_addr): send_bram_addr;
  assign bram_din = (cal_state == CAL_STORE_RESULT) ? cal_bram_din : read_bram_din;
  
  reg [17:0] bram_counter;
  
  localparam FEATURE_START_ADDRESS = 17'd0;
  localparam BIAS_START_ADDRESS = 17'd600;
  localparam WEIGHT_START_ADDRESS = 17'd1000;
  localparam DUMP_ADDRESS = {17{1'b1}};
  
  localparam RESULT_START_ADDRESS = 17'd80000;
  
  reg [8:0] INPUT_SIZE;
  reg [20:0] OUTPUT_SIZE;
  
  //bram of module
  fc_sram_32x131072 u_fc_sram_32x131072(
    .clka (clk),
    .ena  (bram_en),
    .wea  (bram_wen),
    .addra(bram_addr),
    .dina (bram_din),

    .douta(bram_dout)
  );
  
  //read_state module and start_response
  always@(posedge clk, negedge rstn)begin
    if(!rstn)begin
      read_state <= READ_IDLE;
      start_response <= 1'b0;
    end
    else begin
      case(read_state)
        READ_IDLE:begin
          if(fc_start)begin
            read_state <= READ_FEATURE;
          end
        end
        
        READ_FEATURE:begin
          if(F_writedone)begin
            if(COMMAND == 3'b010)begin
              read_state <= READ_BIAS;
            end
          end
        end
        
        READ_BIAS:begin
          if(B_writedone)begin
            if(COMMAND == 3'b100)begin
              read_state <= READ_WEIGHT;
            end
          end
        end
        
        READ_WEIGHT:begin
          if(W_writedone)begin
            if(S_AXIS_TLAST)begin
              
            end else begin
              read_state <= READ_IDLE;
            end
          end
        end
        
        default:begin
          read_state <= READ_IDLE;
        end
      endcase
    end
  end
  
  //read working module
  always@(posedge clk, negedge rstn)begin
    if(!rstn)begin
      read_bram_en <= 1'b0;
      read_bram_wen <= 1'b0;
      read_bram_addr <= DUMP_ADDRESS;
      read_bram_din <= 0;
      bram_counter <= 0;
      s_axis_tready <= 0;
      INPUT_SIZE <= 0;
      OUTPUT_SIZE <= 0;
      
      F_writedone <= 1'b0;
      B_writedone <= 1'b0;
      W_writedone <= 1'b0;
    end
    else begin
      case(read_state)
        READ_IDLE:begin
          if(fc_start)begin
            s_axis_tready <= 1'b1;
            bram_counter <= 0;
          end
          if(COMMAND==3'b101)begin
            F_writedone <= 1'b0;
            B_writedone <= 1'b0;
            W_writedone <= 1'b0;
          end
        end
        
        READ_FEATURE:begin
          if(F_writedone)begin
            read_bram_en <= 1'b0;
            read_bram_wen <= 1'b0;
            read_bram_addr <= DUMP_ADDRESS;
            bram_counter <= 0;
            read_bram_din <= 0;
            if(COMMAND == 3'b010)begin //going to next state 
              s_axis_tready <= 1'b1;
              OUTPUT_SIZE <= receive_size;
            end else begin
              s_axis_tready <= 1'b0;
            end
          end else begin
            if(S_AXIS_TVALID & s_axis_tready)begin
              read_bram_en <= 1'b1;
              read_bram_wen <= 1'b1;
              read_bram_addr <= FEATURE_START_ADDRESS + bram_counter;
              bram_counter <= bram_counter + 1;
              read_bram_din <= S_AXIS_TDATA;
              
              if(S_AXIS_TLAST)begin
                F_writedone <= 1'b1;
                s_axis_tready <= 1'b0;
                INPUT_SIZE <= bram_counter[8:0];
              end
            end
          end
        end
          
        READ_BIAS:begin
          if(B_writedone)begin
            read_bram_en <= 1'b0;
            read_bram_wen <= 1'b0;
            read_bram_addr <= DUMP_ADDRESS;
            bram_counter <= 0;
            read_bram_din <= 0;
            if(COMMAND == 3'b100)begin
              s_axis_tready <= 1'b1;
            end else begin
              s_axis_tready <= 1'b0;
            end
          end else begin
            if(S_AXIS_TVALID & s_axis_tready)begin
              read_bram_en <= 1'b1;
              read_bram_wen <= 1'b1;
              read_bram_addr <= BIAS_START_ADDRESS + bram_counter;
              bram_counter <= bram_counter + 1;
              read_bram_din <= S_AXIS_TDATA;
              if(S_AXIS_TLAST)begin
                B_writedone <= 1;
                s_axis_tready <= 0;
              end
            end
          end
        end
        
        READ_WEIGHT:begin
          if(W_writedone)begin
            read_bram_en <= 0;
            read_bram_wen <= 0;
            read_bram_addr <= DUMP_ADDRESS;
            read_bram_din <= 0;
            bram_counter <= 0;
          end else begin
            if(S_AXIS_TVALID & s_axis_tready)begin
              read_bram_en <= 1;
              read_bram_wen <= 1;
              read_bram_addr <= WEIGHT_START_ADDRESS + bram_counter;
              bram_counter <= bram_counter + 1;
              read_bram_din <= S_AXIS_TDATA;
                            
              if(S_AXIS_TLAST)begin
                if(bram_counter +1 == OUTPUT_SIZE*(INPUT_SIZE+1))begin
                  W_writedone <= 1;
                  s_axis_tready <= 0;
                end
              end
            end
          end
        end
        
        default:begin
        
        end
      endcase
    end
  end
  
  
  ///////////////////////////////////////////////////////////////////
  //compute data and store result
  //calculate state
  reg [2:0] cal_state;
  
  localparam CAL_IDLE = 3'd0;
  localparam CAL_GET_FW = 3'd1;
  localparam CAL_MULT_FW = 3'd2;
  localparam CAL_GET_BIAS = 3'd3;
  localparam CAL_STORE_RESULT = 3'd4;
  
  //calculate regs and result quantization
  reg signed [7:0] feature_buf1;
  reg signed [7:0] feature_buf2;
  reg signed [7:0] feature_buf3;
  reg signed [7:0] feature_buf4;
 
  reg signed [7:0] weight_buf1;
  reg signed [7:0] weight_buf2;
  reg signed [7:0] weight_buf3;
  reg signed [7:0] weight_buf4;
    
  reg signed [22:0] one_out;//final answer needs 23-bits?
  wire [7:0] quantized_one_out;
  wire [7:0] relu_quantized_one_out;
  reg [31:0] four_out;
  reg [1:0] four_counter;
  
  //couters
  reg [8:0] is_FW_INPUTSIZE_counter;
  reg [8:0] is_B_OUTPUTSIZE_counter;
  reg [2:0] delay;
  reg one_out_done;
  reg [7:0] max_data;
  reg [31:0] max_index_reg;
  
  assign quantized_one_out = (one_out[22] == 1 && &one_out[21:13] == 0) ? 8'b10_000000 : (one_out[22] == 0 && |one_out[21:13] == 1 ? 8'b01_111111 : one_out[13:6]);
  assign relu_quantized_one_out = (quantized_one_out[7] == 1) ? 8'd0 : quantized_one_out;
  //calculate state module
  always@(posedge clk, negedge rstn)begin
    if(!rstn)begin
      cal_state <= CAL_IDLE;
    end
    else begin
      case(cal_state)
        CAL_IDLE:begin
          if(cal_done)begin

          end else if(W_writedone)begin
            cal_state <= CAL_GET_FW;
          end
        end
        
        CAL_GET_FW:begin
          if(delay==3)begin
            cal_state <= CAL_MULT_FW;
          end
        end
        
        CAL_MULT_FW:begin
          if(is_FW_INPUTSIZE_counter < INPUT_SIZE)begin
            cal_state <= CAL_GET_FW;
          end else begin
            cal_state <= CAL_GET_BIAS;
          end
        end
        
        CAL_GET_BIAS:begin
          if(delay==2)begin
            cal_state <= CAL_STORE_RESULT;
          end
        end
        
        CAL_STORE_RESULT:begin
          if(cal_done)begin
            cal_state <= CAL_IDLE;
          end else begin
            if(delay==2)begin
              cal_state <= CAL_GET_FW;
            end
          end
        end
        
        default:begin
      end
      endcase
    end
  end
  
  //calculate working module
  always@(posedge clk, negedge rstn)begin
    if(!rstn)begin
      delay <= 0;
      one_out <= 0;
      one_out_done <= 1'b0;
      cal_bram_addr <= DUMP_ADDRESS;
      is_FW_INPUTSIZE_counter <= 0;
      is_B_OUTPUTSIZE_counter <= 0;
      four_out <= 0;
      cal_bram_en <= 1'b0;
      cal_bram_wen <= 1'b0;
      cal_bram_din <= 0;
      four_counter <= 0;
      delay <= 0;
      feature_buf1 <= 0;
      feature_buf2 <= 0;
      feature_buf3 <= 0;
      feature_buf4 <= 0;
      
      weight_buf1 <= 0;
      weight_buf2 <= 0;
      weight_buf3 <= 0;
      weight_buf4 <= 0;
      
      cal_done <= 1'b0;
      max_data <= 0;
      max_index_reg <= 0;
    end
    else begin
      case(cal_state)
        CAL_IDLE:begin
          is_FW_INPUTSIZE_counter <= 0;
          is_B_OUTPUTSIZE_counter <= 0;
          delay <= 0;
          four_out <= 0;
          feature_buf1 <= 0;
          feature_buf2 <= 0;
          feature_buf3 <= 0;
          feature_buf4 <= 0;
          
          weight_buf1 <= 0;
          weight_buf2 <= 0;
          weight_buf3 <= 0;
          weight_buf4 <= 0;
          one_out <= 0;
          cal_bram_en <= 1'b0;
          cal_bram_wen <= 1'b0;
          cal_bram_addr <= DUMP_ADDRESS;
          cal_bram_din <= 0;
          
          max_data <= 0;
          max_index_reg <= 0;
          
          one_out_done <= 1'b0;
          if(COMMAND==3'b101)begin
            cal_done <= 1'b0;
          end
        end
        
        CAL_GET_FW:begin
          if(delay < 3)begin
            delay <= delay + 1;
          end else begin
            delay <= 0;
          end
          
          if(delay==0)begin //order feature data
            cal_bram_en <= 1'b1;
            cal_bram_wen <= 1'b0;
            cal_bram_addr <= FEATURE_START_ADDRESS + is_FW_INPUTSIZE_counter;
            
          end else if(delay==1)begin //order weight data
            cal_bram_en <= 1'b1;
            cal_bram_wen <= 1'b0;
            cal_bram_addr <= WEIGHT_START_ADDRESS + is_FW_INPUTSIZE_counter + is_B_OUTPUTSIZE_counter*(INPUT_SIZE+1);
            
          end else if(delay == 2)begin //get feature data
            cal_bram_en <= 1'b0;
            cal_bram_wen <= 1'b0;
            cal_bram_addr <= DUMP_ADDRESS;
            {feature_buf1, feature_buf2, feature_buf3, feature_buf4} <= bram_dout;
            
          end else if(delay == 3)begin //get weight data
            cal_bram_en <= 1'b0;
            cal_bram_wen <= 1'b0;
            {weight_buf1, weight_buf2, weight_buf3, weight_buf4} <= bram_dout;
          end
        end

        CAL_MULT_FW:begin
          one_out <= one_out + feature_buf1*weight_buf1 + feature_buf2*weight_buf2 + feature_buf3*weight_buf3 + feature_buf4*weight_buf4;
          if(is_FW_INPUTSIZE_counter < INPUT_SIZE)begin
            is_FW_INPUTSIZE_counter <= is_FW_INPUTSIZE_counter + 1;
          end else begin
            is_FW_INPUTSIZE_counter <= 0;
          end
        end
        
        CAL_GET_BIAS:begin          
          if(delay==0)begin
            cal_bram_en <= 1;
            cal_bram_wen <= 0;
            cal_bram_addr <= BIAS_START_ADDRESS + is_B_OUTPUTSIZE_counter[7:2];
            delay <= delay + 1;
          end else if(delay==2)begin
            delay <= 0;
            case(is_B_OUTPUTSIZE_counter[1:0])
              2'd0 :begin
                one_out <= one_out + {{9{bram_dout[7]}}, bram_dout[7:0], 6'd0};
              end
              2'd1 :begin
                one_out <= one_out + {{9{bram_dout[15]}}, bram_dout[15:8], 6'd0};
              end
              2'd2 :begin
                one_out <= one_out + {{9{bram_dout[23]}}, bram_dout[23:16], 6'd0};
              end
              
              default:begin
                one_out <= one_out + {{9{bram_dout[31]}}, bram_dout[31:24], 6'd0};
              end
            endcase
          end else begin
            delay <= delay + 1;
          end
        end
                
        CAL_STORE_RESULT:begin
          if(delay==0)begin//make four_data
            if(OUTPUT_SIZE == 10)begin
              four_out <= {quantized_one_out, four_out[31:8]};
              if(max_data > quantized_one_out)begin
              end else begin
                max_data <= quantized_one_out;
                four_counter <= 1;
                max_index_reg <= is_B_OUTPUTSIZE_counter;
              end
            end else begin
              four_out <= {relu_quantized_one_out, four_out[31:8]};
            end
            one_out <= 0;
            delay <= delay + 1;
          end else if(delay == 1)begin //store data
            delay <= delay + 1;
            cal_bram_en <= 1'b1;
            cal_bram_wen <= 1'b1;
            cal_bram_addr <= RESULT_START_ADDRESS + is_B_OUTPUTSIZE_counter[7:2];
            cal_bram_din <= four_out;
            
            if(is_B_OUTPUTSIZE_counter == OUTPUT_SIZE -1)begin
              is_B_OUTPUTSIZE_counter <= 0;
              cal_done <= 1'b1;
            end else begin
              is_B_OUTPUTSIZE_counter <= is_B_OUTPUTSIZE_counter + 1;
            end
            
          end else begin //delay == 2
            cal_bram_en <= 1'b0;
            cal_bram_wen <= 1'b0;
            cal_bram_addr <= DUMP_ADDRESS;
            delay <= 0;
          end
        end
        
      endcase
    end
  end
  
  //send data
  //send state and address
  reg [2:0] send_state;
  
  localparam SEND_IDLE = 3'd0;
  localparam GET_RESULT = 3'd1;
  
  reg [17:0] send_bram_counter;
  
  reg done_delay_done;
  
  //send state module
  always@(posedge clk, negedge rstn)begin
    if(!rstn)begin
      send_state <= SEND_IDLE;
    end
    else begin
      case(send_state)
        SEND_IDLE:begin
          if(!done_response && COMMAND == 3'b101)begin
            send_state <= GET_RESULT;
          end
        end
        
        GET_RESULT:begin
          if(fc_done && done_response)begin
            send_state <= SEND_IDLE;
          end
        end
      
        default:begin
        
        end
      endcase
    end
  end
  
  reg [2:0] send_delay;
  
  //send result module
  always@(posedge clk, negedge rstn)begin
    if(!rstn)begin
      send_bram_en <= 1'b0;
      send_bram_wen <= 1'b0;
      send_bram_counter <= 0;
      send_bram_addr <= DUMP_ADDRESS;
      m_axis_tvalid <= 1'b0;
      m_axis_tlast <= 1'b0;
      m_axis_tdata <= 0;
      send_delay <= 0;
      fc_done <= 1'b0;
      done_delay_done <= 1'b0;
    end
    else begin
      case(send_state)
        SEND_IDLE:begin
          m_axis_tvalid <= 1'b0;
          m_axis_tlast <= 1'b0;
          m_axis_tdata <= 0;
          send_bram_en <= 1'b0;
          send_bram_wen <= 1'b0;
          send_bram_addr <= DUMP_ADDRESS;
          send_bram_counter <= 0;
          send_delay <= 0;
          fc_done <= 1'b0;
          done_delay_done <= 1'b0;

        end
        
        GET_RESULT:begin
          if(fc_done)begin
            if(done_response)begin
              fc_done <= 1'b0;
            end
          end else begin
            if(m_axis_tvalid)begin //my data ready
              if(M_AXIS_TREADY)begin //data transfer occurs
                m_axis_tvalid <= 1'b0;
                m_axis_tlast <= 1'b0;
                send_bram_counter <= send_bram_counter + 1;
                m_axis_tdata <= 0;
                if({send_bram_counter, 2'b00} + 4 >= OUTPUT_SIZE)begin
                  fc_done <= 1'b1;
                  send_bram_counter <= 0;
                end
              end
            end else begin//need to ready my data
              if(send_delay == 0)begin
                send_bram_en <= 1'b1;
                send_bram_wen <= 1'b0;
                send_bram_addr <= RESULT_START_ADDRESS + send_bram_counter;
                send_delay <= send_delay + 1;
              end else if(send_delay == 2)begin
                m_axis_tdata <= bram_dout;
                send_delay <= 0;
                m_axis_tvalid <= 1'b1;
                
                if({send_bram_counter, 2'b00} >= OUTPUT_SIZE - 4)begin
                  m_axis_tlast <= 1'b1;
                end
                
              end else begin
                send_delay <= send_delay + 1;
                send_bram_en <= 1'b0;
                send_bram_wen <= 1'b0;
                send_bram_addr <= DUMP_ADDRESS;
              end
            end
          end
        end
        
        default:begin
      
        end
      endcase  
    end
  end
  
  
  

  
  
  ////////////////////////////////////////////////////////////////////////////
  
  
endmodule
