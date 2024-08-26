`timescale 1ns / 1ps
//****************************************VSCODE PLUG-IN**********************************//
//----------------------------------------------------------------------------------------
// IDE :                   VSCODE     
// VSCODE plug-in version: Verilog-Hdl-Format-2.8.20240817
// VSCODE plug-in author : Jiang Percy
//----------------------------------------------------------------------------------------
//****************************************Copyright (c)***********************************//
// Copyright(C)            XDU
// All rights reserved     
// File name:              
// Last modified Date:     2024/08/22 17:33:33
// Last Version:           V1.0
// Descriptions:           
//----------------------------------------------------------------------------------------
// Created by:             Li Hualou
// Created date:           2024/08/22 17:33:33
// mail      :             Please Write mail 
// Version:                V1.0
// TEXT NAME:              color_cho.v
// PATH:                   C:\Users\Administrator\Desktop\SORCE\verilog\stu\9.VGA\color_cho.v
// Descriptions:           
//                         
//----------------------------------------------------------------------------------------
//****************************************************************************************//

module color_cho(
    input  wire                         clk                        ,
    input  wire                         rst_n                      ,
    input  wire                         disp_data_req              ,
    input  wire                         visible_hcount             ,
    input  wire                         visible_vcount             ,

    output reg         [  10: 0]        disp_data                   
);

    //定义颜色编码
    localparam
    BLACK = 24'h000000,//黑色
    BLUE = 24'h0000FF,//蓝色
    RED = 24'hFF0000,//红色
    PURPPLE =24'hFF00FF,//紫色
    GREEN = 24'h00FF00, //绿色
    CYAN = 24'h00FFFF, //青色
    YELLOW = 24'hFFFF00,//黄色
    WHITE = 24'hFFFFFF;//白色

    //定义每个像素块的默认显示颜色值
    localparam
    R0_C0 = BLACK, //第 0 行 0 列像素块
    R0_C1 = BLUE, //第 0 行 1 列像素块
    R1_C0 = RED, //第 1 行 0 列像素块
    R1_C1 = PURPPLE,//第 1 行 1 列像素块
    R2_C0 = GREEN, //第 2 行 0 列像素块
    R2_C1 = CYAN, //第 2 行 1 列像素块
    R3_C0 = YELLOW, //第 3 行 0 列像素块
    R3_C1 = WHITE; //第 3 行 1 列像素块

    parameter DISP_WIDTH = 640,
    parameter DISP_HEIGHT = 480

    assign C0_act = visible_hcount >= 0 && visible_hcount < DISP_WIDTH/2; //正在扫描第 0 列条纹
    assign C1_act = visible_hcount >= DISP_WIDTH/2 && visible_hcount < DISP_WIDTH; //正在扫描第 1 列条纹

    assign R0_act = visible_vcount >= 0 && visible_vcount < DISP_HEIGHT/4; //正在扫描第 0 行条纹
    assign R1_act = visible_vcount >= DISP_HEIGHT/4 && visible_vcount < DISP_HEIGHT/2; //正在扫描第 1 行条纹
    assign R2_act = visible_vcount >= DISP_HEIGHT/2 && visible_vcount < DISP_HEIGHT/4*3; //正在扫描第 2 行条纹
    assign R3_act = visible_vcount >= DISP_HEIGHT/4*3 && visible_vcount < DISP_HEIGHT; //正在扫描第 3 行条纹


    wire R0_C0_act = R0_act & C0_act; //第 0 行 0 列像素块被扫描中
    wire R0_C1_act = R0_act & C1_act; //第 0 行 1 列像素块被扫描中
    wire R1_C0_act = R1_act & C0_act; //第 1 行 0 列像素块被扫描中
    wire R1_C1_act = R1_act & C1_act; //第 1 行 1 列像素块被扫描中
    wire R2_C0_act = R2_act & C0_act; //第 2 行 0 列像素块被扫描中
    wire R2_C1_act = R2_act & C1_act; //第 2 行 1 列像素块被扫描中
    wire R3_C0_act = R3_act & C0_act; //第 3 行 0 列像素块被扫描中
    wire R3_C1_act = R3_act & C1_act; //第 3 行 1 列像素块被扫描中

    always@(*)
        case({R3_C1_act,R3_C0_act,R2_C1_act,R2_C0_act,R1_C1_act,R1_C0_act,R0_C1_act,R0_C0_act})
            8'b0000_0001:disp_data = R0_C0;
            8'b0000_0010:disp_data = R0_C1;
            8'b0000_0100:disp_data = R1_C0;
            8'b0000_1000:disp_data = R1_C1;
            8'b0001_0000:disp_data = R2_C0;
            8'b0010_0000:disp_data = R2_C1;
            8'b0100_0000:disp_data = R3_C0;
            8'b1000_0000:disp_data = R3_C1;
        default:disp_data = R0_C0;
    endcase


endmodule