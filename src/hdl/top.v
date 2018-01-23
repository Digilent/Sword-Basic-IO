`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Digilent
// Engineer: Arthur Brown
// 
// Create Date: 11/20/2017 01:43:43 PM
// Design Name: 
// Module Name: top
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: contains demonstrations of many of the basic peripherals of the sword board.
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module top(clk_p, clk_n, kypd_row, kypd_col, ss_sdo, ss_clk, ss_en, led, sw, led16_b, led16_g, led16_r, led17_b, led17_g, led17_r, vga_r, vga_g, vga_b, vga_hs, vga_vs, uart_tx_out, btnurst, ps2_clk, ps2_data);
    //Clock
    input  wire clk_p;
    input  wire clk_n;
    inout wire ps2_clk;
    inout wire ps2_data;
    //Reset
    input  wire btnurst;
    //Keypad
    output wire [4:0] kypd_row;
    input  wire [4:0] kypd_col;
    //LEDs and Switches
    output wire [15:0] led;
    input  wire [15:0] sw;
    //Seven Segment Display
    output wire ss_sdo;
    output wire ss_clk;
    output wire ss_en;
    //RGB LEDs
    output wire led16_b;
    output wire led16_g;
    output wire led16_r;
    output wire led17_b;
    output wire led17_g;
    output wire led17_r;
    //VGA Port
    output wire [7:3] vga_r;
    output wire [7:2] vga_g;
    output wire [7:3] vga_b;
    output wire vga_hs;
    output wire vga_vs;
    //USB-UART Bridge Transmit
    output wire uart_tx_out;
    
    //TODO: add btnurst support to btn2sseg_control, sseg, rgb, vga, uart_hex_format
    
    wire clk, pxl_clk;
    //turn differential input clock into a single ended 200MHz clock
    clk_wiz_0 get_clk (
        .clk_in1_p(clk_p),
        .clk_in1_n(clk_n),
        .clk_out1(clk),
        .clk_out2(pxl_clk)
    );
    
    reg rst = 1;
    always@(posedge clk)
        if (btnurst == 0)
            rst <= 1;
        else
            rst <= 0;
            
    //set each LED to the state of the adjacent switch
    assign led = sw;
    
    wire [24:0] kypd_btn_out;
    wire kypd_btn_ready;
    //continuously capture keypad state
    kypd keypad_controller (
        clk,
        kypd_row, kypd_col,
        kypd_btn_out, kypd_btn_ready
    );
    
    wire [24:0] kypd_btn;
    wire kypd_btn_valid;
    //delay kypd_btn to maintain alignment with num_btns
    buffer #(
        25, 5
    ) delay_num_btns (
        clk,
        kypd_btn_out, kypd_btn_ready,
        kypd_btn, kypd_btn_valid
    );
    
    wire [5:0] num_btns;
    wire num_btns_valid;
    //count the number of buttons pressed, if num_btns > 0, we cannot tell which buttons are being pressed for some patterns.
    hamming_weight get_num_btns (
        .clk(clk),
        .din_valid(kypd_btn_ready),
        .din({7'b0, kypd_btn_out}),
        .dout_valid(num_btns_valid),
        .dout(num_btns)
    );
        
    wire [63:0] loop_data;
    wire loop_event, loop_en;
    loop_pattern loop (
        clk,
        loop_en, loop_data, loop_event
    );
        
    wire [63:0] ss_din;
    wire ss_start;
    wire [7:0] ss_digit_en;
    wire ss_idle;
    wire tx_start;
    wire [3:0] tx_data0, tx_data1;
    //controller for sseg & uart
    btn2sseg_control controller (
        .clk(clk),
        .rst(rst),
        .num_btns(num_btns),
        .num_btns_valid(num_btns_valid),
        .kypd_btn(kypd_btn),
        .kypd_btn_valid(kypd_btn_valid),
        .loop_data(loop_data),
        .loop_event(loop_event),
        .loop_en(loop_en),
        .ss_idle(ss_idle),
        .ss_data(ss_din),
        .ss_digit_en(ss_digit_en),
        .ss_start(ss_start),
        .tx_start(tx_start),
        .tx_data0(tx_data0),
        .tx_data1(tx_data1)
    );
    //whenever a button is pressed, display it's row and column on the seven segment display
    sseg my_sseg (
        .clk(clk),
        .rst(rst),
        .din(ss_din),
        .digit_en(ss_digit_en),
        .start(ss_start),
        .idle(ss_idle),
        .ss_sdo(ss_sdo),
        .ss_clk(ss_clk),
        .ss_en(ss_en)
    );
    
    //cycle through RGB colors on the LEDs
    rgb rgb_inst (clk, {led16_b, led16_g, led16_r, led17_b, led17_g, led17_r});
    
    //display a pattern on the VGA monitor
    vga vga_inst (pxl_clk, vga_hs, vga_vs, vga_r, vga_g, vga_b);
    
    // whenever a single button is first pressed, print FORMAT_STRING.
    uart_hex_format #(
        .CLOCK_FREQUENCY(200000000),
        .BAUD_RATE(9600)
    ) btn2uart (
        .clk(clk),
        .start(tx_start),
        .din({tx_data1, tx_data0}),
        .tx(uart_tx_out)
    );
endmodule
