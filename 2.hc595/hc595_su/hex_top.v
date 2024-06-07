
//////////////////////////////////////////////////////////////////////////////////
module hex_top(
	input wire clk,//50M
	input wire reset_n,
	input wire [1:0] SW,
	
	
	output wire RCLK,
	output wire SRCLK,
	output wire DIO
);
	wire [7:0] sel;//数码管位选（选择当前要显示的数码管）
	wire [7:0] seg;//数码管段选（当前要显示的内容)
	reg [19:0] data;
	wire          [23:0]          bcd_data;
	
	hc595_driver hc595_driver(
		.clk(clk),
		.reset_n(reset_n),
		.sel(sel),
		.seg(seg),
		
		
		.RCLK(RCLK),
		.SRCLK(SRCLK),
		.DIO(DIO)
	);
	
	hex8 hex8(
		.clk(clk),
		.reset_n(reset_n),
		.en(1'b1),
		.bcd_data(bcd_data),
		
		
		.sel(sel),
		.seg(seg)
	);
	
	bcd_8421 bcd_8421_inst
(
.sys_clk                    (clk),//系统时钟，频率50MHz
.sys_rst_n                  (reset_n),//复位信号，低电平有效
.data                       (data),//输入需要转换的数据

.bcd_data                   (bcd_data)
 );

	
	
	always@(*)
	case(SW)
	   0:data <= 20'd123456;
	   1:data <= 20'd654321;
	   2:data <= 20'd666666;
	   3:data <= 20'd995461;
	   default:	data <= 20'd100000;
    endcase	   	
endmodule
