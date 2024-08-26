`timescale 1ns/1ns
`define clk_period 40

module VGA_CTRL_tb();
    //----------------模块输入端口----------------
    reg                                 Clk25M                     ;//系统输入时钟 25MHZ
    reg                                 Rst_n                      ;
    reg                [  23: 0]        data_in                    ;//待显示数据     

    //----------------模块输出端口----------------
    wire               [   9: 0]        hcount                     ;
    wire               [   9: 0]        vcount                     ;
    wire               [  23: 0]        VGA_RGB                    ;//VGA 数据输出
    wire                                VGA_HS                     ;//VGA 行同步信号
    wire                                VGA_VS                     ;//VGA 场同步信号
    wire                                VGA_BLK                    ;//VGA 行同步信号
    wire                                VGA_CLK                    ;//VGA 场同步信号

    reg [11:0] V_cnt = 0;//扫描行数统计计数器

    VGA_CTRL VGA_CTRL(
    .Clk25M                             (Clk25M                    ),//系统输入时钟 25MHZ
    .Rst_n                              (Rst_n                     ),
    .data_in                            (data_in                   ),//待显示数据
    .hcount                             (hcount                    ),//VGA 行扫描计数器
    .vcount                             (vcount                    ),//VGA 场扫描计数器
    .VGA_RGB                            (VGA_RGB                   ),//VGA 数据输出
    .VGA_HS                             (VGA_HS                    ),//VGA 行同步信号
    .VGA_VS                             (VGA_VS                    ),//VGA 场同步信号
    .VGA_BLK                            (VGA_BLK                   ),//VGA 场消隐信号
    .VGA_CLK                            (VGA_CLK                   ) //VGA DAC 输出时钟
    );


    initial Clk25M = 0;
    always #20 Clk25M = ~Clk25M;

    initial begin
        Rst_n = 0;
        data_in = 8'd0;
        #(`clk_period *20 +1);
        Rst_n = 1;
        data_in = 24'hffffff;
    end

    initial begin
    wait(V_cnt == 3);//等待扫描 2 帧后结束仿真
    $stop;
    end

        always @(posedge VGA_VS)//统计总扫描帧数
            V_cnt <= V_cnt + 1'b1;
            
endmodule
                                                                   
