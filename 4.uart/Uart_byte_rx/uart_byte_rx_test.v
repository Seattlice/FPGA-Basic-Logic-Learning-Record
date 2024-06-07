`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/05/13 15:35:17
// Design Name: 
// Module Name: uart_byte_rx_test
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


module uart_byte_rx_test (
    input wire sys_clk,
    input wire sys_rst_n,
    input wire uart_tx,

    output wire [7:0] rx_data,
    output wire led
);

    wire rx_done;

    always@(posedge sys_clk or negedge sys_rst_n)
        if(!sys_rst_n)
            led <= 1'd0;
        else if(rx_done)
            led <= ~led;

    defparam uart_byte_rx.BAUD = 115200;

    uart_byte_rx uart_byte_rx_inst(
        .sys_clk                            (sys_clk                   ),
        .sys_rst_n                          (sys_rst_n                 ),
        .uart_tx                            (uart_tx                   ),

        .rx_data                            (rx_data                   ),
        .rx_done                            (rx_done                   ) 
    );

endmodule