`timescale 1ns / 1ps
//****************************************VSCODE PLUG-IN**********************************//
//----------------------------------------------------------------------------------------
// IDE :                   VSCODE     
// VSCODE plug-in version: Verilog-Hdl-Format-2.7.20240716
// VSCODE plug-in author : Jiang Percy
//----------------------------------------------------------------------------------------
//****************************************Copyright (c)***********************************//
// Copyright(C)            XDU
// All rights reserved     
// File name:              
// Last modified Date:     2024/08/22 16:04:12
// Last Version:           V1.0
// Descriptions:           
//----------------------------------------------------------------------------------------
// Created by:             Li Hualou
// Created date:           2024/08/22 16:04:12
// mail      :             Please Write mail 
// Version:                V1.0
// TEXT NAME:              VGA_CTRL.v
// PATH:                   C:\Users\Administrator\Desktop\SORCE\verilog\stu\9.VGA\VGA_CTRL.v
// Descriptions:           
//                         
//----------------------------------------------------------------------------------------
//****************************************************************************************//


    /*
    使用时根据实际工作需求选择几个预定义参数就可以
    MODE_RGB888 和 MODE_RGB565 两个参数二选一，用来决定驱动工作在 16 位模式还是
    24 位模式
    针对小梅哥提供的一系列显示设备，各个设备参数如下所述
    4.3 寸屏：16 位色 RGB565 模式
    5 寸屏：16 位色 RGB565 模式
    GM7123 模块使用 24 位色 RGB888 模式，
    Resolution_xxxx 预定义用来决定显示设备分辨率，常见设备分辨率如下所述
    4.3 寸 TFT 显示屏：Resolution_480x272
    5 寸 TFT 显示屏：Resolution_800x480
    VGA 常见分辨率：
    Resolution_640x480
    Resolution_800x600
    Resolution_1024x768
    Resolution_1280x720
    Resolution_1920x1080
    */
    
    //以下两行预定义根据实际使用的模式，选择一个使能，另外一个使用注释的方式屏蔽
    `define MODE_RGB888
    //`define MODE_RGB565

    //以下 7 行预定义根据实际使用的分辨率，选择一个使能，另外 6 个使用注释的方式屏蔽
    //`define Resolution_480x272 1 //时钟为 9MHz
    `define Resolution_640x480 1 //时钟为 25.175MHz
    //`define Resolution_800x480 1 //时钟为 33MHz
    //`define Resolution_800x600 1 //时钟为 40MHz
    //`define Resolution_1024x768 1 //时钟为 65MHz
    //`define Resolution_1280x720 1 //时钟为 74.25MHz
    //`define Resolution_1920x1080 1 //时钟为 148.5MH



    //定义不同分辨率的时序参数
    `ifdef Resolution_480x272

        `define H_Total_Time 12'd525
        `define H_Right_Border 12'd0
        `define H_Front_Porch 12'd2
        `define H_Sync_Time 12'd41
        `define H_Back_Porch 12'd2
        `define H_Left_Border 12'd0

        `define V_Total_Time 12'd286
        `define V_Bottom_Border 12'd0
        `define V_Front_Porch 12'd2
        `define V_Sync_Time 12'd10
        `define V_Back_Porch 12'd2
        `define V_Top_Border 12'd0

    `elsif Resolution_640x480

        `define H_Total_Time 12'd800
        `define H_Right_Border 12'd8
        `define H_Front_Porch 12'd8
        `define H_Sync_Time 12'd96
        `define H_Back_Porch 12'd40
        `define H_Left_Border 12'd8

        `define V_Total_Time 12'd525
        `define V_Bottom_Border 12'd8
        `define V_Front_Porch 12'd2
        `define V_Sync_Time 12'd2
        `define V_Back_Porch 12'd25
        `define V_Top_Border 12'd8

    `elsif Resolution_800x480

        `define H_Total_Time 12'd1056
        `define H_Right_Border 12'd0
        `define H_Front_Porch 12'd40
        `define H_Sync_Time 12'd128
        `define H_Back_Porch 12'd88
        `define H_Left_Border 12'd0

        `define V_Total_Time 12'd525
        `define V_Bottom_Border 12'd8
        `define V_Front_Porch 12'd2
        `define V_Sync_Time 12'd2
        `define V_Back_Porch 12'd25
        `define V_Top_Border 12'd8

    `elsif Resolution_800x600

        `define H_Total_Time 12'd1056
        `define H_Right_Border 12'd0
        `define H_Front_Porch 12'd40
        `define H_Sync_Time 12'd128
        `define H_Back_Porch 12'd88
        `define H_Left_Border 12'd0

        `define V_Total_Time 12'd628
        `define V_Bottom_Border 12'd0
        `define V_Front_Porch 12'd1
        `define V_Sync_Time 12'd4
        `define V_Back_Porch 12'd23
        `define V_Top_Border 12'd0

    `elsif Resolution_1024x768

        `define H_Total_Time 12'd1344
        `define H_Right_Border 12'd0
        `define H_Front_Porch 12'd24
        `define H_Sync_Time 12'd136
        `define H_Back_Porch 12'd160
        `define H_Left_Border 12'd0

        `define V_Total_Time 12'd806
        `define V_Bottom_Border 12'd0
        `define V_Front_Porch 12'd3
        `define V_Sync_Time 12'd6
        `define V_Back_Porch 12'd29
        `define V_Top_Border 12'd0

    `elsif Resolution_1280x720

        `define H_Total_Time 12'd1650
        `define H_Right_Border 12'd0
        `define H_Front_Porch 12'd110
        `define H_Sync_Time 12'd40
        `define H_Back_Porch 12'd220
        `define H_Left_Border 12'd0

        `define V_Total_Time 12'd750
        `define V_Bottom_Border 12'd0
        `define V_Front_Porch 12'd5
        `define V_Sync_Time 12'd5
        `define V_Back_Porch 12'd20
        `define V_Top_Border 12'd0

    `elsif Resolution_1920x1080

        `define H_Total_Time 12'd2200
        `define H_Right_Border 12'd0
        `define H_Front_Porch 12'd88
        `define H_Sync_Time 12'd44
        `define H_Back_Porch 12'd148
        `define H_Left_Border 12'd0

        `define V_Total_Time 12'd1125
        `define V_Bottom_Border 12'd0
        `define V_Front_Porch 12'd4
        `define V_Sync_Time 12'd5
        `define V_Back_Porch 12'd36
        `define V_Top_Border 12'd0
        
    `endif

