`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: XDU
// Engineer: HUALOU LI
// 
// Create Date: 2024/05/16 11:31:59
// Design Name: 
// Module Name: pwm_top
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

//该项目为蜂鸣器音调从dou到si变化，每0.5ms变化一次，周期性重复
module pwm_top (
    input  wire                         sys_clk                    ,
    input  wire                         sys_rst_n                  ,


    output wire                         pwm_out                        

);
    
reg [31:0] counter_arr;     //预重装值寄存器
wire [31:0] counter_ccr;    //输出比较值

reg [24:0] cnt_500ms;       //500ms计数器
reg [2:0]  pitch_num;       //音调

parameter CNT500MS_MAX  = 25'd25_000_000;
//音调计数频率值
localparam  D1 = 1700668;   
localparam  D2 = 151515;
localparam  D3 = 142857;
localparam  D4 = 127227;
localparam  D5 = 113379;
localparam  D6 = 101010;
localparam  D7 = 89928;

//输出占空比为其一半
//占空比决定音频大小，频率决定音频音调
assign counter_ccr = counter_arr >> 1;


    //调用PWM发生模块
    beep beep_inst(
        .sys_clk                            (sys_clk                   ),
        .sys_rst_n                          (sys_rst_n                 ),
        .pwm_gen_en                         (1'b1                      ),
        .counter_arr                        (counter_arr               ),
        .counter_ccr                        (counter_ccr               ),

        .pwm_out                            (pwm_out                   ) 
    );

    //500ms计数器
    always @(posedge sys_clk or negedge sys_rst_n) begin
        if(!sys_rst_n)
            cnt_500ms <= 25'd0;
        else if(cnt_500ms == CNT500MS_MAX - 1'd1)
            cnt_500ms <= 25'd0;
        else
            cnt_500ms <= cnt_500ms + 1'd1;
        end

    //500ms改变一次音调
    always @(posedge sys_clk or negedge sys_rst_n) begin
        if(!sys_rst_n)
            pitch_num <= 3'd0;
        else if(cnt_500ms == CNT500MS_MAX - 1'd1)
            pitch_num <= pitch_num + 1'd1;
        else
            pitch_num <= pitch_num;
        end

    always @(posedge sys_clk or negedge sys_rst_n) begin
        if(!sys_rst_n)                              
            counter_arr <= 32'd1;                                         
        else begin
            case(pitch_num)
                3'd0:counter_arr <= 32'd1;
                3'd1:counter_arr <= D1;
                3'd2:counter_arr <= D2;
                3'd3:counter_arr <= D3;
                3'd4:counter_arr <= D4;
                3'd5:counter_arr <= D5;
                3'd6:counter_arr <= D6;
                3'd7:counter_arr <= D7;
                default:counter_arr <= 32'd1;
            endcase
        end   
        end                                          

endmodule
