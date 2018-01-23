`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Digilent
// Engineer: Arthur Brown
// 
// Create Date: 12/11/2017 01:09:09 PM
// Design Name: 
// Module Name: uart_hex_format
// Project Name: 
// Target Devices: 
// Tool Versions: Vivado 2016.4
// Description: This module implements a pseudo-printf() interface on top of a uart controller. only supports %01x.
// 
// Dependencies: uart.v
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments: Shift operation on FORMAT_STRING is not ideal, but is synthesizable
// 
//////////////////////////////////////////////////////////////////////////////////


module uart_hex_format(clk, start, din, tx);
    parameter CLOCK_FREQUENCY = 200000000;
    parameter BAUD_RATE = 9600;
    localparam FORMAT_SLOTS = 2; // number of values to be taken in from din.
    localparam FORMAT_STR_LEN = 22; // strlen(FORMAT_STRING)
    localparam FORMAT_STR_LEN_LOG2 = 5; // ceil(log2(FORMAT_STR_LEN))
    localparam FORMAT_STRING = "Button R\1C\2 Pressed!\r\n"; // ascii values of <= FORMAT_SLOTS in the string are used to infer "hex conversion of slot # of din
    input wire clk;
    input wire start;
    input wire [4*FORMAT_SLOTS-1:0] din;
    output wire tx;
        
//    reg [7:0] str [FORMAT_STR_LEN-1:0];
//    integer i;
//    initial for (i=0; i<FORMAT_STR_LEN; i=i+1)
//        str[i] = FORMAT_STRING[];
        
    reg tx_start = 0;
    reg [7:0] tx_din;
    wire tx_busy, tx_ready_flag;
    uart_tx #(
        .CLOCK_FREQUENCY(CLOCK_FREQUENCY),
        .BAUD_RATE(BAUD_RATE)
    ) m_uart_tx (
        .clk(clk),
        .start(tx_start),
        .din(tx_din),
        .tx(tx),
        .busy(tx_busy),
        .ready_flag(tx_ready_flag)
    );
    
    localparam S_IDLE = 0, S_TX_BUSY = 1, S_BUSY = 2;
    reg [1:0] state = S_IDLE;
    
//    reg [FORMAT_STR_LEN*8-1:0] str;
    reg [3:0] format [FORMAT_SLOTS-1:0];
    reg [FORMAT_STR_LEN_LOG2+3-1:0] idx = 0;
    
    //when transitioning out of IDLE state, register data in
    genvar i;
    generate for (i=0; i<FORMAT_SLOTS; i=i+1) begin : FORMAT_IDX
    always@(posedge clk)
        if (state == S_IDLE && start == 1)
            format[i] <= din[4*i+3:4*i];
    end endgenerate
    
    //state machine
    always@(posedge clk)
        case (state)
        S_IDLE: begin
            if (start == 1) begin // upon start flag, goto 
                state <= S_TX_BUSY;
                idx <= {FORMAT_STR_LEN-1, 3'b0};
                //set format
            end
        end
        S_TX_BUSY: begin //wait for uart_tx start cycle to complete - perhaps unnecessary with a 1-cycle lookahead in uart_tx 
            if (tx_busy == 0) begin
                //assert tx_start
                state <= S_BUSY;
            end
        end
        S_BUSY: begin // wait for transmit complete
            if (tx_ready_flag == 1) begin
                if (idx == 0) begin
                    state <= S_IDLE;
                end else begin
                    //assert tx_start, decrement character base address
                    idx <= idx - 8;
                end
            end
        end
        default:
            state <= S_IDLE;
        endcase
        
    always@(posedge clk) // start byte transmit when exiting IDLE and when 
        if (state == S_TX_BUSY && tx_busy == 0)
            tx_start <= 1;
        else if (state == S_BUSY && tx_ready_flag == 1 && idx > 0)
            tx_start <= 1;
        else
            tx_start <= 0;

    //choose character from string. if the data is to be taken from the format reg, convert to hex.
    reg [7:0] ch_tmp;
    always@* begin
        ch_tmp = 8'hFF & (FORMAT_STRING >> idx); // this is not great, should probably use a bram.
        if (ch_tmp <= FORMAT_SLOTS)
            tx_din = (format[ch_tmp-1] < 10) ? "0" + format[ch_tmp-1] : "A" + format[ch_tmp-1] - 10; // hex2ascii
        else
            tx_din = 8'hFF & (FORMAT_STRING >> idx);
    end
endmodule
