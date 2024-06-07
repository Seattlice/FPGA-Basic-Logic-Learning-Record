`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: XDU
// Engineer: HUALOU LI
// 
// Create Date: 2024/05/16 11:36:17
// Design Name: 
// Module Name: tb_pwm_top
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


module tb_pwm_top();

reg sys_clk;
reg sys_rst_n;
wire pwm_out;

initial begin
    sys_clk = 1'd0;
    sys_rst_n = 1'd0;
    #10
    sys_rst_n = 1'd1;
    #10000
    $stop;
end

always #10 sys_clk = ~sys_clk;


pwm_top pwm_top_inst(
    .sys_clk                            (sys_clk                   ),
    .sys_rst_n                          (sys_rst_n                 ),


    .pwm_out                            (pwm_out                   ) 

);

endmodule
