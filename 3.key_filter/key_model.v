
always@(posedge clk or posedge reset)
    if(reset)
        cnt <= 20'd0;
    else if(en_cnt)
        cnt <= cnt + 1'b1;
    else
        cnt <= 20'd0;

        
always@(posedge clk or posedge reset)
    if(reset)
        cnt_full <= 1'b0;
    else if(cnt == 20'd999_999)
        cnt_full <= 1'b1;
    else
        cnt_full <= 1'b0;

localparam
IDLE= 4'b0001,
FILTER0= 4'b0010,
DOWN= 4'b0100,
FILTER1= 4'b1000;

always@(posedge clk or posedge reset)
    if(reset)begin
        en_cnt <= 1'b0;
        state <= IDLE;
        key_flag <= 1'b0;
        key_state <= 1'b1;
    end
    else begin
    case(state)
        IDLE :begin
            key_flag <= 1'b0;
            if(key_in_nedge)begin
                state <= FILTER0;
                en_cnt <= 1'b1;
                end
            else
                state <= IDLE;
            end
        FILTER0:begin
            if(cnt_full)begin
                key_flag <= 1'b1;
                key_state <= 1'b0;
                en_cnt <= 1'b0;
                state <= DOWN;
            end
            else if(key_in_pedge)begin
                state <= IDLE;
                en_cnt <= 1'b0;
            end
            else
                state <= FILTER0;
            end
        DOWN:begin
            key_flag <= 1'b0;
            if(key_in_pedge)begin
                state <= FILTER1;
                en_cnt <= 1'b1;
            end
            else
                state <= DOWN;
            end
        FILTER1:begin
            if(cnt_full)begin
                key_flag <= 1'b1;
                key_state <= 1'b1;
                state <= IDLE;
                en_cnt <= 1'b0;
            end
            else if(key_in_nedge)begin
                en_cnt <= 1'b0;
                state <= DOWN;
            end
            else
                state <= FILTER1;
            end
        default:begin
        state <= IDLE;
        en_cnt <= 1'b0;
        key_flag <= 1'b0;
        key_state <= 1'b1;
    end
    endcase
end
