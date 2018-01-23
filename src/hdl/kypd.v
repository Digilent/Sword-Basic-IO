`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Digilent
// Engineer: Arthur Brown
// 
// Create Date: 11/20/2017 01:43:43 PM
// Design Name: 
// Module Name: kypd
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: Implements an algorithm to read the state of the 25-button keypad of the sword board.
//      With default parameters, checks a different row of buttons every millisecond,
//      data can be captured once per 5ms (when btn_ready is high)
//      Could probably be run significantly faster, but the default parameters take care of some
//      debouncing concerns.
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module kypd (clk, kypd_row, kypd_col, btn_out, btn_ready);
    parameter CLOCKS_PER_ROW = 200000;
    parameter CLOCKS_PER_ROW_LOG2 = 18;
    localparam NUM_ROWS = 5, NUM_ROWS_LOG2 = 3, NUM_COLS = 5;
    input  wire clk;
    output wire [NUM_ROWS-1:0] kypd_row;
    input  wire [NUM_COLS-1:0] kypd_col;
    output reg [NUM_ROWS*NUM_COLS-1:0] btn_out;
    output reg btn_ready;
    
    reg [NUM_ROWS_LOG2-1:0] rowcount = 0; // index of the row to check, 0-4, increment 1 per millisecond
    reg [CLOCKS_PER_ROW_LOG2-1:0] count = 0; // counter to generate a 1kHz strobe
    reg [NUM_ROWS*NUM_COLS-1:0] btn = 0; // last state of each button
    always@(posedge clk)
        if (count >= CLOCKS_PER_ROW-1) begin
            count <= 0;
            if (rowcount >= NUM_ROWS-1)
                rowcount <= 0;
            else
                rowcount <= rowcount + 1;
        end else begin
            count <= count + 1;
            if (count == CLOCKS_PER_ROW/2-1) // halfway through count period
                btn <= {kypd_col, btn[NUM_ROWS*NUM_COLS-1:NUM_COLS]}; // capture the state of each button in the indexed row
        end
    
    genvar i;
    generate for (i=0; i<NUM_ROWS; i=i+1) begin : IDX
        assign kypd_row[i] = (rowcount == i) ? 0 : 1'bZ; // hold row pins that are not currently being tested high impedance to avoid short circuits
    end endgenerate
    
    always@(posedge clk)
        if (count >= CLOCKS_PER_ROW-1 && rowcount >= NUM_ROWS-1) begin
            btn_out <= ~btn; // invert output, so that btn_out is active-high
            btn_ready <= 1; // data is valid and can be captured
        end else
            btn_ready <= 0;
endmodule