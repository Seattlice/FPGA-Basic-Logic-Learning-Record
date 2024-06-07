`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/06/07 11:03:42
// Design Name: 
// Module Name: tb_ram
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


module tb_ram();

reg sys_clk_a;
reg sys_clk_b;
reg sys_rst_n;
reg wea;
reg [7:0] addra;
reg [7:0] dina;
reg [7:0] addrb;
wire [7:0] doutb;
reg [4:0] i;

ram_stu ram_stu_1 (
  .clka(sys_clk_a),    // input wire clka
  .wea(wea),      // input wire [0 : 0] wea
  .addra(addra),  // input wire [7 : 0] addra
  .dina(dina),    // input wire [7 : 0] dina
  .clkb(sys_clk_b),    // input wire clkb
  .addrb(addrb),  // input wire [7 : 0] addrb
  .doutb(doutb)  // output wire [7 : 0] doutb
);


initial begin
sys_clk_a = 1'b0;
sys_clk_b = 1'b0;
end

always #10 sys_clk_a = ~sys_clk_a;
always #10 sys_clk_b = ~sys_clk_b;

initial begin 
wea = 1'b0;
addra = 8'b0;
dina = 8'b0;
addrb = 8'd255;
#199
wea = 1;

for ( i=0;i<=15;i=i+1)begin     
    dina=255-i; 
    addra = i; 
    #20;
end

wea = 0;
#1; 
for( i=0;i<=15;i=i+1)begin 
    addrb = i; 
    #40; 
  end 
  #200; 
  $stop;   
end 
 
endmodule 


