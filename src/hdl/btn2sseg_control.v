`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Digilent
// Engineer: Arthur Brown
// 
// Create Date: 12/08/2017 12:00:40 PM
// Design Name: 
// Module Name: btn2sseg_control
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: simple state machine to control uart transmitter and seven segment portions of sword basic-io demo.
//     when a valid sample from the keypad is received, forward it to the keypad. forward it to the uart only if only one button is pressed.
//     when no buttons are pressed, enable the loop pattern controller and forward the loop to the seven-segment controller
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module btn2sseg_control(clk, rst, num_btns, num_btns_valid, kypd_btn, kypd_btn_valid, loop_data, loop_event, loop_en, ss_idle, ss_data, ss_digit_en, ss_start, tx_start, tx_data0, tx_data1);
    input wire clk;
    input wire rst;
    
    input wire [5:0] num_btns;
    input wire num_btns_valid;
    
    input wire [24:0] kypd_btn;
    input wire kypd_btn_valid;
    
    input wire [63:0] loop_data;
    input wire loop_event; 
    output wire loop_en;
    
    input wire ss_idle;
    output wire [63:0] ss_data;
    output wire [7:0] ss_digit_en;
    output wire ss_start;
    output wire tx_start;
    output reg [3:0] tx_data0;
    output reg [3:0] tx_data1;
    
    wire [3:0] btn_row, btn_col;
    btn_pressed get_btn_pressed (
        kypd_btn,
        btn_row, btn_col
    );
    reg [3:0] _btn_row, _btn_col;
    reg [5:0] _num_btns;
    reg suppress_loop = 0;
    reg ss_start_0 = 0;
    reg tx_start_0 = 0;
    reg [63:0] ss_data_0;
    reg [7:0] ss_digit_en_0;
    
    wire [63:0] bin2sseg_dout;
    wire [31:0] bin2sseg_din;
    
    genvar i; // convert row/column values to pattern to be displayed.
    assign bin2sseg_din = {12'b0, btn_row, 12'b0, btn_col};
    generate for (i=0; i<8; i=i+1) begin : get_sseg_data
        bin2sseg get_data (
            .din(bin2sseg_din[4*i+3:4*i]),
            .dout(bin2sseg_dout[8*i+7:8*i])
        );
    end endgenerate
    
    always@(posedge clk)
        if (rst == 1) begin
            _btn_row <= 'b0;
            _btn_col <= 'b0;
            _num_btns <= 'b0;
        end else if (num_btns_valid == 1 && kypd_btn_valid == 1 && ss_idle == 1) begin
            if (num_btns == 0)
                suppress_loop <= 0;
            else
                suppress_loop <= 1;
            
            if (_btn_row != btn_row || _btn_col != btn_col || _num_btns != num_btns) begin
                ss_start_0 <= 1;
                if (num_btns == 6'b1) begin
                    ss_data_0 <= bin2sseg_dout;
                    ss_digit_en_0 <= 8'h11;
                end else
                    ss_digit_en_0 <= 8'h00;
                    
                if (num_btns == 6'b1) begin
                    tx_start_0 <= 1;
                    tx_data0 <= btn_row;
                    tx_data1 <= btn_col;
                end else
                    tx_start_0 <= 0;
            end else
                ss_start_0 <= 0;
                
            _btn_row <= btn_row;
            _btn_col <= btn_col;
            _num_btns <= num_btns;
        end else begin
            ss_start_0 <= 0;
            tx_start_0 <= 0;
        end
    assign ss_start =    (suppress_loop == 1) ? ss_start_0    : loop_event;
    assign ss_digit_en = (suppress_loop == 1) ? ss_digit_en_0 : 8'hff;
    assign tx_start =    (suppress_loop == 1) ? tx_start_0    : 0;
    assign ss_data =     (suppress_loop == 1) ? ss_data_0     : loop_data;
    assign loop_en =     (suppress_loop == 1) ? 1'b0          : 1'b1;
endmodule
