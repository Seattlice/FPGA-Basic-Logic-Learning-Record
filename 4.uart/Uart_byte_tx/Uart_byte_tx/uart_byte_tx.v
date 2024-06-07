module uart_byte_tx (
    input  wire                         sys_clk                    ,
    input  wire                         sys_rst_n                  ,
    input  wire        [   7: 0]        data                       ,

    output wire                         uart_tx                    ,
    output reg                         led                         
);
    
parameter MCNT_BAUD = 13'd5207;
parameter MCNT_BIT = 4'd9;
parameter MCNT_DLY = 26'd49_999_999;
parameter STAR_BIT = 1'b0;
parameter STOP_BIT = 1'b1;


reg [12:0] baud_div_cnt;
reg en_baud_cnt;     
reg [3:0] bit_cnt;

reg [25:0] delay_cnt;
reg [7:0] r_DATA;


//波特率计数器  1/9600s
always @(posedge sys_clk or negedge sys_rst_n)                                                 
    if(!sys_rst_n)                               
        baud_div_cnt <= 13'd0;                                                  
    else if(en_baud_cnt == 1'd1)                                
        if(baud_div_cnt == MCNT_BAUD)
            baud_div_cnt <= 13'd0;
        else 
            baud_div_cnt <= baud_div_cnt + 1'd1;                                                 
    else
        baud_div_cnt <= 13'd0;                                    

    always @(posedge sys_clk or negedge sys_rst_n)           
        begin                                        
            if(!sys_rst_n)                               
                en_baud_cnt <= 1'd0;                                         
            else if(delay_cnt == MCNT_DLY)
                en_baud_cnt <= 1'd1;
            else if((bit_cnt == 4'd9 )&&(baud_div_cnt == MCNT_BAUD))                                
                en_baud_cnt <= 1'd0;                                         
        end       




//位计数器
    always @(posedge sys_clk or negedge sys_rst_n)           
        begin                                        
            if(!sys_rst_n)                               
                bit_cnt <= 4'd0;                                             
            else if(baud_div_cnt == MCNT_BAUD)     
                if(bit_cnt == 4'd9)
                    bit_cnt <= 4'd0;
                else
                    bit_cnt <= bit_cnt + 1'd1;                           
                                   
        end                                          


//延时计数器
    always @(posedge sys_clk or negedge sys_rst_n)           
        begin                                           
            if(!sys_rst_n)                                           
                delay_cnt <= 25'd0;
            else if(delay_cnt == MCNT_DLY)
                delay_cnt <= 25'd0;
            else
                delay_cnt <= delay_cnt + 1'd1;    
        end                                      


    always @(posedge sys_clk or negedge sys_rst_n)           
        begin                                           
            if(!sys_rst_n)   
                r_DATA <= 8'd0;
            else if(delay_cnt = MCNT_DLY)
                r_DATA <= data;
            else
                r_DATA <= r_DATA;
        end

//位发送逻辑
    always @(posedge sys_clk or negedge sys_rst_n)           
        begin                                           
            if(!sys_rst_n)                               
                uart_tx <= 1'b1;     
            else if(en_baud_cnt == 1'd0)
                uart_tx <= 1'd1;    
            else begin
                case(bit_cnt)
                    4'd0:uart_tx <= STAR_BIT;
                    4'd1:uart_tx <= r_DATA[0];
                    4'd2:uart_tx <= r_DATA[1];
                    4'd3:uart_tx <= r_DATA[2];
                    4'd4:uart_tx <= r_DATA[3];
                    4'd5:uart_tx <= r_DATA[4];
                    4'd6:uart_tx <= r_DATA[5];
                    4'd7:uart_tx <= r_DATA[6];
                    4'd8:uart_tx <= r_DATA[7];
                    4'd9:uart_tx <= STOP_BIT;
                default:uart_tx <= uart_tx;      
                endcase
            end                                   
        end                                          


//led翻转逻辑
    always @(posedge sys_clk or negedge sys_rst_n)           
        begin                                        
            if(!sys_rst_n)                               
                led <= 1'd0;                                         
            else if((bit_cnt == 4'd9 )&&(baud_div_cnt == MCNT_BAUD))                                
                led <= !led;                                         
            else            
                led <= led;                         
        end                                          

    


endmodule