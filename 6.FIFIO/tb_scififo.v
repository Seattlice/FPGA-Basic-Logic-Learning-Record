`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/06/07 14:32:35
// Design Name: 
// Module Name: tb_scififo
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


module tb_scififo();

reg sys_clk;
reg sys_rst_n;
reg [7:0] wr_data;
reg wr_en;
reg rd_en;
reg [1:0] cnt;

wire [7:0] rd_data;
wire full;
wire empty;
wire [7:0] data_count;

    initial begin
        sys_clk = 1'b0;
        sys_rst_n <= 1'b0;
        #20
        sys_rst_n <= 1'b1;
        end

    always #10 sys_clk = ~sys_clk;

    always @(posedge sys_clk or negedge sys_rst_n)
        begin
            if(!sys_rst_n)
               cnt <= 2'd0;
            else if(cnt == 2'd3)
               cnt <= 2'd0;
            else
                cnt <= cnt + 1'd1;
        end

    always @(posedge sys_clk or negedge sys_rst_n)
        begin
            if(!sys_rst_n)
                wr_en <= 1'b0;
            else if((cnt == 2'd0)&&(rd_en == 1'b0))
                wr_en <= 1'b1;
            else
                wr_en <= 1'b0;
        end

    always @(posedge sys_clk or negedge sys_rst_n)           
        begin                                        
            if(!sys_rst_n)                               
                wr_data <= 8'd0;                                       
            else if((wr_data == 8'd255)&&(wr_en == 1'b1))                                
                wr_data <= 8'd0;                                     
            else if(wr_en == 1'b1)
                wr_data <= wr_data + 1'b1;

        end                                          

    always @(posedge sys_clk or negedge sys_rst_n)
        begin
            if(!sys_rst_n)
                rd_en <= 1'b0;
            else if(full == 1'b1)
                rd_en <= 1'b1;
            else if(empty == 1'b1)
                rd_en <= 1'b0;
        end

scififo scififo_inst(
    .sys_clk                            (sys_clk                   ),
    .sys_rst_n                          (sys_rst_n                 ),
    .wr_data                            (wr_data                   ),
    .wr_en                              (wr_en                     ),
    .rd_en                              (rd_en                     ),

    .rd_data                            (rd_data                   ),
    .full                               (full                      ),
    .empty                              (empty                     ),
    .data_count                         (data_count                ) 

    );





endmodule
