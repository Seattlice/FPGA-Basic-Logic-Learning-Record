`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: XDU
// Engineer: HUALOU LI
// 
// Create Date: 2024/05/16 12:28:34
// Design Name: 
// Module Name: get_pitch
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

module get_pitch (
    input  wire                         sys_clk                    ,
    input  wire                         sys_rst_n                  ,

    output reg         [   8: 0]        pitch_num                   
);

parameter T125ms_MAX_CNT = 24'd625_000;

reg [23:0] cnt_125ms;

    //计数器，用来计数125ms
    always @(posedge sys_clk or negedge sys_rst_n) begin
        if(!sys_rst_n)
            cnt_125ms <= 24'd0;
        else if(cnt_125ms == T125ms_MAX_CNT - 1'd1)
            cnt_125ms <= 24'd0;
        else
            cnt_125ms <= cnt_125ms + 1'd1;
    end

    //125ms为一拍，每一拍换一次音符
        always @(posedge sys_clk or negedge sys_rst_n) begin
        if(!sys_rst_n)
            pitch_num <= 9'd0;
        else if(cnt_125ms == T125ms_MAX_CNT - 1'd1)
            pitch_num <= pitch_num + 1'd1;
        else
            pitch_num <= pitch_num;
    end

endmodule
