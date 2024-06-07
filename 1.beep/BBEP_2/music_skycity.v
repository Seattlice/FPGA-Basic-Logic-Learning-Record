`timescale 1ns / 1ps
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

//该项目为蜂鸣器的使用，利用蜂鸣器来发生天空之城
module music_ske_city (
    input  wire                         sys_clk                    ,
    input  wire                         sys_rst_n                  ,

    output reg                          pwm_out
);
    
wire [8:0] pitch_num;       //rom地址，音调的选择
wire [4:0] pitch;            //音乐的音调
reg  [31:0]counter_arr;    //预重装值寄存器 
wire [31:0]counter_ccr;    //输出比较值 

    //乐谱存放rom 
    music_rom music_rom  ( 
        .clka(sys_clk), // input wire clka 
 
        .addra(pitch_num), // input wire [7 : 0] addra 
        .douta(pitch)  // output wire [7 : 0] douta 
    ); 

    get_pitch get_pitch_inst(
        .sys_clk                            (sys_clk                   ),
        .sys_rst_n                          (sys_rst_n                 ),

        .pitch_num                          (pitch_num                 ) 
    );
 
    //调用PWM发生模块
    beep beep_inst(
        .sys_clk                            (sys_clk                   ),
        .sys_rst_n                          (sys_rst_n                 ),
        .pwm_gen_en                         (1'b1                      ),
        .counter_arr                        (counter_arr               ),
        .counter_ccr                        (counter_ccr               ),

        .pwm_out                            (pwm_out                   ) 
    );

    localparam    DL1 = 340136; //D 调低音1 
    localparam    DL2 = 303030; //D 调低音2 
    localparam    DL3 = 285714; //D调低音3 
    localparam    DL4 = 255102; //D调低音4 
    localparam    DL5 = 226244; //D调低音5 
    localparam    DL6 = 201613; //D调低音6 
    localparam    DL7 = 179856; //D调低音7 
    
    localparam    D1  = 170068; //D调音1  
    localparam    D2  = 151515; //D调音2  
    localparam    D3  = 142857; //D调音3  
    localparam    D4  = 127227;//D调音4  
    localparam    D5  = 113379; //D调音5  
    localparam    D6  = 101010; //D调音6  
    localparam    D7  = 89928 ; //D调音7  
    
    localparam    DH1 = 84889; //D调高音1  
    localparam    DH2 = 75643;  //D调高音2  
    localparam    DH3 = 71429;  //D调高音3  
    localparam    DH4 = 63613;  //D调高音4  
    localparam    DH5 = 56689;  //D调高音5  
    localparam    DH6 = 50505;  //D调高音6  
    localparam    DH7 = 44964;  //D调高音7

 //根据rom存储输出不同的音调输出不同的预置数   
    always@(posedge clk or posedge reset) 
    if(reset) 
        counter_arr  <= 32'd1; 
    else 
    begin 
        case(pitch) 
            5'b01_001:counter_arr  <= DL1;  //D调低音1 
            5'b01_010:counter_arr  <= DL2;  //D调低音2 
            5'b01_011:counter_arr  <= DL3;  //D调低音3
            5'b01_100:counter_arr  <= DL4;  //D调低音4 
            5'b01_101:counter_arr  <= DL5;  //D调低音5   
            5'b01_110:counter_arr  <= DL6;  //D调低音6 
            5'b01_111:counter_arr  <= DL7;  //D调低音7 
 
            5'b10_001:counter_arr  <= D1;   //D调音1            
            5'b10_010:counter_arr  <= D2;   //D调音2                
            5'b10_011:counter_arr  <= D3;   //D调音3                
            5'b10_100:counter_arr  <= D4;   //D调音4                
            5'b10_101:counter_arr  <= D5;   //D调音5    
            5'b10_110:counter_arr  <= D6;   //D调音6    
            5'b10_111:counter_arr  <= D7;   //D调音7 
 
            5'b11_001:counter_arr  <= DH1;  //D调高音1           
            5'b11_010:counter_arr  <= DH2;  //D调高音2 
            5'b11_011:counter_arr  <= DH3;  //D调高音3 
            5'b11_100:counter_arr  <= DH4;  //D调高音4   
            5'b11_101:counter_arr  <= DH5;  //D调高音5 
            5'b11_110:counter_arr  <= DH6;  //D调高音6 
            5'b11_111:counter_arr  <= DH7;  //D调高音7 
 
            default:  counter_arr  <= 32'd1;//休止符 
        endcase 
    end

       
    assign counter_ccr = counter_arr >> 1;  //设置输出比较值为预重装值一半 


endmodule