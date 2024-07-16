`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/07/16 12:56:27
// Design Name: 
// Module Name: tb_rgmii2gmii
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




`define CLK_PERIOD 8
module rgmii_to_gmii_tb();
    reg                                 reset                      ;
    wire                                gmii_rx_clk                ;
    reg                [   3: 0]        rx_byte_cnt                ;
    wire               [   7: 0]        gmii_rxd                   ;
    wire                                gmii_rxdv                  ;
    wire                                gmii_rxer                  ;
    wire                                rgmii_rx_clk               ;
    reg                [   3: 0]        rgmii_rxd                  ;
    reg                                 rgmii_rxdv                 ;
    reg                                 rx_clk                     ;
    wire                                locked                     ;

    rgmil2gmil rgmil2gmil(
    .sys_rst                            (reset                     ),
    .gmii_tx_clk                        (gmii_rx_clk               ),
    .gmii_tx_dv                         (gmii_rxdv                 ),
    .gmii_tx_data                       (gmii_rxd                  ),
    .gmii_tx_er                         (gmii_rxer                 ),
    .rgmii_tx_clk                       (rgmii_rx_clk              ),
    .rgmii_tx_data                      (rgmii_rxd                 ),
    .rgmii_tx_ctl                       (rgmii_rxdv                ) 
    );

    clk_wiz_0 rx_pll
    (
    // Clock out ports
    .rgmii_rx_clk                           (rgmii_rx_clk              ),// output clk_out1
    // Status and control signals
    .reset                              (reset                     ),// input reset
    .locked                             (locked                    ),// output locked
    // Clock in ports
    .clk_in1                            (rx_clk                    ) // input clk_in1
    );

    //clock generate
    initial rx_clk = 1'b1;

    always #(`CLK_PERIOD/2)rx_clk = ~rx_clk;

    always@(rx_clk or posedge reset)
        if(reset)
            rx_byte_cnt <= 4'd0;
        else if(rgmii_rxdv && locked)
            rx_byte_cnt <= rx_byte_cnt + 1'b1;
        else
            rx_byte_cnt <= 4'd0;

    always@(*)
    begin
        case(rx_byte_cnt)
            16'd0 : rgmii_rxd = 12;
            16'd1 : rgmii_rxd = 7;
            16'd2 : rgmii_rxd = 9;
            16'd3 : rgmii_rxd = 6;
            16'd4 : rgmii_rxd = 11;
            16'd5 : rgmii_rxd = 15;
            16'd6 : rgmii_rxd = 0;
            16'd7 : rgmii_rxd = 8;
            16'd8 : rgmii_rxd = 4;
            16'd9 : rgmii_rxd = 2;
            16'd10 : rgmii_rxd = 5;
            16'd11 : rgmii_rxd = 1;
            16'd12 : rgmii_rxd = 3;
            16'd13 : rgmii_rxd = 10;
            16'd14 : rgmii_rxd = 14;
            16'd15 : rgmii_rxd = 13;
        endcase
    end

    initial
        begin
            reset = 1;
            rgmii_rxdv = 0;
            #201;
            reset = 0;
            rgmii_rxdv = 1;
            #2000; 
            $stop;
        end
endmodule

