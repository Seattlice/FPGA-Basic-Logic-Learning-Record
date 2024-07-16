`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/07/16 12:47:46
// Design Name: 
// Module Name: rgmii2gmii
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

   
   
   module rgmil2gmil(

    input                               sys_rst                    ,

    input                               rgmii_tx_clk               ,
    input                               rgmii_tx_ctl               ,
    input              [   3: 0]        rgmii_tx_data              ,

    output                              gmii_tx_clk                ,
    output                              gmii_tx_dv                 ,
    output                              gmii_tx_er                 ,
    output             [   7: 0]        gmii_tx_data                
    );
    

    assign gmii_tx_clk = rgmii_tx_clk;
    
    genvar i;
    generate
        for(i = 0;i < 4;i = i + 1)
        begin:rgmii_txd_o
                    IDDR #(
            .DDR_CLK_EDGE                       ("SAME_EDGE_PIPELINED"     ),// "OPPOSITE_EDGE", "SAME_EDGE" 
                                                        //    or "SAME_EDGE_PIPELINED" 
            .INIT_Q1                            (1'b0                      ),// Initial value of Q1: 1'b0 or 1'b1
            .INIT_Q2                            (1'b0                      ),// Initial value of Q2: 1'b0 or 1'b1
            .SRTYPE                             ("SYNC"                    ) // Set/Reset type: "SYNC" or "ASYNC" 
                    ) IDDR_inst (
            .Q1                                 (gmii_tx_data[i]           ),// 1-bit output for positive edge of clock
            .Q2                                 (gmii_tx_data[i + 4]       ),// 1-bit output for negative edge of clock
            .C                                  (rgmii_tx_clk              ),// 1-bit clock input
            .CE                                 (1'b1                      ),// 1-bit clock enable input
            .D                                  (rgmii_tx_data[i]          ),// 1-bit DDR data input
            .R                                  (sys_rst                  ),// 1-bit reset
            .S                                  (1'd0                      ) // 1-bit set
                    );
        end
    endgenerate


                    IDDR #(
            .DDR_CLK_EDGE                       ("SAME_EDGE_PIPELINED"     ),// "OPPOSITE_EDGE", "SAME_EDGE" 
                                                        //    or "SAME_EDGE_PIPELINED" 
            .INIT_Q1                            (1'b0                      ),// Initial value of Q1: 1'b0 or 1'b1
            .INIT_Q2                            (1'b0                      ),// Initial value of Q2: 1'b0 or 1'b1
            .SRTYPE                             ("SYNC"                    ) // Set/Reset type: "SYNC" or "ASYNC" 
                    ) IDDR_inst (
            .Q1                                 (gmii_tx_dv                ),// 1-bit output for positive edge of clock
            .Q2                                 (gmii_tx_er   ),// 1-bit output for negative edge of clock
            .C                                  (rgmii_tx_clk              ),// 1-bit clock input
            .CE                                 (1'd1                      ),// 1-bit clock enable input
            .D                                  (gmii_tx_dv                ),// 1-bit DDR data input
            .R                                  (sys_rst                  ),// 1-bit reset
            .S                                  (1'd0                      ) // 1-bit set
                    );

endmodule

   
