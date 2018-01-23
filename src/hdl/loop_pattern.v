`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/28/2017 02:00:11 PM
// Design Name: 
// Module Name: loop_pattern
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


module loop_pattern (
    input clk,
    input en,
    output [63:0] dout,
    output flag
);
    parameter CLOCK_FREQUENCY = 200000000;
    parameter REFRESH_RATE = 10;
    localparam ROM_DEPTH = 36;
    reg [5:0] addr = 0;
    reg [31:0] count = 0;
    
    blk_mem_gen_0 pattern_rom (
        .clka(clk),
        .addra(addr),
        .douta(dout)
    );
    
    always@(posedge clk)
        if (en == 1) begin
            if (count == CLOCK_FREQUENCY/REFRESH_RATE-1) begin
                count <= 0;
                if (addr == ROM_DEPTH-1)
                    addr <= 0;
                else
                    addr <= addr + 1;
            end else
                count <= count + 1;
        end
    assign flag = (en == 1 && count == 0) ? 1'b1 : 1'b0;
endmodule