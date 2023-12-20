`timescale 1ns / 1ps


module tb;
     
    // system parameters
    parameter   CLK_PERIOD          = 2.5;              // 400MHz
    parameter   HALF_CLK_PERIODD    = CLK_PERIOD / 2;
    
    // addresses for vdma registers 
    parameter   S2MM_VDMACR_REG_ADDR        = 32'h00000030;
    parameter   S2MM_START_ADDRESS_REG_ADDR = 32'h000000AC;
    parameter   S2MM_FRMDLY_STRIDE_REG_ADDR = 32'h000000A8;
    parameter   S2MM_HSIZE_REG_ADDR         = 32'h000000A4;
    parameter   S2MM_VSIZE_REG_ADDR         = 32'h000000A0;
    
    parameter   MM2S_VDMACR_REG_ADDR        = 32'h00000000;
    parameter   MM2S_START_ADDRESS_REG_ADDR = 32'h0000005C;
    parameter   MM2S_FRMDLY_STRIDE_REG_ADDR = 32'h00000058;
    parameter   MM2S_HSIZE_REG_ADDR         = 32'h00000054;
    parameter   MM2S_VSIZE_REG_ADDR         = 32'h00000050;
    
    
    parameter   INPUT_SIZE = 32'd1024; //was 256
    parameter   OUTPUT_SIZE = 32'd256; //was 64
    
    // HSIZE*VSIZE 가 각 데이터의 양 ( 8-bit의 수 = byte 수) 입니다. 일반적으로 VSIZE를 1 로하고 HSZIE 만으로 표현하면 되며 HSIZE가 클 때만 유의하시면 됩니다.
    // STRIDE SIZE 와 HSIZE는 동일합니다.
    parameter   FEATURE_BASE_ADDR   = 32'h0000_1000;    // 00000_0000 일 경우 첫 번째 데이터가 안 읽힙니다. Feature Size, Weight Size, Bias SIze, Output Size를 고려해서 겹치지 않게 주소를 설정하세요.
    parameter   FEATURE_STRIDE_SIZE = INPUT_SIZE;
    parameter   FEATURE_HSIZE       = INPUT_SIZE;    // 65536 (2의 16승) 보다 크면 안됩니다. 크면 VSIZE를 늘려서 HSIZE*VSIZE를 INPUT SIZE와 똑같게 만들면 됩니다.
    parameter   FEATURE_VSIZE       = 32'd1;
    parameter   WEIGHT_BASE_ADDR    = 32'h0000_2000;    // 00000_0000 일 경우 첫 번째 데이터가 안 읽힙니다. Feature Size, Weight Size, Bias SIze, Output Size를 고려해서 겹치지 않게 주소를 설정하세요.
    parameter   WEIGHT_STRIDE_SIZE  = INPUT_SIZE*OUTPUT_SIZE/8;
    parameter   WEIGHT_HSIZE        = INPUT_SIZE*OUTPUT_SIZE/8;    // 65536 (2의 16승) 보다 크면 안됩니다. 크면 VSIZE를 늘려서 HSIZE*VSIZE를 INPUT SIZE와 똑같게 만들면 됩니다.
    parameter   WEIGHT_VSIZE        = 32'd8;
    parameter   BIAS_BASE_ADDR      = 32'h0004_0000;    // 00000_0000 일 경우 첫 번째 데이터가 안 읽힙니다. Feature Size, Weight Size, Bias SIze, Output Size를 고려해서 겹치지 않게 주소를 설정하세요.
    parameter   BIAS_STRIDE_SIZE    = OUTPUT_SIZE;   
    parameter   BIAS_HSIZE          = OUTPUT_SIZE;
    parameter   BIAS_VSIZE          = 32'd1;    
    parameter   RESULT_BASE_ADDR    = 32'h0004_2000;    // Feature Size, Weight Size, Bias SIze, Output Size를 고려해서 겹치지 않게 주소를 설정하세요.
    parameter   RESULT_STRIDE_SIZE  = OUTPUT_SIZE;    
    parameter   RESULT_HSIZE        = OUTPUT_SIZE;    // 65536 (2의 16승) 보다 크면 안됩니다. 크면 VSIZE를 늘려서 HSIZE*VSIZE를 INPUT SIZE와 똑같게 만들면 됩니다.   
    parameter   RESULT_VSIZE        = 32'd1; 
    /////////////////////// 수정할 부분 end //////////////////////////////////////
    
    
    localparam integer  OP_SIZE         = 4;
    localparam integer  ADDR_SIZE       = 28;
    localparam integer  DATA_SIZE       = 32;
    
    /////////////////////// 수정할 부분 begin ////////////////////////////
    localparam integer  FEATURE_SIZE    = FEATURE_HSIZE*FEATURE_VSIZE/4;                 // txt 파일들의 각 line이 32 bit일 때 line 수 입니다. 위에서 구한 HSZIE*VSIZE 의 1/4 와 같습니다.
    localparam integer  WEIGHT_SIZE     = WEIGHT_HSIZE*WEIGHT_VSIZE/4;                
    localparam integer  BIAS_SIZE       = BIAS_HSIZE*BIAS_VSIZE/4;           //+1     
    localparam integer  RESULT_SIZE     = RESULT_HSIZE*RESULT_VSIZE/4;       //+1            
    /////////////////////// 수정할 부분 end //////////////////////////////////////
    
    // FC, CONV의 경우 a,b,c 세 개 모두 필요하지만 POOL은 weight와 bias가 없으므로 b,c는 필요 없습니다.
    // bram write 
    reg [31:0]          data_a_32bit [0:FEATURE_SIZE-1];        // data_a
    reg [31:0]          data_b_32bit [0:WEIGHT_SIZE-1];         // data_b
    reg [31:0]          data_c_32bit [0:BIAS_SIZE-1];           // data_c  
    
    
    /////////////////////// 수정할 부분 begin //////////////////////////// 
    // module_example
    reg         fc_start;
    wire        start_response;
    reg [2:0]   COMMAND;
    wire        F_writedone;
    wire        B_writedone;
    wire        W_writedone;
    reg [20:0]  receive_size;
    wire        cal_done;
    wire        fc_done;
    reg         done_response;
    /////////////////////// 수정할 부분 end //////////////////////////////////////
    
    // system
    reg         clk;
    reg         resetn;
    
    // vdma_control
    reg         init_txn;
    reg [31:0]  addr;
    reg [31:0]  data;
    wire        txn_done;
    
    // axi_m_interface (for read)
    reg         init_read;
    reg [31:0]  r_addr;
    wire [31:0] r_data;
    wire        read_done;  
    
    // For result check
    integer     file;
    reg [31:0]  result_32bit;                           // output result
    reg [31:0]  result_expected_32bit[0:RESULT_SIZE-1]; // expected result
    reg [27:0]  addr_test;
    
    integer    i;
    reg [128 * 8:0] input_file_name;
    
    reg         compare_flag;


    //----------------------
    // ******* Clock *******
    //----------------------
    
    initial clk = 1'b1;
    always #HALF_CLK_PERIODD clk = ~clk;
    
    
    
    //-----------------------
    //****** Main test ******
    //-----------------------
    
    initial begin
        resetn = 1'b0;
        init_txn = 1'b0;
        init_read = 1'b0;
        result_32bit = 0;
        compare_flag = 1'b1;
        
        /////////////////////// 수정할 부분 begin ////////////////////////////
        // 사용할 port들의 초기화
        COMMAND = 3'b000;
        fc_start = 1'b0;
        done_response = 1'b0;
        /////////////////////// 수정할 부분 end //////////////////////////////////////
        
        repeat (100)
          @(posedge clk);      
          
        resetn = 1'b1;   
        
        
        //** writing data to BRAM **//     
        repeat (500)
          @(posedge clk);
        $display("- Force write starts -");
        
        
        ////////////////////////////////////////////////////////////   INPUT FILES   ///////////////////////////////////////////////////////////
        /////////////////////// 수정할 부분 begin ////////////////////////////
        // 원하는 파일들을 add simulation sources로 추가해주시고, 아래의 파일이름을 바꿔주세요
        // input data file
        input_file_name = "fc1_test_input_32bits_2s.txt";//fc_relu_input_32bits_2s.txt
        check_file(input_file_name);
        $readmemb(input_file_name, data_a_32bit);
        // weight file
        input_file_name = "fc1_test_weight_32bits_2s.txt"; //fc_relu_weight_32bits_2s.txt
        check_file(input_file_name);
        $readmemb(input_file_name, data_b_32bit);
        // bias file
        input_file_name = "fc1_test_bias_32bits_2s.txt"; // fc_relu_bias_32bits_2s.txt
        check_file(input_file_name);
        $readmemb(input_file_name, data_c_32bit);
        /////////////////////// 수정할 부분 end //////////////////////////////////////
                 
        // writing fc_relu_input.txt
        for (i = 0; i < FEATURE_SIZE; i = i + 1) begin
            force tb.u_top_simulation.u_sram_32x131072.inst.axi_mem_module.blk_mem_gen_v8_4_5_inst.ADDRA = (FEATURE_BASE_ADDR + i*4)/4; 
            force tb.u_top_simulation.u_sram_32x131072.inst.axi_mem_module.blk_mem_gen_v8_4_5_inst.ENA = 1'b1;
            force tb.u_top_simulation.u_sram_32x131072.inst.axi_mem_module.blk_mem_gen_v8_4_5_inst.WEA = 4'b1111;
            @(posedge tb.u_top_simulation.u_sram_32x131072.inst.axi_mem_module.blk_mem_gen_v8_4_5_inst.CLKA);
            force tb.u_top_simulation.u_sram_32x131072.inst.axi_mem_module.blk_mem_gen_v8_4_5_inst.DINA = {data_a_32bit[i][7:0],data_a_32bit[i][15:8],data_a_32bit[i][23:16],data_a_32bit[i][31:24]};   // UART version - big to little
                                                             
            @(posedge tb.u_top_simulation.u_sram_32x131072.inst.axi_mem_module.blk_mem_gen_v8_4_5_inst.CLKA);
        end 
          
        // writing fc_relu_weight.txt  
        for (i = 0; i < WEIGHT_SIZE; i = i + 1) begin            
            force tb.u_top_simulation.u_sram_32x131072.inst.axi_mem_module.blk_mem_gen_v8_4_5_inst.ADDRA = (WEIGHT_BASE_ADDR + i*4)/4; 
            force tb.u_top_simulation.u_sram_32x131072.inst.axi_mem_module.blk_mem_gen_v8_4_5_inst.ENA = 1'b1;
            force tb.u_top_simulation.u_sram_32x131072.inst.axi_mem_module.blk_mem_gen_v8_4_5_inst.WEA = 4'b1111;
            @(posedge tb.u_top_simulation.u_sram_32x131072.inst.axi_mem_module.blk_mem_gen_v8_4_5_inst.CLKA); 
            force tb.u_top_simulation.u_sram_32x131072.inst.axi_mem_module.blk_mem_gen_v8_4_5_inst.DINA = {data_b_32bit[i][7:0],data_b_32bit[i][15:8],data_b_32bit[i][23:16],data_b_32bit[i][31:24]};   // UART version - big to little                                                  
            @(posedge tb.u_top_simulation.u_sram_32x131072.inst.axi_mem_module.blk_mem_gen_v8_4_5_inst.CLKA);
        end 
          
        // writing fc_relu_bias.txt  
        for (i = 0; i < BIAS_SIZE; i = i + 1) begin
             force tb.u_top_simulation.u_sram_32x131072.inst.axi_mem_module.blk_mem_gen_v8_4_5_inst.ADDRA = (BIAS_BASE_ADDR + i*4)/4;
             force tb.u_top_simulation.u_sram_32x131072.inst.axi_mem_module.blk_mem_gen_v8_4_5_inst.ENA = 1'b1;
             force tb.u_top_simulation.u_sram_32x131072.inst.axi_mem_module.blk_mem_gen_v8_4_5_inst.WEA = 4'b1111;
             @(posedge tb.u_top_simulation.u_sram_32x131072.inst.axi_mem_module.blk_mem_gen_v8_4_5_inst.CLKA);
             force tb.u_top_simulation.u_sram_32x131072.inst.axi_mem_module.blk_mem_gen_v8_4_5_inst.DINA = {data_c_32bit[i][7:0],data_c_32bit[i][15:8],data_c_32bit[i][23:16],data_c_32bit[i][31:24]};  // UART version - big to little
                                                                 
             @(posedge tb.u_top_simulation.u_sram_32x131072.inst.axi_mem_module.blk_mem_gen_v8_4_5_inst.CLKA);
        end
 
        release tb.u_top_simulation.u_sram_32x131072.inst.axi_mem_module.blk_mem_gen_v8_4_5_inst.ADDRA;
        release tb.u_top_simulation.u_sram_32x131072.inst.axi_mem_module.blk_mem_gen_v8_4_5_inst.ENA;
        release tb.u_top_simulation.u_sram_32x131072.inst.axi_mem_module.blk_mem_gen_v8_4_5_inst.WEA;
        release tb.u_top_simulation.u_sram_32x131072.inst.axi_mem_module.blk_mem_gen_v8_4_5_inst.DINA;
        @(posedge tb.u_top_simulation.u_sram_32x131072.inst.axi_mem_module.blk_mem_gen_v8_4_5_inst.CLKA);
        
        $display("- Force write is done -\n\n");
        
        

        ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////  
        ////////////////////////////////////////////////////////   VDMA control starts   ///////////////////////////////////////////////////////  

  
        /////////////////////// 수정할 부분 begin ////////////////////////////
        // 이 부분은 구현하신 대로 적절히 VDMA를 켜고 signal들을 주고 받으면 됩니다.
        
        $display("- VDMA control starts -\n");
        # CLK_PERIOD;
        
        // VDMA가 결과를 받도록 미리 켜두는 것입니다. VDMA가 input data를 보내주는 것과는 별개이므로 미리 켜두고 시작합니다. 즉 이 부분은 수정할 필요가 없습니다.
        // S2MM //
        // write result (from FC to memory)
        write_data(S2MM_VDMACR_REG_ADDR, 32'h00010091);                 // control
        write_data(S2MM_START_ADDRESS_REG_ADDR, RESULT_BASE_ADDR);      // start address
        write_data(S2MM_FRMDLY_STRIDE_REG_ADDR, RESULT_STRIDE_SIZE);    // stride
        write_data(S2MM_HSIZE_REG_ADDR, RESULT_HSIZE);                  // hsize (= line size) (Bytes)
        write_data(S2MM_VSIZE_REG_ADDR, RESULT_VSIZE);                  // the number of lines
        $display("VDMA is ready to receive result from FC\n");
    
    
    
    
        // MM2S //
        // feature read (from memory to FC) 
        $display("VDMA transmits feature to FC");
        write_data(MM2S_VDMACR_REG_ADDR, 32'h00010091);                 // control
        write_data(MM2S_START_ADDRESS_REG_ADDR, FEATURE_BASE_ADDR);     // start address
        write_data(MM2S_FRMDLY_STRIDE_REG_ADDR, FEATURE_STRIDE_SIZE);   // stride
        write_data(MM2S_HSIZE_REG_ADDR, FEATURE_HSIZE);                 // hsize (= line size) (Bytes)
        write_data(MM2S_VSIZE_REG_ADDR, FEATURE_VSIZE);                 // the number of lines 


        repeat(100)
            @(posedge clk);

            
        // sending control signals to FC
        receive_size = FEATURE_HSIZE*FEATURE_VSIZE;
        COMMAND = 3'b001;
        fc_start = 1'b1;
        repeat(2)
            @(posedge clk);
            
        //while(!start_response) begin
            fc_start = 1'b0;
        //end
        $display("FC starts to read feature");
        wait(F_writedone);
        $display("FC finishes to read feature\n");
        
        
        repeat(100)                                                     //** Please do not remove this. **//
            @(posedge clk);                                             //** VDMA needs enough time interval between transmissions of the same direction. (this case: MM2S & MM2S) **//

        
        // MM2S //
        // bias read (from memory to FC) 
        $display("VDMA transmits bias to FC");
        write_data(MM2S_VDMACR_REG_ADDR, 32'h00010091);                 // control     
        write_data(MM2S_START_ADDRESS_REG_ADDR, BIAS_BASE_ADDR);        // start address 
        write_data(MM2S_FRMDLY_STRIDE_REG_ADDR, BIAS_STRIDE_SIZE);      // stride 
        write_data(MM2S_HSIZE_REG_ADDR, BIAS_HSIZE);                    // hsize (= line size) (Bytes) 
        write_data(MM2S_VSIZE_REG_ADDR, BIAS_VSIZE);                    // the number of lines 
        
        
        repeat(100)
            @(posedge clk);
            
        
        // sending control signals to FC
        receive_size = BIAS_HSIZE*BIAS_VSIZE;
        COMMAND = 3'b010;
        
        $display("FC starts to read bias");     
        wait(B_writedone);
        $display("FC finishes to read bias\n");
        
        
        repeat(100)                                                     //** Please do not remove this. **//
            @(posedge clk);                                             //** VDMA needs enough time interval between transmissions of the same direction. (this case: MM2S & MM2S) **//
        
        
        // MM2S //
        // weight read (from memory to FC) 
        $display("VDMA transmits weight to FC");
        write_data(MM2S_VDMACR_REG_ADDR, 32'h00010091);                 // control     
        write_data(MM2S_START_ADDRESS_REG_ADDR, WEIGHT_BASE_ADDR);      // start address
        write_data(MM2S_FRMDLY_STRIDE_REG_ADDR, WEIGHT_STRIDE_SIZE);    // stride
        write_data(MM2S_HSIZE_REG_ADDR, WEIGHT_HSIZE);                  // hsize (= line size) (Bytes)
        write_data(MM2S_VSIZE_REG_ADDR, WEIGHT_VSIZE);                  // the number of lines


        repeat(100)
            @(posedge clk);   
            
            
        // sending control signals to FC
        receive_size = 10'd32;
        COMMAND = 3'b100;

        $display("FC starts to read weight");      
        wait(cal_done);
        $display("FC finishes to read weight\n");
        
                
        repeat(100)
            @(posedge clk);                 
    
    
        // sending control signals to FC
        COMMAND = 3'b101;     
           
        $display("FC starts to write result");            
        wait(fc_done);
        done_response = 1'b1;
        $display("FC finishes to write result\n\n");        
        
        
        repeat(100)
            @(posedge clk);  
        // sending control signals to FC              
        done_response = 1'b0;
        COMMAND = 3'b000;  
             
        write_data(MM2S_VDMACR_REG_ADDR, 32'h00010094);             // vdma reset to flush vdma


        repeat(100)
            @(posedge clk);   
  
        /////////////////////// 수정할 부분 end //////////////////////////////////////
        
        ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////  
        //////////////////////////////////////////////////////  VDMA control is finished  //////////////////////////////////////////////////////
        ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////  
    
    
    
        // comparing results
        $display("- Comparing result starts -\n");
        
        
        ////////////////////////////////////////////////////////////   RESULT FILE   ///////////////////////////////////////////////////////////
        /////////////////////// 수정할 부분 begin ////////////////////////////
        // 아래의 파일명을 원하는 결과파일로 바꿔주세요
        import_result_nowrite("fc3_test_output_32bits_2s.txt");//fc_output_32bits_2s.txt
        ////////////////////// 수정할 부분 end //////////////////////////////////////
        
        addr_test = RESULT_BASE_ADDR;
        
        for (i = 0; i < RESULT_SIZE; i = i + 1) begin
            read_data (addr_test+i*4, result_32bit);
            
            $display("Index: %d", i);
            
            if (result_32bit != {result_expected_32bit[i][7:0], result_expected_32bit[i][15:8], result_expected_32bit[i][23:16],result_expected_32bit[i][31:24]}) begin
                $display("\nResult is different!");
                $display("Expected value: %h", {result_expected_32bit[i][7:0], result_expected_32bit[i][15:8], result_expected_32bit[i][23:16],result_expected_32bit[i][31:24]});
                $display("Output value: %h\n", result_32bit);
                
                compare_flag = 1'b0;
            end
        end
        
        if (compare_flag) begin
            $display("\nResult is correct!\n");
        end
        
        $display("- Comparing result is done!! -\n");
        $finish;
    end
    
    
    
    //-----------------------
    //******** Task ********
    //-----------------------
    
    task write_data (input [31:0] i_addr, input [31:0] i_data);
        begin   
            addr = i_addr;
            data = i_data;
            
            init_txn = 1'b1;
            
            # CLK_PERIOD 
            init_txn = 1'b0;
            
            wait(txn_done);
             # CLK_PERIOD;
        end
    endtask
    
    
    task read_data (input [31:0] i_addr, output reg [31:0] o_data);
        begin
            r_addr = i_addr;
            
            init_read = 1'b1;
         
            # CLK_PERIOD 
            init_read = 1'b0;
            
            wait(read_done);
            # CLK_PERIOD;      
             
            o_data = r_data;      
        end
    endtask

    task import_result_nowrite(input [128 * 8:0] file_name);
        begin
            file = 0;  
            file = $fopen(file_name,"rb");
            
            if (!file) begin
                $display("read: Open Error!\n");
                $finish;
            end
            
            $display("input file : %s\n", file_name);
            
            $readmemb(file_name, result_expected_32bit);
            
            $display("import result(no write) is done. \n");
            
            $fclose(file);
        end
    endtask
    
    task check_file(input [128 * 8:0] file_name);
        begin
            file = 0;  
            file = $fopen(file_name,"rb");
            
            if (!file) begin
                $display("read: Open Error!\n");
                $finish;
            end
            
            $display("input file : %s\n", file_name);
            
            $fclose(file);
        end
    endtask    
    
    //-----------------------
    //**** Instantiation ****
    //-----------------------
     
    top_simulation u_top_simulation
        (.clk(clk),
        .resetn(resetn),
        .init_txn(init_txn),
        .i_addr(addr),
        .i_data(data),
        .txn_done(txn_done),
        .init_read(init_read),
        .r_addr(r_addr),
        .r_data(r_data),
        .read_done(read_done),
        
        
        /////////////////////// 수정할 부분 begin ////////////////////////////
        .COMMAND(COMMAND),
        .F_writedone(F_writedone),
        .B_writedone(B_writedone),
        .W_writedone(W_writedone),
        .receive_size(receive_size),
        .fc_start(fc_start),
        .start_response(start_response),
        .done_response(done_response),
        .fc_done(fc_done),
        .cal_done(cal_done)
        ////////////////////// 수정할 부분 end //////////////////////////////////////
        );
endmodule
