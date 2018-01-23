`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Digilent
// Engineer: Arthur Brown
// 
// Create Date: 11/20/2017 01:50:17 PM
// Design Name: 
// Module Name: rgb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: implements a simple PWM component to control two RGB leds, cycling through R, G, and B
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module rgb(clk, dout);
    input wire clk;
    output wire [5:0] dout;
    parameter PWM_MAX_LOG2 = 8, PWM_MAX = 255;
    reg [7:0] pwm = 0;
    reg [7:0] duty = 0;
    reg [31:0] counter = 0;
    reg dir = 0;
    reg [2:0] channel_enable = 1;
    always@(posedge clk) begin
        if (counter >= 390624) begin // 0.5 sec period
            counter <= 0;
            duty <= duty + 1;
            if (duty == 255) begin
                dir <= ~dir;
                if (dir == 1)
                    channel_enable <= {channel_enable[1:0], channel_enable[2]};
            end
        end else
            counter <= counter + 1;
        pwm <= pwm + 1;
    end
    
    wire [7:0] _duty, __duty;
    assign _duty = {8{dir}} ^ (duty); // invert on dir == 1
    assign __duty = _duty > 127 ? 128 : _duty; //cap at 1/2 of full brightness
    assign dout = {2{channel_enable}} & {6{ ( __duty > pwm ) ? 1'b1 : 1'b0}};
endmodule
