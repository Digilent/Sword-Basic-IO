`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Digilent
// Engineer: Arthur Brown
// 
// Create Date: 11/21/2017 11:21:41 AM
// Design Name: 
// Module Name: hamming_weight
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: Implements 32-bit Hamming Weight algorithm in a five stage pipeline. Takes the sum of each bit in din.
//      5-stage pipeline, captures din whenever din_valid is asserted, asserts dout_valid and outputs on dout 5 clock cycles later.
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module hamming_weight(clk, din_valid, din, dout_valid, dout);
    input wire clk;
    input wire din_valid;
    input wire [31:0] din;
    output wire dout_valid;
    output wire [5:0] dout;

    reg [31:0] stage [4:0]; // registers for 5-stage pipeline
    reg [4:0] valid;

    always@(posedge clk) begin
        stage[0] <= din - ({1'b0,din[31:1]} & 32'h55555555); // place sum of each pair of bits into those two bits
        valid[0] <= din_valid;
        stage[1] <= (stage[0] & 32'h33333333) + (stage[0][31:2] & 32'h33333333); // sum each nibble
        valid[1] <= valid[0];
        stage[2] <= (stage[1] & 32'h0f0f0f0f) + (stage[1][31:4] & 32'h0f0f0f0f); // sum each byte
        valid[2] <= valid[1];
        stage[3] <= (stage[2] & 32'h00ff00ff) + (stage[2][31:8] & 32'h00ff00ff); // sum each group of sixteen bits
        valid[3] <= valid[2];
        stage[4] <= (stage[3] & 32'h0000ffff) + (stage[3][31:16] & 32'h0000ffff); // calculate hamming weight
        valid[4] <= valid[3];
    end
    
    assign dout_valid = valid[4];
    assign dout = stage[4][5:0];
endmodule
