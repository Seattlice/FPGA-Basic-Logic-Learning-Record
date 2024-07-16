`timescale 1ns / 1ps
//****************************************VSCODE PLUG-IN**********************************//
//----------------------------------------------------------------------------------------
// IDE :                   VSCODE     
// VSCODE plug-in version: Verilog-Hdl-Format-2.5.20240605
// VSCODE plug-in author : Jiang Percy
//----------------------------------------------------------------------------------------
//****************************************Copyright (c)***********************************//
// Copyright(C)            Please Write Company name
// All rights reserved     
// File name:              
// Last modified Date:     2024/06/14 14:07:19
// Last Version:           V1.0
// Descriptions:           
//----------------------------------------------------------------------------------------
// Created by:             Please Write You Name 
// Created date:           2024/06/14 14:07:19
// mail      :             Please Write mail 
// Version:                V1.0
// TEXT NAME:              fifo_to_axi4.v
// PATH:                   C:\Users\Administrator\Desktop\SORCE\verilog\stu\7.ddr3\fifo_to_axi4.v
// Descriptions:           
//                         
//----------------------------------------------------------------------------------------
//****************************************************************************************//

module fifo_to_axi4(
    input                               clk                        ,
    input                               rst_n                      
);

assign wr_req_cnt_thresh = (m_axi_awlen == 'd0) ? 1'b1 : (AXI_BURST_LEN[7:0]+1'b1);
assign wr_ddr3_req       = (fifo_rst_busy == 1'b0) && (~fifo_empty) && (fifo_rd_cnt >= wr_req_cnt_thresh) ? 1'b1:1'b0;


assign m_axi_awid    = AXI_ID[AXI_ID_WIDTH-1:0]; 
assign m_axi_awsize  = DATA_SIZE; 
assign m_axi_awburst = 2'b01; 
assign m_axi_awlock  = 1'b0; 
assign m_axi_awcache = 4'b0000; 
assign m_axi_awprot  = 3'b000; 
assign m_axi_awqos   = 4'b0000; 
assign m_axi_awregion= 4'b0000; 
assign m_axi_awlen   = AXI_BURST_LEN[7:0]; 
assign m_axi_wstrb   = 16'hffff; 
assign m_axi_bready  = 1'b1; 

    always@(posedge clk or posedge reset) 
        begin 
            if(reset) 
                m_axi_awaddr <= WR_AXI_BYTE_ADDR_BEGIN;
            else if(wr_addr_clr || axi_awaddr_clr) 
                m_axi_awaddr <= WR_AXI_BYTE_ADDR_BEGIN;
            else if(m_axi_awaddr >= WR_AXI_BYTE_ADDR_END) 
                m_axi_awaddr <= WR_AXI_BYTE_ADDR_BEGIN;
            else if((curr_wr_state == S_WR_RESP) && m_axi_bready && m_axi_bvalid && (m_axi_bresp == 2'b00) && (m_axi_bid == AXI_ID[AXI_ID_WIDTH-1:0])) 
                m_axi_awaddr <= m_axi_awaddr + ((m_axi_awlen + 1'b1)* (AXI_DATA_WIDTH/8)); 
            else 
                m_axi_awaddr <= m_axi_awaddr;
        end 

    always@(posedge clk or posedge reset) 
        begin 
            if(reset) 
                m_axi_awvalid <= 1'b0;
            else if((curr_wr_state == S_WR_ADDR) && m_axi_awready && m_axi_awvalid) 
                m_axi_awvalid <= 1'b0;
            else if(curr_wr_state == S_WR_ADDR) 
                m_axi_awvalid <= 1'b1;
            else 
                m_axi_awvalid <= m_axi_awvalid;
        end

    always@(posedge clk or posedge reset) 
        begin 
            if(reset) 
                m_axi_wvalid <= 1'b0;
            else if((curr_wr_state == S_WR_DATA) && m_axi_wready && m_axi_wvalid && m_axi_wlast) 
                m_axi_wvalid <= 1'b0;
            else if(curr_wr_state == S_WR_DATA) 
                m_axi_wvalid <= 1'b1;
            else 
                m_axi_wvalid <= m_axi_wvalid;
        end 

    always@(posedge clk or posedge reset) 
        begin 
            if(reset) 
                wr_data_cnt <= 1'b0;
            else if(curr_wr_state == S_IDLE) 
                wr_data_cnt <= 1'b0;
            else if(curr_wr_state == S_WR_DATA && m_axi_wready && m_axi_wvalid) 
                wr_data_cnt <= wr_data_cnt + 1'b1;
            else 
                wr_data_cnt <= wr_data_cnt;
        end

    always@(posedge clk or posedge reset) 
        begin 
            if(reset) 
                m_axi_wlast <= 1'b0;
            else if(curr_wr_state == S_WR_DATA && m_axi_wready && m_axi_wvalid && m_axi_wlast) 
                m_axi_wlast <= 1'b0;
            else if(curr_wr_state == S_WR_DATA && m_axi_awlen == 8'd0) 
                m_axi_wlast <= 1'b1;
            else if(curr_wr_state == S_WR_DATA && m_axi_wready && m_axi_wvalid && (wr_data_cnt == m_axi_awlen -1'b1)) 
                m_axi_wlast <= 1'b1;
            else 
                m_axi_wlast <= m_axi_wlast;
        end

    always@(posedge clk or posedge reset) begin if(reset) 
                fifo_rdreq <= 1'b0;
            else if((curr_wr_state == S_WR_ADDR) && m_axi_awready && m_axi_awvalid) 
                fifo_rdreq <= 1'b1;
            else if((curr_wr_state == S_WR_DATA) && m_axi_wready && m_axi_wvalid && (~m_axi_wlast)) 
                fifo_rdreq <= 1'b1;
            else 
                fifo_rdreq <= 1'b0;
        end 
 
    always@(posedge clk) 
        begin 
                fifo_rddata_valid <= fifo_rdreq;
        end 
 
    always@(posedge clk or posedge reset) 
        begin 
            if(reset) 
                fifo_rddata_latch <= {AXI_DATA_WIDTH{1'b0}};
            else if(fifo_rddata_valid) 
                fifo_rddata_latch <= fifo_rddata;
        end 
 
assign m_axi_wdata   = fifo_rddata_latch;

    always@(posedge clk or posedge reset)
        begin
            if(reset)
                curr_wr_state <= S_IDLE;
            else 
                curr_wr_state <= next_wr_state;
        end
    always@(*)
        begin
            case(curr_wr_state)
                //具体状态转移见下 
                S_IDLE:
                        begin
                            if(wr_ddr3_req == 1'b1)
                        next_wr_state = S_WR_ADDR;
                            else 
                        next_wr_state = S_IDLE;
                        end
                S_WR_ADDR:
                        begin
                            if(m_axi_awready && m_axi_awvalid)
                        next_wr_state = S_WR_DATA_PRE;
                            else 
                        next_wr_state = S_WR_ADDR;
                        end
                S_WR_DATA_PRE:
                        begin
                    next_wr_state = S_WR_DATA;
                        end
                S_WR_DATA:
                        begin
                            if(m_axi_wready && m_axi_wvalid && m_axi_wlast)
                    next_wr_state = S_WR_RESP;
                            else if(m_axi_wready && m_axi_wvalid)
                    next_wr_state = S_WR_DATA_PRE;
                            else 
                    next_wr_state = S_WR_DATA;
                        end
                S_WR_RESP:
                        begin
                            if(m_axi_bready && m_axi_bvalid && (m_axi_bresp == 2'b00) &&
                (m_axi_bid == AXI_ID[AXI_ID_WIDTH-1:0]))
                    next_wr_state = S_IDLE;
                            else 
                    next_wr_state = S_WR_RESP;
                        end
                        endcase
        end


        endmodule