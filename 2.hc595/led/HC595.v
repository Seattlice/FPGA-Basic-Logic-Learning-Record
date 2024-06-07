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
// Last modified Date:     2024/04/15 14:45:51
// Last Version:           V1.0
// Descriptions:           
//----------------------------------------------------------------------------------------
// Created by:             Please Write You Name 
// Created date:           2024/04/15 14:45:51
// Version:                V1.0
// TEXT NAME:              HC595.v
// PATH:                   C:\Users\Administrator\Desktop\SORCE\verilog\stu\hc595\led\HC595.v
// Descriptions:           
//                         
//----------------------------------------------------------------------------------------
//****************************************************************************************//

module HC595(
    input  wire                         clk                        ,//50M
    input  wire                         reset_n                    ,
    input  wire        [   5: 0]        wave_sel                   ,
    input  wire        [   3: 0]        mode_sel                   ,
    input  wire        [   8: 0]        F                          ,// 1 对应0.1MHZ
    input  wire        [  10: 0]        T                          ,//脉冲时间
    input  wire        [   6: 0]        Z                          ,//占空比，为0-100，意味脉冲信号占总信号的1/Z   

    output wire                         sh_cp                      ,
    output wire                         st_cp                      ,
    output wire                         ds                          
);

//wire [31:0]disp_data;
wire [7:0] sel;//数码管位选（选择当前要显示的数码管）
wire [6:0] seg;//数码管段选（当前要显示的内容) 

//vio_0 vio_0 (
//    .clk                                (clk                       ),
//    .probe_out0                         (disp_data                 ) 
//);

data_chose data_chose_inst(
    .clk                                (clk                       ),
    .rst_n                              (reset_n                   ),
    .en                                 (1'b1                      ),
    .disp_data                          (disp_data                 ),

    .sel                                (sel                       ),
    .seg                                (seg                       ) 
    );

HC595_dr HC595_dr_inst(
    .clk                                (clk                       ),
    .rst_n                              (reset_n                   ),
    .data                               ({1'd1,seg,sel}            ),//位拼接最高位为 1，决定显示的数字不带小数点
    .s_en                               (1'b1                      ),
    
    .sh_cp                              (sh_cp                     ),
    .st_cp                              (st_cp                     ),
    .ds                                 (ds                        ) 
);



endmodule
                                                                   