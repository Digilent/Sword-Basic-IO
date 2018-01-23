`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Digilent
// Engineer: Arthur Brown
// 
// Create Date: 11/20/2017 01:43:43 PM
// Design Name: 
// Module Name: sseg
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: Shifts data out to control the sword board Seven Segment Display. 
//      din contains data to be shifted out in (msb)AA,AB,AC,AD,AE,AF,AG,DP(lsb) order, most significant byte contains leftmost digit
//      each bit of digit_en enables the corresponding digit when high.
//      when start is asserted while idle is high, din and digit_en are registered, then shifted out to the seven segment display.
//      while data is being shifted, the display is disabled.
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// 
//////////////////////////////////////////////////////////////////////////////////


module sseg(clk, rst, din, start, digit_en, idle, ss_sdo, ss_clk, ss_en);
    input wire clk;
    input wire rst;
    input wire [63:0] din;
    input wire start;
    input wire [7:0] digit_en;
    output reg idle = 1;
    output wire ss_sdo, ss_clk;
    output reg ss_en = 0;
    
    reg [63:0] data;
    reg [1:0] count;
    reg [5:0] bit_count;
    reg [7:0] _digit_en;
    
//    assign ss_en = idle;
    
    always@(posedge clk)
        if (rst == 1) begin
            ss_en <= 0;
            idle <= 0;
            count <= 0;
            _digit_en <= 8'b0;
            bit_count <= 0;
        end else if (idle == 1) begin
            if (start == 1) begin
                ss_en <= 0;
                idle <= 0;
                count <= 0;
                _digit_en <= digit_en;
                bit_count <= 0;
                data <= din;
            end
        end else if (count == 2'b11) begin
            count <= 0;
            if (bit_count == 6'h3F) begin
                idle <= 1;
                ss_en <= 1;
            end else
                bit_count <= bit_count + 1;
        end else
            count <= count + 1;
    assign ss_clk = (idle == 1 || count[1] == 1) ? 1 : 0; // data is stable on ss_clk posedge
    
    assign ss_sdo = (_digit_en[bit_count[5:3]] == 1) ? data[bit_count] : 0;
    
endmodule
