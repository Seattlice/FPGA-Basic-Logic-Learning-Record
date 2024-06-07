`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/06/07 15:08:24
// Design Name: 
// Module Name: dcififo
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


module dcififo
(
    input  wire                         wr_clk                     ,
    input  wire                         rd_clk                     ,
    input  wire        [   7: 0]        wr_data                    ,
    input  wire                         wr_en                      ,
    input  wire                         rd_en                      ,

    output wire        [  15: 0]        rd_data                    ,
    output wire                         full                       ,
    output wire                         empty                      ,
    output wire        [   6: 0]        rd_data_count              ,
    output wire        [   7: 0]        wr_data_count               
    );


    //----------- Begin Cut here for INSTANTIATION Template ---// INST_TAG
dcififo_8x256to16x128 dcififo_8x256to16x128_inst (
    .wr_clk                             (wr_clk                    ),// input wire wr_clk
    .rd_clk                             (rd_clk                    ),// input wire rd_clk
    .din                                (wr_data                   ),// input wire [7 : 0] din
    .wr_en                              (wr_en                     ),// input wire wr_en
    .rd_en                              (rd_en                     ),// input wire rd_en
    .dout                               (rd_data                   ),// output wire [15 : 0] dout
    .full                               (full                      ),// output wire full
    .empty                              (empty                     ),// output wire empty
    .rd_data_count                      (rd_data_count             ),// output wire [6 : 0] rd_data_count
    .wr_data_count                      (wr_data_count             ) // output wire [7 : 0] wr_data_count
);
endmodule

