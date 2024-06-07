`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/04/15 10:04:41
// Design Name: 
// Module Name: tb_key_con
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

module tb_key_con();


reg sys_clk;
reg sys_rst_n;
reg key_in0;
reg key_in1;
reg key_in2;
reg key_in3;
reg key_in4;


wire [5:0]   wave_sel;
wire [3:0]   mode_sel;    
wire [8:0]   F;// 1 对应0.1MHZ
wire [10:0]  T;//脉冲时间
wire [6:0]   Z;//占空比，为0-100，意味脉冲信号占总信号的1/Z   

initial begin
    sys_clk = 1'b1;
    sys_rst_n <= 1'b0;
    #20
    sys_rst_n <= 1'b1;
    #10000
    key_in0 <= 1'b1;
    #10
    key_in0 <= 1'b0;
    #10000
    key_in0 <= 1'b1;
    #10
    key_in0 <= 1'b0;
    #10000
    key_in0 <= 1'b1;
    #10
    key_in0 <= 1'b0;
    #10000
    key_in0 <= 1'b1;
    #10
    key_in0 <= 1'b0;
    #10000
    key_in0 <= 1'b1;
    #10
    key_in0 <= 1'b0;
    #10000
    key_in0 <= 1'b1;
    #10
    key_in0 <= 1'b0;
end

always #10 sys_clk = ~sys_clk; 

key_control key_control_inst(
.clk            (sys_clk),
.reset_n        (sys_rst_n),
.key_in0        (key_in0),//wave_sel
.key_in1        (key_in1),//mode_sel
.key_in2        (key_in2),//F
.key_in3        (key_in3),//T
.key_in4        (key_in4),//Z


.wave_sel       (wave_sel),
.mode_sel       (mode_sel),    
.F              (F),// 1 对应0.1MHZ
.T              (T),//脉冲时间
.Z              (Z)//占空比，为0-100，意味脉冲信号占总信号的1/Z   
);

endmodule
