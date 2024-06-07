`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/05/13 15:20:35
// Design Name: 
// Module Name: tb_uart_byte_rx
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


module tb_uart_byte_rx ();
    reg                                 sys_clk                    ;
    reg                                 sys_rst_n                  ;
    reg                                 uart_tx                    ;
    wire               [   7: 0]        rx_data                    ;
    wire                                rx_done                    ;

    always #10 sys_clk = ~sys_clk;

    initial begin
        sys_clk = 1'b1;
        sys_rst_n = 1'b0;
        uart_tx   = 1'b1;
        #10;
        sys_rst_n = 1'b1;
        #200;
        //8'b0101_0101
        uart_tx = 1'b0;#(5208*20);  //起始位
        uart_tx = 1'b0;#(5208*20);  //bit0
        uart_tx = 1'b1;#(5208*20);  //bit1
        uart_tx = 1'b0;#(5208*20);  //bit2
        uart_tx = 1'b1;#(5208*20);  //bit3
        uart_tx = 1'b0;#(5208*20);  //bit4
        uart_tx = 1'b1;#(5208*20);  //bit5
        uart_tx = 1'b0;#(5208*20);  //bit6
        uart_tx = 1'b1;#(5208*20);  //bit7
        uart_tx = 1'b1;#(5208*20);  //结束位
        #(5208*20*10);

        //8'b1111_0000
        uart_tx = 1'b0;#(5208*20);  //起始位
        uart_tx = 1'b1;#(5208*20);  //bit0
        uart_tx = 1'b1;#(5208*20);  //bit1
        uart_tx = 1'b1;#(5208*20);  //bit2
        uart_tx = 1'b1;#(5208*20);  //bit3
        uart_tx = 1'b0;#(5208*20);  //bit4
        uart_tx = 1'b0;#(5208*20);  //bit5
        uart_tx = 1'b0;#(5208*20);  //bit6
        uart_tx = 1'b0;#(5208*20);  //bit7
        uart_tx = 1'b1;#(5208*20);  //结束位
        #(5208*20*10);

        //8'b0111_0001
        uart_tx = 1'b0;#(5208*20);  //起始位
        uart_tx = 1'b0;#(5208*20);  //bit0
        uart_tx = 1'b1;#(5208*20);  //bit1
        uart_tx = 1'b1;#(5208*20);  //bit2
        uart_tx = 1'b1;#(5208*20);  //bit3
        uart_tx = 1'b0;#(5208*20);  //bit4
        uart_tx = 1'b0;#(5208*20);  //bit5
        uart_tx = 1'b0;#(5208*20);  //bit6
        uart_tx = 1'b1;#(5208*20);  //bit7
        uart_tx = 1'b1;#(5208*20);  //结束位
        $stop;
        #(5208*20*10);


    end







    uart_byte_rx uart_byte_rx_inst(
        .sys_clk                            (sys_clk                   ),
        .sys_rst_n                          (sys_rst_n                 ),
        .uart_tx                            (uart_tx                   ),

        .rx_data                            (rx_data                   ),
        .rx_done                            (rx_done                   ) 
    );



endmodule
