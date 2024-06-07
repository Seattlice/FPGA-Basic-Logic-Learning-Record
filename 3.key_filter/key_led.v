`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/04/13 18:33:31
// Design Name: 
// Module Name: key_led
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


module key_led(
    input wire clk, //模块工作时钟输入，50M
    input wire reset_n, //复位信号输入，低有效
    input wire key_add, //自加按键
    input wire key_sub, //自减按键
    input wire key_shift_l, //左移按键
    input wire key_shift_r, //右移按键
    
    output reg [7:0] led //led 显示

    );
    
always@(posedge clk or negedge reset_n)
    if(!reset_n)
        led <= 8'b0000_0000;
    else if(key_add)
        led <= led + 1'b1;
    else if(key_sub)
        led <= led - 1'b1;
    else if(key_shift_l)
        led <= (led << 1);
    else if(key_shift_r)
        led <= (led >> 1);
    else
        led <= led;  
          

    
endmodule
