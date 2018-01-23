`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Digilent
// Engineer: Arthur Brown
// 
// Create Date: 12/08/2017 11:49:58 AM
// Design Name: 
// Module Name: buffer
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: implements a simple delay pipeline. dout mirrors din LATENCY clocks later.
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module buffer(clk, din, din_valid, dout, dout_valid);
    parameter DATA_WIDTH = 32;
    parameter LATENCY = 5;
    input wire clk;
    input wire [DATA_WIDTH-1:0] din;
    input wire din_valid;
    output wire [DATA_WIDTH-1:0] dout;
    output wire dout_valid;
    
    reg [DATA_WIDTH-1:0] data [LATENCY-1:0];
    reg valid [LATENCY-1:0];
    
    genvar i;
    generate for (i=0; i<LATENCY; i=i+1) begin : FOR_EACH_STAGE
        always@(posedge clk)
            if (i == 0) begin
                if (din_valid == 1)
                    data[i] <= din;
                valid[i] <= din_valid;
            end else begin
                if (valid[i-1] == 1)
                    data[i] <= data[i-1];
                valid[i] <= valid[i-1];
            end
    end endgenerate
    assign dout = data[LATENCY-1];
    assign dout_valid = valid[LATENCY-1];
endmodule
