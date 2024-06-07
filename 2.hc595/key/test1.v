//对于波形选择wave_sel的控制
reg [2:0] wave_cnt;

always@(posedge clk or negedge reset_n)
    if(!reset_n)
        wave_cnt <= 3'b0;
    else if(key_wave)
        wave_cnt <= wave_cnt + 1'd1;
    else if(wave_cnt == 3'd6)
        wave_cnt <= 3'b0;
    else
        wave_cnt <= wave_cnt;

always@(posedge clk or negedge reset_n)
    if(!reset_n)
        wave_sel <= 6'b000_001;
    else 
        case (wave_cnt)
        3'd0:wave_sel <= 6'b000_001;
        3'd1:wave_sel <= 6'b000_010;
        3'd2:wave_sel <= 6'b000_100;
        3'd3:wave_sel <= 6'b001_000;
        3'd4:wave_sel <= 6'b010_000;
        3'd5:wave_sel <= 6'b100_000;        
        default:wave_sel <= 6'b000_001;
        endcase