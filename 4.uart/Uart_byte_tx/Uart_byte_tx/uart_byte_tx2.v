module uart_byte_tx (
    input  wire                         sys_clk                    ,
    input  wire                         sys_rst_n                  ,
    input  wire        [   7: 0]        data                       ,
    input  wire                         send_en                    ,


    output reg                          tx_done                    ,
    output reg                         uart_tx                    
);
    
parameter MCNT_BIT = 4'd9;
parameter BAUD = 9600  ;
parameter CLK_FRE = 50_000_000;
parameter MCNT_BAUD = CLK_FRE / BAUD - 1;

parameter STAR_BIT = 1'b0;
parameter STOP_BIT = 1'b1;


reg [29:0] baud_div_cnt;
reg en_baud_cnt;     
reg [3:0] bit_cnt;

reg [7:0] r_DATA;

assign w_tx_done = (bit_cnt == 4'd9 )&&(baud_div_cnt == MCNT_BAUD);

always @(posedge sys_clk or negedge sys_rst_n)                                                 
    if(!sys_rst_n)
        tx_done <= 1'd0;
    else
        tx_done <= w_tx_done;    




//波特率计数器  1/9600s
always @(posedge sys_clk or negedge sys_rst_n)                                                 
    if(!sys_rst_n)                               
        baud_div_cnt <= 29'd0;                                                  
    else if(en_baud_cnt == 1'd1)                                
        if(baud_div_cnt == MCNT_BAUD)
            baud_div_cnt <= 29'd0;
        else 
            baud_div_cnt <= baud_div_cnt + 1'd1;                                                 
    else
        baud_div_cnt <= 29'd0;                                    

    always @(posedge sys_clk or negedge sys_rst_n)           
        begin                                        
            if(!sys_rst_n)                               
                en_baud_cnt <= 1'd0;                                         
            else if(send_en)
                en_baud_cnt <= 1'd1;
            else if(w_tx_done)                                
                en_baud_cnt <= 1'd0;                                         
        end       

//位计数器
    always @(posedge sys_clk or negedge sys_rst_n)           
        begin                                        
            if(!sys_rst_n)                               
                bit_cnt <= 4'd0;                                             
            else if(baud_div_cnt == MCNT_BAUD)     
                if(bit_cnt == 4'd9)
                    bit_cnt <= 4'd0;
                else
                    bit_cnt <= bit_cnt + 1'd1;                           
                                   
        end                                          


    always @(posedge sys_clk or negedge sys_rst_n)           
        begin                                           
            if(!sys_rst_n)   
                r_DATA <= 8'd0;
            else if(send_en)
                r_DATA <= data;
            else
                r_DATA <= r_DATA;
        end

//位发送逻辑
    always @(posedge sys_clk or negedge sys_rst_n)           
        begin                                           
            if(!sys_rst_n)                               
                uart_tx <= 1'b1;     
            else if(en_baud_cnt == 1'd0)
                uart_tx <= 1'd1;    
            else begin
                case(bit_cnt)
                    4'd0:uart_tx <= STAR_BIT;
                    4'd1:uart_tx <= r_DATA[0];
                    4'd2:uart_tx <= r_DATA[1];
                    4'd3:uart_tx <= r_DATA[2];
                    4'd4:uart_tx <= r_DATA[3];
                    4'd5:uart_tx <= r_DATA[4];
                    4'd6:uart_tx <= r_DATA[5];
                    4'd7:uart_tx <= r_DATA[6];
                    4'd8:uart_tx <= r_DATA[7];
                    4'd9:uart_tx <= STOP_BIT;
                default:uart_tx <= uart_tx;      
                endcase
            end                                   
        end                                          
                                        
//----------- Begin Cut here for INSTANTIATION Template ---// INST_TAG
uart_tx0 uart_tx0_inst (
  .clk(sys_clk),              // input wire clk
  .probe_in0(send_en),  // input wire [0 : 0] probe_in0
  .probe_in1(data)  // input wire [7 : 0] probe_in1
);
endmodule