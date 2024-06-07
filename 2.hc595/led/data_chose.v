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
// Last modified Date:     2024/04/15 14:38:07
// Last Version:           V1.0
// Descriptions:           
//----------------------------------------------------------------------------------------
// Created by:             Please Write You Name 
// Created date:           2024/04/15 14:38:07
// Version:                V1.0
// TEXT NAME:              led_chose.v
// PATH:                   C:\Users\Administrator\Desktop\SORCE\verilog\stu\hc595\led\led_chose.v
// Descriptions:           
//                         
//----------------------------------------------------------------------------------------
//****************************************************************************************//

module data_chose(
    input  wire                         clk                        ,
    input  wire                         rst_n                      ,
    input  wire        [  31: 0]        disp_data                  ,
    input  wire                         en                         ,

    output wire         [   7: 0]        sel                        , //想要的位选信号
    output reg         [   6: 0]        seg                         //想要的数码管的值                        
);

//此处处理位选信号

reg [14:0] divider_cnt;                                                                   
always@(posedge clk or negedge rst_n)
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
always@(posedge clk or negedge rst_n)
    if(!rst_n)
        clk_1K <= 1'b0;
    else if(divider_cnt == 24999)
        clk_1K <= ~clk_1K;
    else
        clk_1K <= clk_1K;

reg        [7:0]     sel_r;
always@(posedge clk_1K or negedge rst_n)
    if(!rst_n)
        sel_r <= 8'b0000_0001;
    else if(sel_r == 8'b1000_0000)
        sel_r <= 8'b0000_0001;
    else
        sel_r <= sel_r << 1;


assign sel = (en)?sel_r:8'b0000_0000;

//此处处理数码管的值
reg         [7:0]   data_tmp ;
always@(*)
    case(sel_r)
        8'b0000_0001:data_tmp = disp_data[3:0];
        8'b0000_0010:data_tmp = disp_data[7:4];
        8'b0000_0100:data_tmp = disp_data[11:8];
        8'b0000_1000:data_tmp = disp_data[15:12];
        8'b0001_0000:data_tmp = disp_data[19:16];
        8'b0010_0000:data_tmp = disp_data[23:20];
        8'b0100_0000:data_tmp = disp_data[27:24];
        8'b1000_0000:data_tmp = disp_data[31:28];
    default:data_tmp = 4'b0000;
    endcase

always@(*)
    case(data_tmp)
        4'h0:seg = 7'b1000000;
        4'h1:seg = 7'b1111001;
        4'h2:seg = 7'b0100100;
        4'h3:seg = 7'b0110000;
        4'h4:seg = 7'b0011001;
        4'h5:seg = 7'b0010010;
        4'h6:seg = 7'b0000010;
        4'h7:seg = 7'b1111000;
        4'h8:seg = 7'b0000000;
        4'h9:seg = 7'b0010000;
        4'ha:seg = 7'b0001000;
        4'hb:seg = 7'b0000011;
        4'hc:seg = 7'b1000110;
        4'hd:seg = 7'b0100001;
        4'he:seg = 7'b0000110;
        4'hf:seg = 7'b0001110;
    endcase



                                                                   
endmodule