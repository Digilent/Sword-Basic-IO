`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/21/2017 11:52:44 AM
// Design Name: 
// Module Name: btn_pressed
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


module btn_pressed(btn, row, col);
    input wire [24:0] btn;
    output reg [3:0] row;
    output reg [3:0] col;
    always@*
        if (btn[0] == 1) {row, col} = 8'h00;
        else if (btn[1] == 1) {row, col} = 8'h01;
        else if (btn[2] == 1) {row, col} = 8'h02;
        else if (btn[3] == 1) {row, col} = 8'h03;
        else if (btn[4] == 1) {row, col} = 8'h04;
        else if (btn[5] == 1) {row, col} = 8'h10;
        else if (btn[6] == 1) {row, col} = 8'h11;
        else if (btn[7] == 1) {row, col} = 8'h12;
        else if (btn[8] == 1) {row, col} = 8'h13;
        else if (btn[9] == 1) {row, col} = 8'h14;
        else if (btn[10] == 1) {row, col} = 8'h20;
        else if (btn[11] == 1) {row, col} = 8'h21;
        else if (btn[12] == 1) {row, col} = 8'h22;
        else if (btn[13] == 1) {row, col} = 8'h23;
        else if (btn[14] == 1) {row, col} = 8'h24;
        else if (btn[15] == 1) {row, col} = 8'h30;
        else if (btn[16] == 1) {row, col} = 8'h31;
        else if (btn[17] == 1) {row, col} = 8'h32;
        else if (btn[18] == 1) {row, col} = 8'h33;
        else if (btn[19] == 1) {row, col} = 8'h34;
        else if (btn[20] == 1) {row, col} = 8'h40;
        else if (btn[21] == 1) {row, col} = 8'h41;
        else if (btn[22] == 1) {row, col} = 8'h42;
        else if (btn[23] == 1) {row, col} = 8'h43;
        else if (btn[24] == 1) {row, col} = 8'h44;
        else {row, col} = 0;
endmodule
