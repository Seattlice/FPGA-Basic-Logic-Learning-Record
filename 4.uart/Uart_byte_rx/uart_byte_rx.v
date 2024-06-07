`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/05/13 15:08:30
// Design Name: 
// Module Name: uart_byte_rx
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module uart_byte_rx (
    input wire sys_clk,
    input wire sys_rst_n,
    input wire uart_tx,

    output reg [7:0] rx_data,
    output reg rx_done
);




parameter MCNT_BIT = 4'd9;
parameter BAUD = 9600  ;
parameter CLK_FRE = 50_000_000;
parameter MCNT_BAUD = CLK_FRE / BAUD - 1;


reg [29:0] baud_div_cnt;        //时钟计数信号记录整个时钟的信号
reg en_baud_cnt;                //波特率使能信号
reg [3:0] bit_cnt;              //每个比特位计数信号

wire w_rx_done;                 //接收完成信号 

reg r_uart_rx;                  //D触发器中存储的uart值，为了寻找下降沿而设置
wire nege_uart_rx;

//为了防止亚稳态打两拍进行技术
reg dff0_uart_rz;
reg dff1_uart_rz;

//波特率计数器逻辑
    always @(posedge sys_clk or negedge sys_rst_n)           
        begin                                        
            if(!sys_rst_n)                               
                baud_div_cnt <= 30'd0;                                          
            else if(en_baud_out)                                
                if(baud_div_cnt == MCNT_BAUD)
                    baud_div_cnt <= 30'd0
                else
                    baud_div_cnt <= baud_div_cnt + 1'd1;                                   
            else 
                baud_div_cnt <= 30'd0;
        end                                          

    always@(posedge sys_clk)
        begin
            dff0_uart_rz <= uart_rx;
            dff1_uart_rz <= dff0_uart_rz; 
        end

//UART信号检测边缘逻辑
    always@(posedge sys_clk)
        r_uart_rx <= dff1_uart_rz;

    assign nege_uart_rx = (!dff1_uart_rz)&&(r_uart_rx);


//波特率使能逻辑
    always @(posedge sys_clk or negedge sys_rst_n)           
        begin                                        
            if(!sys_rst_n)                               
                en_baud_cnt <= 1'd0;                                         
            else if(nege_uart_rx)
                en_baud_cnt <= 1'd1;
            else if(baud_div_cnt == MCNT_BAUD / 2)&&(bit_cnt == 1'b0)&&(dff1_uart_rz == 1'b1)                        
                en_baud_cnt <= 1'd0; 
            else if(baud_div_cnt == MCNT_BAUD / 2)&&(bit_cnt == 4'd9)
                en_baud_cnt <= 1'd0;
        end   



//位接收逻辑

//位计数器
    always @(posedge sys_clk or negedge sys_rst_n)           
        begin                                        
            if(!sys_rst_n)                               
                bit_cnt <= 4'd0;            
            else if((baud_div_cnt == MCNT_BAUD / 2)&&(bit_cnt == 4'd9))
                bit_cnt <= 4'd0;
            else if(baud_div_cnt == MCNT_BAUD)     
                bit_cnt <= bit_cnt + 1'd1;                           
                                   
        end                                          

//接收完成标志逻辑
    assign w_rx_done = (baud_div_cnt == MCNT_BAUD/2)&&(bit_cnt == 9);
    always@(posedge sys_clk)
        rx_done <= w_rx_done;

//位发送逻辑
    always @(posedge sys_clk or negedge sys_rst_n)           
        begin                                           
            if(!sys_rst_n)                               
                rx_data <= 8'b0;     
            else if(baud_div_cnt == MCNT_BAUD / 2)begin
                case(bit_cnt)
                    4'd1:rx_data[0] <= dff1_uart_rz;
                    4'd2:rx_data[1] <= dff1_uart_rz;
                    4'd3:rx_data[2] <= dff1_uart_rz;
                    4'd4:rx_data[3] <= dff1_uart_rz;
                    4'd5:rx_data[4] <= dff1_uart_rz;
                    4'd6:rx_data[5] <= dff1_uart_rz;
                    4'd7:rx_data[6] <= dff1_uart_rz;
                    4'd8:rx_data[7] <= dff1_uart_rz;
                default:rx_data <= rx_data;      
                endcase
            end                                   
        end       




endmodule