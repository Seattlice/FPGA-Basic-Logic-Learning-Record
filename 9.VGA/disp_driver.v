
`include "disp_parameter_cfg.v"

module disp_driver(
        ClkDisp,
        Rst_n,
        Data,

        DataReq,
        H_Addr,
        V_Addr,
        Disp_HS,
        Disp_VS,
        Disp_Red,
        Disp_Green,
        Disp_Blue,
        Disp_DE,
        Disp_PCLK
        );
    input                               ClkDisp                    ;
    input                               Rst_n                      ;
    input              [`Red_Bits + `Green_Bits + `Blue_Bits - 1:0]Data;

    output                              DataReq                    ;//Disp_DE
    output             [  11: 0]        H_Addr                     ;//位置信号
    output             [  11: 0]        V_Addr                     ;//位置信号
    output reg                          Disp_HS                    ;//判断脉冲信号
    output reg                          Disp_VS                    ;//判断脉冲信号
    output reg         [`Red_Bits - 1 :0]Disp_Red                  ;//RGB
    output reg         [`Green_Bits - 1 :0]Disp_Green              ;//RGB
    output reg         [`Blue_Bits - 1 :0]Disp_Blue                ;//RGB
    output reg                          Disp_DE                    ;//信号强是否使能信号
    output                              Disp_PCLK                  ;//DAC信号




    wire hcount_ov;
    wire vcount_ov;

    //----------------内部寄存器定义----------------
    reg [11:0] hcount_r; //行扫描计数器
    reg [11:0] vcount_r; //场扫描计数器

    assign Disp_PCLK = ~ClkDisp;
    assign DataReq = Disp_DE;

    parameter hdat_begin = `H_Sync_Time + `H_Back_Porch + `H_Left_Border - 1'b1;
    parameter hdat_end = `H_Total_Time - `H_Right_Border - `H_Front_Porch - 1'b1;
    parameter vdat_begin = `V_Sync_Time + `V_Back_Porch + `V_Top_Border - 1'b1;
    parameter vdat_end = `V_Total_Time - `V_Bottom_Border -`V_Front_Porch - 1'b1; 

    assign H_Addr = Disp_DE?(hcount_r - hdat_begin):12'd0;
    assign V_Addr = Disp_DE?(vcount_r - vdat_begin):12'd0;

    //行扫描
    assign hcount_ov = (hcount_r >= `H_Total_Time - 1);


    always@(posedge ClkDisp or negedge Rst_n)
        if(!Rst_n)
            hcount_r <= 0;
        else if(hcount_ov)
            hcount_r <= 0;
        else
            hcount_r <= hcount_r + 1'b1;


    //场扫描
    assign vcount_ov = (vcount_r >= `V_Total_Time - 1);

    always@(posedge ClkDisp or negedge Rst_n)
        if(!Rst_n)
            vcount_r <= 0;
        else if(hcount_ov) begin
        if(vcount_ov)
            vcount_r <= 0;
        else
            vcount_r <= vcount_r + 1'd1;
        end
        else
            vcount_r <= vcount_r;

    always@(posedge ClkDisp)
        Disp_DE <= ((hcount_r >= hdat_begin)&&(hcount_r <hdat_end))&&((vcount_r >= vdat_begin)&&(vcount_r < vdat_end));

    always@(posedge ClkDisp) begin
        Disp_HS <= (hcount_r > `H_Sync_Time - 1);
        Disp_VS <= (vcount_r > `V_Sync_Time - 1);
        {Disp_Red,Disp_Green,Disp_Blue} <= (Disp_DE)?Data:1'd0;
    end

endmodule