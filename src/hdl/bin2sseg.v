`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/03/2018 01:02:46 PM
// Design Name: 
// Module Name: bin2sseg
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
//     converts 4bit decimal input to 8bit seven segment format in (msb)AA,AB,AC,AD,AE,AF,AG,DP(lsb) order
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module bin2sseg(
    input [3:0] din,
    output reg [7:0] dout
);
    always@*
    case (din) // cases use the nearest character equivalent to pattern to be displayed.
    4'h0: dout = 8'b11111100;
    4'h1: dout = 8'b01100000;
    4'h2: dout = 8'b11011010;
    4'h3: dout = 8'b11110010;
    4'h4: dout = 8'b01100110;
    4'h5: dout = 8'b10110110;
    4'h6: dout = 8'b10111110;
    4'h7: dout = 8'b11100000;
    4'h8: dout = 8'b11111110;
    4'h9: dout = 8'b11110110;
    4'hA: dout = 8'b11101110;
    4'hb: dout = 8'b00111110;
    4'hC: dout = 8'b10011100;
    4'hd: dout = 8'b01111010;
    4'hE: dout = 8'b10011110;
    4'hF: dout = 8'b10001110;
    endcase
endmodule
