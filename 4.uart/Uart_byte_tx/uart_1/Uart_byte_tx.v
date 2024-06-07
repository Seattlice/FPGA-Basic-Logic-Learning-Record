`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/04/20 15:46:29
// Design Name: 
// Module Name: Uart_byte_tx
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
module Uart_byte_tx (
    input wire sys_clk,
    input wire sys_rst,
    input wire send_en,     //发送使能时钟，代表可以发送
    input wire [7:0] databyte,//8比特发送信息
    input wire [2:0] baud_set,//波特率选择信息

    output reg uart_tx,//发送的信息
    output reg tx_done,//发送是否完成
    output reg uart_state//发送的状态
);

    parameter STOP_BIT = 1'b0;
    parameter START_BIT = 1'b1;
    //波特率的选择，该结果为 系统时钟/波特率 -1，其中系统时钟为50MHZ
    //波特率分别为9600，19200，38400，57600，115200，即为对应的0-4
    reg [15:0] bps_DR;
    always@(posedge sys_clk or posedge sys_rst)
        if(!sys_rst)
            bps_DR <= 16'd5207;
        else begin
            case(baud_set)
                0:bps_DR <= 16'd5207;
                1:bps_DR <= 16'd2603;
                2:bps_DR <= 16'd1301;
                3:bps_DR <= 16'd867;
                4:bps_DR <= 16'd433;
            default:bps_DR <= 16'd5207; 
        endcase
    end
    
    reg [15:0] div_cnt;
    //counter
    always@(posedge sys_clk or posedge sys_rst)
        if(!sys_rst)
            div_cnt <= 16'd0;
        else if(uart_state)begin//当uart处于发送状态时开始计数
            if(div_cnt == bps_DR)//当计数器等于波特率的计数周期时归零，否则增加1
                div_cnt <= 16'd0;
            else
                div_cnt <= div_cnt + 1'b1;
            end
        else
            div_cnt <= 16'd0;

    reg bps_clk;//等于1时开始计数
    // bps_clk gen
    always@(posedge sys_clk or posedge sys_rst)
        if(!sys_rst)
            bps_clk <= 1'b0;
        else if(div_cnt == 16'd1)
            bps_clk <= 1'b1;
        else
            bps_clk <= 1'b0;

    reg [3:0] bps_cnt;//用来进行发送的计数，每当发送以为数据时就增加一，发送完十比特数据之后归零
    //bps counter
    always@(posedge sys_clk or posedge sys_rst)
        if(!sys_rst) 
            bps_cnt <= 4'd0;
        else if(bps_cnt == 4'd11)
            bps_cnt <= 4'd0;
        else if(bps_clk)
            bps_cnt <= bps_cnt + 1'b1;
        else
            bps_cnt <= bps_cnt;

    //写了一个寄存器用来确保一次发送完成之后开始计数

    always@(posedge sys_clk or posedge sys_rst)
        if(!sys_rst)
            tx_done <= 1'b0;
        else if(bps_cnt == 4'd11)
            tx_done <= 1'b1;
        else
            tx_done <= 1'b0;

    //接收到传输信号后拉高状态信号。当传输完毕之后再拉低状态信号
    always@(posedge sys_clk or posedge sys_rst)
        if(!sys_rst)
            uart_state <= 1'b0;
        else if(send_en)
            uart_state <= 1'b1;
        else if(bps_cnt == 4'd11)
            uart_state <= 1'b0;
        else
            uart_state <= uart_state;

    //写了一个寄存器对输入信息进行存储
    reg [7:0] data_byte_reg;
    always@(posedge sys_clk or posedge sys_rst)
        if(!sys_rst)
            data_byte_reg <= 8'd0;
        else if(send_en)
            data_byte_reg <= data_byte;
        else
            data_byte_reg <= data_byte_reg;

    always@(posedge sys_clk or posedge sys_rst)
        if(!sys_rst)
            uart_tx <= 1'b1;
        else begin
            case(bps_cnt)
                0:uart_tx <= 1'b1;
                1:uart_tx <= START_BIT;
                2:uart_tx <= data_byte_reg[0];
                3:uart_tx <= data_byte_reg[1];
                4:uart_tx <= data_byte_reg[2];
                5:uart_tx <= data_byte_reg[3];
                6:uart_tx <= data_byte_reg[4];
                7:uart_tx <= data_byte_reg[5];
                8:uart_tx <= data_byte_reg[6];
                9:uart_tx <= data_byte_reg[7];
                10:uart_tx <= STOP_BIT;
                default:uart_tx <= 1'b1;
            endcase
        end




endmodule