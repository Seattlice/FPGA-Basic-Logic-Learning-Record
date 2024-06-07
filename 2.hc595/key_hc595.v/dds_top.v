`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/04/17 13:48:57
// Design Name: 
// Module Name: dds_top
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
// Last modified Date:     2024/04/17 13:49:38
// Last Version:           V1.0
// Descriptions:           
//----------------------------------------------------------------------------------------
// Created by:             Please Write You Name 
// Created date:           2024/04/17 13:49:38
// Version:                V1.0
// TEXT NAME:              dds_top.v
// PATH:                   C:\Users\Administrator\Desktop\SORCE\verilog\stu\hc595\key_hc595.v\dds_top.v
// Descriptions:           
//                         
//----------------------------------------------------------------------------------------
//****************************************************************************************//

module dds_top(
    input wire      sys_clk     ,
    input wire      sys_rst_n   ,
    input wire key_in0,//wave_sel
    input wire key_in1,//mode_sel
    input wire key_in2,//F
    input wire key_in3,//T
    input wire key_in4,//Z


    output wire         RCLK,
    output wire         SRCLK,
    output wire         DIO,
    output wire [21:0]    dac_data

    );                                                         

     wire  [5:0]   wave_sel;//波形选择
     wire  [3:0]   mode_sel;//模式选择
     wire  [8:0]   F;// 1 对应0.1MHZ
     wire  [10:0]  T;//脉冲时间
     wire  [6:0]   Z;//占空比，为0-100，意味脉冲信号占总信号的1/Z   



key_control key_control_inst(
    .clk                                (sys_clk                       ),//模块工作时钟输入，50M
    .reset_n                            (sys_rst_n                   ),//复位信号输入，低有效
    .key_in0                            (key_in0                   ),
    .key_in1                            (key_in1                   ),
    .key_in2                            (key_in2                   ),
    .key_in3                            (key_in3                   ),
    .key_in4                            (key_in4                   ),


    .wave_sel                           (wave_sel                  ),
    .mode_sel                           (mode_sel                  ),
    .F                                  (F                         ),// 1 对应0.1MHZ
    .T                                  (T                         ),//脉冲时间
    .Z                                  (Z                         ),//占空比，为0-100，意味脉冲信号占总信号的1/Z   
    .RCLK                               (RCLK                      ),
    .SRCLK                              (SRCLK                     ),
    .DIO                                (DIO                       ) 
);

dds dds_inst
(
    .sys_clk                            (sys_clk                   ),
    .sys_rst_n                          (sys_rst_n                 ),
    .wave_sel                           (wave_sel                  ),
    .mode_sel                           (mode_sel                  ),
    .F                                  (F                         ),// 1 对应0.1MHZ
    .T                                  (T                         ),//脉冲时间
    .Z                                  (Z                         ),//占空比，为0-100，意味脉冲信号占总信号的1/Z   

    .dac_data                           (dac_data                  ) 
    );




endmodule
