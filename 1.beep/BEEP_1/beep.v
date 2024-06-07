`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: XDU
// Engineer: HUALOU LI
// 
// Create Date: 2024/05/16 11:30:47
// Design Name: 
// Module Name: beep
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


module beep (
    input  wire                         sys_clk                    ,
    input  wire                         sys_rst_n                  ,
    input  wire                         pwm_gen_en                 ,
    input  wire        [  31: 0]        counter_arr                ,
    input  wire        [  31: 0]        counter_ccr                ,

    output reg                          pwm_out                     
);
    reg [31:0] beep_cnt;//32位的计数器，类似于累加器，用于计数

    always @(posedge sys_clk or negedge sys_rst_n) begin
        if(!sys_rst_n)
            beep_cnt <= 32'd0;
        else if(pwm_gen_en)begin
           if(beep_cnt == 32'd1)                //利用自减的特性，来得到值，当减到1时就使计数器等于音调对应的频率计数器
                beep_cnt <= counter_arr;    
            else
                beep_cnt <= beep_cnt - 1'd1;    //我认为自加也是可以的
        end
        else
            beep_cnt <= counter_arr;            //计数器未使能时，不进行计数
        end

    always @(posedge sys_clk or negedge sys_rst_n) begin //PWM波发生器，用于发生PWM波形
        if(!sys_rst_n)
            pwm_out <= 1'd0;
        else if(beep_cnt <= counter_ccr)
            pwm_out <= 1'd1;
        else
            pwm_out <= 1'd0;
    end


endmodule