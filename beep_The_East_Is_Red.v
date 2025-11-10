`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/11/04 17:24:03
// Design Name: 
// Module Name: beep_The_East_Is_Red
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


module beep_The_East_Is_Red
#(parameter time_1s =26'd49_999_999,
parameter time_500ms =25'd24_999_999,
parameter DO =18'd190840,
parameter RE =18'd170068,
parameter MI =18'd151515,
parameter FA =18'd143266,
parameter SO =18'd127551,
parameter LA =18'd113636,
parameter XI =18'd101214,
parameter DOO =18'd95556
)
(
input wire clk,
input wire rst_n,
input wire enable,
output reg beep
    );
 reg [25:0] cnt_time;
 reg [17:0] cnt_freq;
 reg [17:0] freq;
 wire[17:0] pwm;
 reg[5:0]  cnt_point;
 reg [25:0] sing_time;
 assign pwm=freq>>1;
 
 /*异步复位，同步释放*/
 reg buffer_meta;
 reg rst_sync;
 wire rst_sync_n;
 always@(posedge clk or negedge rst_n)
 
    if(!rst_n)
    begin
    buffer_meta<=1'b0;
    rst_sync<=1'b0;
    end
else
begin
        buffer_meta<=1'b1;
        rst_sync<=buffer_meta;
end
 assign rst_sync_n=rst_sync;
 /**********************************main code***********************/
 //音节计数器，控制蜂鸣器唱到哪个位置
 always@(posedge clk or negedge rst_sync_n)
 begin
    if(!rst_sync_n)
        begin
            cnt_point<=6'b0;
        end
    else if(enable==1'b1)
        begin
                if(cnt_point==6'd17&&cnt_time==sing_time)
                     cnt_point<=6'b0;
                else if(cnt_time==sing_time)
                     cnt_point<=cnt_point+1'b1;
                else
                 cnt_point<=cnt_point;
        end
    else
        cnt_point<=6'b0;
 end
 /*音节计数器，控制蜂鸣器唱到哪个位置(另外一种写法）
 always@(posedge clk or negedge rst_sync_n)
 begin
 if(!rst_sync_n) begin
    cnt_point <= 6'b0;                    // 路径1：复位
end else if(enable == 1'b1) begin
    if(cnt_time == sing_time) begin
        cnt_point <= (cnt_point == 6'd17) ? 6'b0 : cnt_point + 1'b1; // 路径2：条件更新
    end
end
end
// 路径3：隐含的保持（时序逻辑自动保持）
 */
 //两个时间计数器，0.5s模拟音节连起
 always@(posedge clk or negedge rst_sync_n)
 begin
        if(!rst_sync_n)
            begin
                cnt_time<=1'b0;
            end
        else if(enable==1'b1)
            if(cnt_time==sing_time)
                cnt_time<=26'b0;
            else 
            cnt_time<=cnt_time+1'b1;
        else 
            cnt_time<=cnt_time;
        end
//曲谱
always@(*)
begin
    case(cnt_point)
        7'd0:freq<=SO;
        
        7'd1:freq<=SO; 
        7'd2:freq<=LA; 
        
        7'd3:freq<=RE;
        //东.方.红
        7'd4:freq<=DO;
        
        7'd5:freq<=DO;
        7'd6:freq<=LA; 
        
        7'd7:freq<=RE;
        //太'阳'升
        7'd8:freq<=SO;
        
        7'd9:freq<=SO;
        
        7'd10:freq<=LA; 
        7'd11:freq<=DOO;
        
        7'd12:freq<=LA;
        7'd13:freq<=SO;
        
        7'd14:freq<=DO; 
        
        7'd15:freq<=DO;
        7'd16:freq<=SO;
        
        7'd17:freq<=RE;
        //中国出了个毛泽东 
    default:freq<=DO;
    endcase
end
//音节时间
always@(*)
begin
    case(cnt_point)
        7'd0:sing_time<=time_1s;
        
        7'd1:sing_time<=time_500ms; 
        7'd2:sing_time<=time_500ms; 
        
        7'd3:sing_time<=time_1s;
        //东.方.红
        7'd4:sing_time<=time_1s;
        
        7'd5:sing_time<=time_500ms;
        7'd6:sing_time<=time_500ms; 
        
        7'd7:sing_time<=time_1s;
        //太'阳'升
        7'd8:sing_time<=time_1s;
        
        7'd9:sing_time<=time_1s;
        
        7'd10:sing_time<=time_500ms; 
        7'd11:sing_time<=time_500ms;
        
        7'd12:sing_time<=time_500ms;
        7'd13:sing_time<=time_500ms;
        
        7'd14:sing_time<=time_1s; 
        
        7'd15:sing_time<=time_500ms;
        7'd16:sing_time<=time_500ms;
        
        7'd17:sing_time<=time_1s;
        //中国出了个毛泽东 
    default:sing_time<=time_1s;
    endcase
end

//音频计数器
always@(posedge clk or negedge rst_sync_n)
 begin
    if(!rst_sync_n)
        begin
            cnt_freq<=18'b0;
        end
    else if(enable)
        begin
        if(cnt_freq==freq||cnt_time==sing_time)//时间到了，必须清零
             cnt_freq<=18'b0;
         else
             cnt_freq<=cnt_freq+1'b1;
        end
    else
    cnt_freq<=18'b0;
end
//**********************************output***************************//
always@(posedge clk or negedge rst_sync_n)
 begin
    if(!rst_sync_n)
        begin
            beep<=1'b0;
        end
    else if(enable)
        begin
        if(cnt_freq<=pwm)
             beep<=1'b1;
        else
             beep<=1'b0;
        end
    else
    beep<=1'b0;
end
endmodule
