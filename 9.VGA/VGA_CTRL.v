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

module VGA_CTRL(
    Clk25M, //系统输入时钟 25MHZ
    Rst_n, //复位输入，低电平复位
    data_in, //待显示数据
    hcount, //VGA 行扫描计数器
    vcount, //VGA 场扫描计数器
    VGA_RGB, //VGA 数据输出
    VGA_HS, //VGA 行同步信号
    VGA_VS, //VGA 场同步信号
    VGA_BLK, //VGA 场消隐信号
    VGA_CLK //VGA DAC 输出时钟                    
);
    //----------------模块输入端口----------------
    input Clk25M; //系统输入时钟 25MHZ
    input Rst_n;
    input [23:0]data_in; //待显示数据

    //----------------模块输出端口----------------
    output [9:0]hcount;
    output [9:0]vcount;
    output [23:0]VGA_RGB; //VGA 数据输出
    output VGA_HS; //VGA 行同步信号
    output VGA_VS; //VGA 场同步信号
    output VGA_BLK; //VGA 场消隐信号
    output VGA_CLK; //VGA DAC 输出时钟



    wire rst_n;
    wire rst_clk;

    wire dat_act;//判断是否在有效区的信号

    assign rst_clk = Clk25M;
    assign rst_n   = Rst_n;

    //将 VGA 控制器时钟信号取反输出，作为 DAC 数据锁存信号
    assign VGA_CLK = ~Clk25M;

    //VGA 行、场扫描时序参数表
    parameter VGA_HS_end=10'd95,
                hdat_begin=10'd143,
                hdat_end=10'd783,
                hpixel_end=10'd799,
                VGA_VS_end=10'd1,
                vdat_begin=10'd34,
                vdat_end=10'd514,
                vline_end=10'd524;
    

    //行列扫描信号
    reg [9:0] H_counter;//最大0-799
    reg [9:0] V_counter;//0-524

    //行列脉冲信号
    assign VGA_HS = ( H_counter > VGA_HS_end );
    assign VGA_VS = ( V_counter > VGA_VS_end );
    
    //标定电子枪正处于的位置信号
    assign hcount = dat_act ? ( H_counter - hdat_begin ) : 10'd0;
    assign vcount = dat_act ? ( V_counter - vdat_begin ) : 10'd0;


    //数据、同步信号输出
    assign dat_act = (( H_counter >= hdat_begin ) && ( H_counter < hdat_end )) && (( V_counter >= vdat_begin ) && ( V_counter < vdat_end ));

    assign VGA_BLK = dat_act;
    assign VGA_RGB = ( dat_act ) ? data_in : 24'h000000;

    //**********************VGA 驱动部分**********************
    //行扫描计数器
        always @(posedge rst_clk or negedge rst_n)           
            begin                                        
                if(!rst_n)                               
                    H_counter <= 10'd0;                                    
                else if(H_counter == 10'd799)                                
                    H_counter <= 10'd0;                                      
                else  
                    H_counter <= H_counter + 1'd1;                                   
            end                                          

    //场扫描
            always @(posedge rst_clk or negedge rst_n)           
            begin                                        
                if(!rst_n)                               
                    V_counter <= 10'd0;                                    
                else if(H_counter == 10'd799) begin   
                    if(V_counter == 10'd524)                             
                        V_counter <= 10'd0;                                      
                    else 
                        V_counter <= V_counter + 1'd1;
                end   
                else
                    V_counter <= V_counter;                                 
            end                                         

                                                                   
endmodule