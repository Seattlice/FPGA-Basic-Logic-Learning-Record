`timescale 1ns / 1ps
//****************************************VSCODE PLUG-IN**********************************//
//----------------------------------------------------------------------------------------
// IDE :                   VSCODE     
// VSCODE plug-in version: Verilog-Hdl-Format-1.9.20240413
// VSCODE plug-in author : Jiang Percy
//----------------------------------------------------------------------------------------
//****************************************Copyright (c)***********************************//
// Copyright(C)            Please Write Company name
// All rights reserved     
// File name:              
// Last modified Date:     2024/04/20 16:05:17
// Last Version:           V1.0
// Descriptions:           
//----------------------------------------------------------------------------------------
// Created by:             Please Write You Name 
// Created date:           2024/04/20 16:05:17
// Version:                V1.0
// TEXT NAME:              tb_uart_tx.v
// PATH:                   C:\Users\Administrator\Desktop\SORCE\verilog\stu\Uart_byte_tx\tb_uart_tx.v
// Descriptions:           
//                         
//----------------------------------------------------------------------------------------
//****************************************************************************************//

module tb_uart_tx();
                                                                   
                                                                   

    initial sys_clk = 1;

    always#(`CLK_PERIOD/2)sys_clk = ~sys_clk;

initial begin
    sys_rst = 1'b0;
    data_byte = 8'd0;
    send_en = 1'd0;
    baud_set = 3'd4;

    #(`CLK_PERIOD*500 + 1 )
    reset_sys_rstn = 1'b1;

    #(`CLK_PERIOD*50);
    //send first byte
    data_byte = 8'haa;
    send_en = 1'd1;

    #`CLK_PERIOD;
    send_en = 1'd0;
    @(posedge tx_done)
    #(`CLK_PERIOD*5000);
    //send second byte
    data_byte = 8'h55;
    send_en = 1'd1;

    #`CLK_PERIOD;
    send_en = 1'd0;
    @(posedge tx_done)
    #(`CLK_PERIOD*5000);
    $stop; 
end
wire uart_tx;
wire uart_state;
wire tx_done;

Uart_byte_tx Uart_byte_tx (
.sys_clk                    (sys_clk),
.sys_rst                    (sys_rst),
.send_en                    (send_en),//发送使能时钟，代表可以发送
.databyte                   (data_byte),//8比特发送信息
.baud_set                   (baud_set),//波特率选择信息

.uart_tx                    (uart_tx),//发送的信息
.tx_done                    (tx_done),//发送是否完成
.uart_state                 (uart_state)//发送的状态
);


endmodule