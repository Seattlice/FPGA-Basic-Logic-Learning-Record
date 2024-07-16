`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/07/16 10:46:03
// Design Name: 
// Module Name: gmiltorgmil
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


module gmiltorgmil(

    input                               sys_rst                    ,

    input                               gmii_tx_clk                ,
    input                               gmii_tx_en                 ,
    input                               gmii_tx_er                 ,
    input              [   7: 0]        gmii_tx_data               ,

    output                              rgmii_tx_clk               ,
    output                              rgmii_tx_ctl               ,
    output             [   3: 0]        rgmii_tx_data               
    );
    
    genvar i;
    generate
        for(i = 0;i < 4;i = i + 1)
        begin:rgmii_txd_o
                ODDR #(
                .DDR_CLK_EDGE("SAME_EDGE"), // "OPPOSITE_EDGE" or "SAME_EDGE" 
                .INIT(1'b0),    // Initial value of Q: 1'b0 or 1'b1
                .SRTYPE("SYNC") // Set/Reset type: "SYNC" or "ASYNC" 
            ) ODDR_inst0 (
                .Q(rgmii_tx_data[i]),   // 1-bit DDR output
                .C(gmii_tx_clk),   // 1-bit clock input
                .CE(1'b1), // 1-bit clock enable input
                .D1(gmii_tx_data[i]), // 1-bit data input (positive edge)
                .D2(gmii_tx_data[i + 4]), // 1-bit data input (negative edge)
                .R(~sys_rst),   // 1-bit reset
                .S(1'b0)    // 1-bit set
            );
        end
    endgenerate


                ODDR #(
                .DDR_CLK_EDGE("SAME_EDGE"), // "OPPOSITE_EDGE" or "SAME_EDGE" 
                .INIT(1'b0),    // Initial value of Q: 1'b0 or 1'b1
                .SRTYPE("SYNC") // Set/Reset type: "SYNC" or "ASYNC" 
            ) ODDR_inst1 (
                .Q(rgmii_tx_ctl),   // 1-bit DDR output
                .C(gmii_tx_clk),   // 1-bit clock input
                .CE(1'b1), // 1-bit clock enable input
                .D1(gmii_tx_en), // 1-bit data input (positive edge)
                .D2(gmii_tx_en ^ gmii_tx_er), // 1-bit data input (negative edge) 异或是因为平常情况下en是1，er是0，结果应该还是1，而不能直接发送0 
                .R(~sys_rst),   // 1-bit reset
                .S(1'b0)    // 1-bit set
            );

                ODDR #(
                .DDR_CLK_EDGE("SAME_EDGE"), // "OPPOSITE_EDGE" or "SAME_EDGE" 
                .INIT(1'b0),    // Initial value of Q: 1'b0 or 1'b1
                .SRTYPE("SYNC") // Set/Reset type: "SYNC" or "ASYNC" 
            ) ODDR_inst2 (
                .Q(rgmii_tx_clk),   // 1-bit DDR output
                .C(gmii_tx_clk),   // 1-bit clock input
                .CE(1'b1), // 1-bit clock enable input
                .D1(1'd1), // 1-bit data input (positive edge)
                .D2(1'd0), // 1-bit data input (negative edge) 异或是因为平常情况下en是1，er是0，结果应该还是1，而不能直接发送0 
                .R(~sys_rst),   // 1-bit reset
                .S(1'b0)    // 1-bit set
            );
endmodule
