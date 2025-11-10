`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/11/08 18:24:40
// Design Name: 
// Module Name: tb_beep
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


module tb_beep();
reg clk;
reg rst_n;
reg enable;
wire output_beep;
//·ÂÕæµ÷ÊÔ
initial begin
clk=1'b1;
enable=1'b1;
rst_n<=1'b0;
#20
rst_n<=1'b1;

end
always #10 clk=~clk;

beep_The_East_Is_Red
#(
.time_1s(9'd49_9),
.time_500ms(9'd24_9),
.DO (8'd190),
.RE (8'd170),
.MI (8'd151),
.FA (8'd143),
.SO (8'd127),
.LA (8'd113),
.XI (8'd101),
.DOO(8'd95)
)u_beep
(
. clk(clk),
. rst_n(rst_n),
. enable(enable),
. beep (beep)   
    );
endmodule
