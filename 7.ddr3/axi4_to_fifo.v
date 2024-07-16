`timescale 1ns / 1ps
//****************************************VSCODE PLUG-IN**********************************//
//----------------------------------------------------------------------------------------
// IDE :                   VSCODE     
// VSCODE plug-in version: Verilog-Hdl-Format-2.5.20240605
// VSCODE plug-in author : Jiang Percy
//----------------------------------------------------------------------------------------
//****************************************Copyright (c)***********************************//
// Copyright(C)            XDU
// All rights reserved     
// File name:              
// Last modified Date:     2024/06/14 14:17:11
// Last Version:           V1.0
// Descriptions:           
//----------------------------------------------------------------------------------------
// Created by:             Li Hualou
// Created date:           2024/06/14 14:17:11
// mail      :             Please Write mail 
// Version:                V1.0
// TEXT NAME:              axi4_to_fifo.v
// PATH:                   C:\Users\Administrator\Desktop\SORCE\verilog\stu\7.ddr3\axi4_to_fifo.v
// Descriptions:           
//                         
//----------------------------------------------------------------------------------------
//****************************************************************************************//

module axi4_to_fifo  (
    //clock reset 
    input wire clk                                (clk                       ),
    input wire reset                              (reset                     ),
    //FIFO Interface ports 
    input addr_clr                           (wr_addr_clr               ),//1:clear, sync clk
    input fifo_rdreq                         (wrfifo_rden               ),
    .fifo_rddata                        (wrfifo_dout               ),
    .fifo_empty                         (wrfifo_empty              ),
    .fifo_rd_cnt                        (wrfifo_rd_cnt             ),
    .fifo_rst_busy                      (wrfifo_rd_rst_busy        ),
    // Slave Interface Write Address Ports 
    .m_axi_awid                         (m_axi_awid                ),
    .m_axi_awaddr                       (m_axi_awaddr              ),
    .m_axi_awlen                        (m_axi_awlen               ),
    .m_axi_awsize                       (m_axi_awsize              ),
    .m_axi_awburst                      (m_axi_awburst             ),
    .m_axi_awlock                       (m_axi_awlock              ),
    .m_axi_awcache                      (m_axi_awcache             ),
    .m_axi_awprot                       (m_axi_awprot              ),
    .m_axi_awqos                        (m_axi_awqos               ),
    .m_axi_awregion                     (m_axi_awregion            ),
    .m_axi_awvalid                      (m_axi_awvalid             ),
    .m_axi_awready                      (m_axi_awready             ),
    // Slave Interface Write Data Ports 
    .m_axi_wdata                        (m_axi_wdata               ),
    .m_axi_wstrb                        (m_axi_wstrb               ),
    .m_axi_wlast                        (m_axi_wlast               ),
    .m_axi_wvalid                       (m_axi_wvalid              ),
    .m_axi_wready                       (m_axi_wready              ),
    // Slave Interface Write Response Ports 
    .m_axi_bid                          (m_axi_bid                 ),
    .m_axi_bresp                        (m_axi_bresp               ),
    .m_axi_bvalid                       (m_axi_bvalid              ),
    .m_axi_bready                       (m_axi_bready              ) 
  );

assign rd_req_cnt_thresh = 2**FIFO_ADDR_WIDTH - (AXI_BURST_LEN[7:0]+1'b1); 
assign rd_ddr3_req   = (fifo_rst_busy == 1'b0) && (fifo_wr_cnt < rd_req_cnt_thresh-2'd2) ? 1'b1:1'b0; 

assign m_axi_arid    = AXI_ID[AXI_ID_WIDTH-1:0]; 
assign m_axi_arsize  = DATA_SIZE; 
assign m_axi_arburst = 2'b01; 
assign m_axi_arlock  = 1'b0; 
assign m_axi_arcache = 4'b0000; 
assign m_axi_arprot  = 3'b000; 
assign m_axi_arqos   = 4'b0000; 
assign m_axi_arregion= 4'b0000; 
assign m_axi_arlen   = AXI_BURST_LEN[7:0]; 
assign m_axi_rready  = ~fifo_alfull; 
  
    always@(posedge clk or posedge reset) 
        begin 
            if(reset) 
                curr_rd_state <= S_IDLE;
            else 
                curr_rd_state <= next_rd_state;
        end 

    always@(*) begin 
        case(curr_rd_state) 
        //具体状态转移见下 
        S_IDLE: 
                begin 
                    if(rd_ddr3_req == 1'b1) 
                        next_rd_state = S_RD_ADDR; 
                    else 
                        next_rd_state = S_IDLE; 
                end 
        S_RD_ADDR:
                begin 
                    if(m_axi_arready && m_axi_arvalid) 
                        next_rd_state = S_RD_RESP; 
                    else 
                        next_rd_state = S_RD_ADDR; 
                end 
        S_RD_RESP: 
                begin 
                    if(m_axi_rready && m_axi_rvalid && m_axi_rlast && (m_axi_rresp == 2'b00) && (m_axi_rid == AXI_ID[AXI_ID_WIDTH-1:0])) 
                        next_rd_state = S_IDLE; 
                    else 
                        next_rd_state = S_RD_RESP; 
                end 
                endcase 
        end 



    always@(posedge clk or posedge reset) 
        begin 
            if(reset) 
                m_axi_araddr <= RD_AXI_BYTE_ADDR_BEGIN;
            else if(rd_addr_clr || axi_araddr_clr) 
                m_axi_araddr <= RD_AXI_BYTE_ADDR_BEGIN;
            else if(m_axi_araddr >= RD_AXI_BYTE_ADDR_END) 
                m_axi_araddr <= RD_AXI_BYTE_ADDR_BEGIN;
            else if((curr_rd_state == S_RD_RESP) && m_axi_rready && m_axi_rvalid && m_axi_rlast && (m_axi_rresp == 2'b00) && (m_axi_rid == AXI_ID[AXI_ID_WIDTH-1:0])) 
                m_axi_araddr <= m_axi_araddr + ((m_axi_arlen + 1'b1)*(AXI_DATA_WIDTH/8)); 
            else 
                m_axi_araddr <= m_axi_araddr;
        end

//m_axi_arvalid 
    always@(posedge clk or posedge reset) 
        begin 
            if(reset) 
                m_axi_arvalid <= 1'b0;
            else if((curr_rd_state == S_RD_ADDR) && m_axi_arready && m_axi_arvalid) 
                m_axi_arvalid <= 1'b0;
            else if(curr_rd_state == S_RD_ADDR) 
                m_axi_arvalid <= 1'b1;
            else 
                m_axi_arvalid <= m_axi_arvalid;
        end 

    always@(posedge clk or posedge reset) 
        begin 
            if(reset) 
        begin 
                fifo_wrreq <= 1'b0;
                fifo_wrdata <= {AXI_DATA_WIDTH{1'b0}};
        end 
            else if(addr_clr || axi_araddr_clr) 
        begin 
                fifo_wrreq <= 1'b0;
                fifo_wrdata <= {AXI_DATA_WIDTH{1'b0}};
        end 
            else if(m_axi_rvalid && m_axi_rready) 
        begin 
                fifo_wrreq <= 1'b1;
                fifo_wrdata <= m_axi_rdata;
        end 
            else 
        begin 
                fifo_wrreq <= 1'b0;
                fifo_wrdata <= {AXI_DATA_WIDTH{1'b0}};
        end 
        end


endmodule