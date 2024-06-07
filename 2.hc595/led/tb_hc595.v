`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/04/15 15:30:14
// Design Name: 
// Module Name: tb_HC595
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


module tb_HC595();



reg reset_n;
reg [31:0] disp_data;
reg clk;

wire sh_cp;
wire st_cp;
wire ds;

initial begin
    reset_n = 1'b0;
    clk = 1'b0;
    //en = 1;
    #20 reset_n = 1'b1;
    disp_data = 32'h12345678;

    #20000000;
    disp_data = 32'h87654321;
    #20000000;
    disp_data = 32'h89abcdef;
    #20000000;
    $stop;
end

HC595 HC595_inst(
    .clk                                (clk                       ),//50M
    .reset_n                            (reset_n                   ),
    
    .sh_cp                              (sh_cp                     ),
    .st_cp                              (st_cp                     ),
    .ds                                 (ds                        ) 
);


endmodule
