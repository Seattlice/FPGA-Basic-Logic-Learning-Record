`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/06/07 15:13:12
// Design Name: 
// Module Name: tb_dcififo
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


module tb_dcififo();

reg sys_rst_n;
reg wr_clk;
reg rd_clk;
reg [7:0] wr_data;
reg wr_en;
reg rd_en;

reg [1:0] cnt;

reg full_reg0;
reg full_reg1;

wire [7:0] rd_data;
wire full;
wire empty;
wire [6:0] rd_data_count;
wire [7:0] wr_data_count;

initial begin
    wr_clk = 1'b1;
    rd_clk = 1'b1;
    sys_rst_n <= 1'b0;
    #20
    sys_rst_n <= 1'b1;
end

always #10 wr_clk = ~wr_clk;
always #20 rd_clk = ~rd_clk;

    always @(posedge wr_clk or negedge sys_rst_n)
        begin
            if(!sys_rst_n)
               cnt <= 2'd0;
            else if(cnt == 2'd3)
               cnt <= 2'd0;
            else
                cnt <= cnt + 1'd1;
        end

    always @(posedge wr_clk or negedge sys_rst_n)
        begin
            if(!sys_rst_n)
                wr_en <= 1'b0;
            else if((cnt == 2'd0)&&(rd_en == 1'b0))
                wr_en <= 1'b1;
            else
                wr_en <= 1'b0;
        end

    always @(posedge wr_clk or negedge sys_rst_n)           
        begin                                        
            if(!sys_rst_n)                               
                wr_data <= 8'd0;                                       
            else if((wr_data == 8'd255)&&(wr_en == 1'b1))                                
                wr_data <= 8'd0;                                     
            else if(wr_en == 1'b1)
                wr_data <= wr_data + 1'b1;
        end      

    always @(posedge rd_clk or negedge sys_rst_n)
            if(!sys_rst_n) begin
                    full_reg0 <= 1'b0;
                    full_reg1 <= 1'b0;
            end
            else begin
                    full_reg0 <= full;
                    full_reg1 <= full_reg0;
            end

    always @(posedge rd_clk or negedge sys_rst_n)
        begin
            if(!sys_rst_n)
                rd_en <= 1'b0;
            else if(full_reg1 == 1'b1)
                rd_en <= 1'b1;
            else if(empty == 1'b1)
                rd_en <= 1'b0;
        end


dcififo dcififo_inst
(
    .wr_clk                             (wr_clk                    ),
    .rd_clk                             (rd_clk                    ),
    .wr_data                            (wr_data                   ),
    .wr_en                              (wr_en                     ),
    .rd_en                              (rd_en                     ),

    .rd_data                            (rd_data                   ),
    .full                               (full                      ),
    .empty                              (empty                     ),
    .rd_data_count                      (rd_data_count             ),
    .wr_data_count                      (wr_data_count             ) 
    );




endmodule
