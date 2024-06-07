`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/06/07 14:28:07
// Design Name: 
// Module Name: scififo
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


module scififo(
    input  wire                         sys_clk                    ,
    input  wire                         sys_rst_n                  ,
    input  wire        [   7: 0]        wr_data                    ,
    input  wire                         wr_en                      ,
    input  wire                         rd_en                      ,

    output wire        [   7: 0]        rd_data                    ,
    output wire                         full                       ,
    output wire                         empty                      ,
    output wire        [   7: 0]        data_count                  

    );


    //----------- Begin Cut here for INSTANTIATION Template ---// INST_TAG
scififo_8x256 scififo_8x256_1 (
    .clk                                (sys_clk                   ),// input wire clk
    .srst                               (!sys_rst_n                 ),// input wire srst
    .din                                (wr_data                   ),// input wire [7 : 0] din
    .wr_en                              (wr_en                     ),// input wire wr_en
    .rd_en                              (rd_en                     ),// input wire rd_en
    .dout                               (rd_data                      ),// output wire [7 : 0] dout
    .full                               (full                      ),// output wire full
    .empty                              (empty                     ),// output wire empty
    .data_count                         (data_count                ) // output wire [7 : 0] data_count
);
endmodule
