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
// Last modified Date:     2024/04/15 14:31:15
// Last Version:           V1.0
// Descriptions:           
//----------------------------------------------------------------------------------------
// Created by:             Please Write You Name 
// Created date:           2024/04/15 14:31:15
// Version:                V1.0
// TEXT NAME:              divder.v
// PATH:                   C:\Users\Administrator\Desktop\SORCE\verilog\stu\hc595\led\divder.v
// Descriptions:           
//                         
//----------------------------------------------------------------------------------------
//****************************************************************************************//
//分频器模，将输入的信号进行分频，系统时钟为50MHZ，分频之后为1KHZ
//接着进行数码管的位选，进行信号的扫描，然后出书位选信号
module divder(
    input                  wire             clk                        ,
    input                  wire             rst_n                       ,
    input                  wire             en                          ,

    output                 wire             sel      

);

reg [14:0] divider_cnt;                                                                   
always@(posedge clk or posedge rst_n)
    if(!rst_n)
        divider_cnt <= 15'd0;
    else if(!en)
        divider_cnt <= 15'd0;
    else if(divider_cnt == 24999)
        divider_cnt <= 15'd0;
    else
        divider_cnt <= divider_cnt + 1'b1;

//1K 扫描时钟生成模块
reg clk_1K;
always@(posedge clk or posedge rst_n)
    if(!rst_n)
        clk_1K <= 1'b0;
    else if(divider_cnt == 24_999)
        clk_1K <= ~clk_1K;
    else
        clk_1K <= clk_1K;

reg        [7:0]     sel_r;
always@(posedge clk_1K or posedge rst_n)
    if(!rst_n)
        sel_r <= 8'b0000_0001;
    else if(sel_r == 8'b1000_0000)
        sel_r <= 8'b0000_0001;
    else
        sel_r <= sel_r << 1;


assign sel = (en)?sel_r:8'b0000_0000;


        
endmodule



