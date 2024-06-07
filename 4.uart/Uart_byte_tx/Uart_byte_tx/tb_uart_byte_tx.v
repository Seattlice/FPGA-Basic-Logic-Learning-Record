`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/05/13 12:28:37
// Design Name: 
// Module Name: tb_uart_byte_tx
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


module tb_uart_byte_tx ();
    reg sys_clk;
    reg sys_rst_n;
    reg [7:0] data;

    wire uart_tx;
    wire led;

defparam uart_byte_tx.MCNT_DLY= 50_000_0 - 1 ;

uart_byte_tx uart_byte_tx_inst(
    .sys_clk                            (sys_clk                   ),
    .sys_rst_n                          (sys_rst_n                 ),
    .data                               (data                      ),

    .uart_tx                            (uart_tx                   ),
    .led                                (led                       ) 
);

initial begin
    sys_clk = 1'b1;
    sys_rst_n = 1'b0;
    #10
    sys_rst_n =1'b1;
    #30_000_000
    data = 8'b0000_1111;
    #30_000_000      
    data = 8'b1111_0000;
    $stop;
end



always #10 sys_clk = ~sys_clk;





endmodule