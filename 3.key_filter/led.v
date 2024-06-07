`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/04/13 18:38:45
// Design Name: 
// Module Name: led
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


module led(
input wire clk,
input wire reset_n,
input wire key_in0,
input wire key_in1,
input wire key_in2,
input wire key_in3,

output wire [7:0] led //led 显示led
);

wire key_add,key_sub,key_shift_l,key_shift_r;

key_fliter  #(
     .CNT_MAX(20'd999_999)
)key_fliter_inst
(
.sys_clk                    (clk),
.sys_rst_n                  (reset_n),
.key_in                     (key_in0),

.key_flag                    (key_add)
);

key_fliter  #(
     .CNT_MAX(20'd999_999)
)key_fliter_inst
(
.sys_clk                    (clk),
.sys_rst_n                  (reset_n),
.key_in                     (key_in1),

.key_flag                    (key_sub)
);

key_fliter  #(
     .CNT_MAX(20'd999_999)
)key_fliter_inst
(
.sys_clk                    (clk),
.sys_rst_n                  (reset_n),
.key_in                     (key_in2),

.key_flag                    (key_shift_l)
);

key_fliter  #(
     .CNT_MAX(20'd999_999)
)key_fliter_inst
(
.sys_clk                    (clk),
.sys_rst_n                  (reset_n),
.key_in                     (key_in3),

.key_flag                    (key_shift_r)
);

key_led key_led_inst(
.clk                (clk), //模块工作时钟输入，50M
.reset_n            (reset_n), //复位信号输入，低有效
.key_add            (key_add), //自加按键
.key_sub            (key_sub), //自减按键
.key_shift_l        (key_shift_l), //左移按键
.key_shift_r        (key_shift_r), //右移按键
    
.led                (led)//led 显示

    );

endmodule
