//////////////////////////////////////////////////////////////////////////////////
// Company: XDU
// Engineer: HUALOU LI
// 
// Create Date: 2024/05/16 11:31:59
// Design Name: 
// Module Name: pwm_top
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

module uart_bytes_tx (
    input  wire                         sys_clk                    ,
    input  wire                         sys_rst_n                  ,
    input  wire        [   2: 0]        baud_set                   ,
    input  wire                         send_en                    ,
    input  wire                         data                       ,

    output wire                         uart_tx                    ,
    output wire                         uart_state                 ,

    output wire                         tx_done                     
);
    

    always @(posedge sys_clk or negedge sys_rst_n) begin
        if(!sys_rst_n)

        else if()

        else

    end



    endmodule