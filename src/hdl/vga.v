`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Digilent
// Engineer: Sam Bobrowicz, Arthur Brown
// 
// Create Date: 12/08/2017 12:55:20 PM
// Design Name: 
// Module Name: vga
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: implements a VGA demomstration at a resolution chosen via localparameters and the pxl_clk frequency.
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments: adapted from SB's vga vhdl source (Arty-Pmod-VGA)
// 
//////////////////////////////////////////////////////////////////////////////////


module vga(pxl_clk, vga_hs_o, vga_vs_o, vga_r, vga_g, vga_b);
    parameter VGA_R_BITS = 5;
    parameter VGA_G_BITS = 6;
    parameter VGA_B_BITS = 5;
    input wire pxl_clk;
    output wire vga_hs_o;
    output wire vga_vs_o;
    output wire [VGA_R_BITS-1:0] vga_r;
    output wire [VGA_G_BITS-1:0] vga_g;
    output wire [VGA_B_BITS-1:0] vga_b;
    
    
//    //***640x480@60Hz*** - Requires 25 MHz clock
//    localparam FRAME_WIDTH = 640;
//    localparam FRAME_HEIGHT = 480;
//    localparam H_FP = 16; // H front porch width (pixels)
//    localparam H_PW = 96; // H sync pulse width (pixels)
//    localparam H_MAX = 800; // H total period (pixels)
//    localparam V_FP = 10; // V front porch width (lines)
//    localparam V_PW = 2; // V sync pulse width (lines)
//    localparam V_MAX = 525; // V total period (lines)
//    localparam H_POL = 1'b0;
//    localparam V_POL = 1'b0;
    
//    //***800x600@60Hz*** - Requires 40 MHz clock
//    localparam FRAME_WIDTH = 800;
//    localparam FRAME_HEIGHT = 600;
//    localparam H_FP = 40; // H front porch width (pixels)
//    localparam H_PW = 128; // H sync pulse width (pixels)
//    localparam H_MAX = 1056; // H total period (pixels)
//    localparam V_FP = 1; // V front porch width (lines)
//    localparam V_PW = 4; // V sync pulse width (lines)
//    localparam V_MAX = 628; // V total period (lines)
//    localparam H_POL = 1'b1;
//    localparam V_POL = 1'b1;
    
//    //***1280x720@60Hz*** - Requires 74.25 MHz clock
//    localparam FRAME_WIDTH = 1280;
//    localparam FRAME_HEIGHT = 720;
//    localparam H_FP = 110; // H front porch width (pixels)
//    localparam H_PW = 40; // H sync pulse width (pixels)
//    localparam H_MAX = 1650; // H total period (pixels)
//    localparam V_FP = 5; // V front porch width (lines)
//    localparam V_PW = 5; // V sync pulse width (lines)
//    localparam V_MAX = 750; // V total period (lines)
//    localparam H_POL = 1'b1;
//    localparam V_POL = 1'b1;
    
    //***1280x1024@60Hz*** - Requires 108 MHz clock
    localparam FRAME_WIDTH = 1280;
    localparam FRAME_HEIGHT = 1024;
    localparam H_FP = 48; // H front porch width (pixels)
    localparam H_PW = 112; // H sync pulse width (pixels)
    localparam H_MAX = 1688; // H total period (pixels)
    localparam V_FP = 1; // V front porch width (lines)
    localparam V_PW = 3; // V sync pulse width (lines)
    localparam V_MAX = 1066; // V total period (lines)
    localparam H_POL = 1'b1;
    localparam V_POL = 1'b1;
    
//    //***1920x1080@60Hz*** - Requires 148.5 MHz pxl_clk
//    localparam FRAME_WIDTH = 1920;
//    localparam FRAME_HEIGHT = 1080;
//    localparam H_FP = 88; // H front porch width (pixels)
//    localparam H_PW = 44; // H sync pulse width (pixels)
//    localparam H_MAX = 2200; // H total period (pixels)
//    localparam V_FP = 4; // V front porch width (lines)
//    localparam V_PW = 5; // V sync pulse width (lines)
//    localparam V_MAX = 1125; // V total period (lines)
//    localparam H_POL = 1'b1;
//    localparam V_POL = 1'b1;
    
    //Moving Box constants
    localparam BOX_WIDTH = 8;
    localparam BOX_CLK_DIV = 1000000; // MAX=(2^25 - 1)
    localparam BOX_X_MAX = (512 - BOX_WIDTH);
    localparam BOX_Y_MAX = (FRAME_HEIGHT - BOX_WIDTH);
    localparam BOX_X_MIN = 0;
    localparam BOX_Y_MIN = 256;
    localparam BOX_X_INIT = 12'h000;
    localparam BOX_Y_INIT = 12'h190; // 400
    
    wire active;
    reg [11:0] h_cntr_reg = 0;
    reg [11:0] v_cntr_reg = 0;
    reg h_sync_reg = ~H_POL;
    reg v_sync_reg = ~V_POL;
    reg h_sync_dly_reg = ~H_POL;
    reg v_sync_dly_reg = ~V_POL;
    reg [VGA_R_BITS-1:0] vga_red_reg = 0;
    reg [VGA_G_BITS-1:0] vga_grn_reg = 0;
    reg [VGA_B_BITS-1:0] vga_blu_reg = 0;
    reg [VGA_R_BITS-1:0] vga_red;
    reg [VGA_G_BITS-1:0] vga_grn;
    reg [VGA_B_BITS-1:0] vga_blu;
    reg [11:0] box_x_reg = BOX_X_INIT;
    reg box_x_dir = 1;
    reg [11:0] box_y_reg = BOX_Y_INIT;
    reg box_y_dir = 1;
    reg [24:0] box_cntr_reg = 0;
    wire update_box;
    wire pixel_in_box;
    
    always@*
        if (active == 0)
            vga_red = {VGA_R_BITS{1'b0}};
        else if (h_cntr_reg < 512 && v_cntr_reg < 256 && h_cntr_reg[8] == 1)
            vga_red = h_cntr_reg[5:6-VGA_R_BITS];//h_cntr_reg[5:2];
        else if (h_cntr_reg < 512 && v_cntr_reg >= 256 && pixel_in_box != 1)
            vga_red = {VGA_R_BITS{1'b1}};
        else if (h_cntr_reg >= 512 && v_cntr_reg[8] == 1 && h_cntr_reg[3] == 1)
            vga_red = {VGA_R_BITS{1'b1}};
        else if (h_cntr_reg >= 512 && v_cntr_reg[8] == 0 && v_cntr_reg[3] == 1)
            vga_red = {VGA_R_BITS{1'b1}};
        else
            vga_red = {VGA_R_BITS{1'b0}};
    
    always@*
        if (active == 0)
            vga_grn = {VGA_G_BITS{1'b0}};
        else if (h_cntr_reg < 512 && v_cntr_reg < 256 && h_cntr_reg[7] == 1)
            vga_grn = h_cntr_reg[5:6-VGA_G_BITS];//h_cntr_reg[5:2];
        else if (h_cntr_reg < 512 && v_cntr_reg >= 256 && pixel_in_box != 1)
            vga_grn = {VGA_G_BITS{1'b1}};
        else if (h_cntr_reg >= 512 && v_cntr_reg[8] == 1 && h_cntr_reg[3] == 1)
            vga_grn = {VGA_G_BITS{1'b1}};
        else if (h_cntr_reg >= 512 && v_cntr_reg[8] == 0 && v_cntr_reg[3] == 1)
            vga_grn = {VGA_G_BITS{1'b1}};
        else
            vga_grn = {VGA_G_BITS{1'b0}};

    always@*
        if (active == 0)
            vga_blu = {VGA_B_BITS{1'b0}};
        else if (h_cntr_reg < 512 && v_cntr_reg < 256 && h_cntr_reg[6] == 1)
            vga_blu = h_cntr_reg[5:6-VGA_B_BITS];//h_cntr_reg[5:2];
        else if (h_cntr_reg < 512 && v_cntr_reg >= 256 && pixel_in_box != 1)
            vga_blu = {VGA_B_BITS{1'b1}};
        else if (h_cntr_reg >= 512 && v_cntr_reg[8] == 1 && h_cntr_reg[3] == 1)
            vga_blu = {VGA_B_BITS{1'b1}};
        else if (h_cntr_reg >= 512 && v_cntr_reg[8] == 0 && v_cntr_reg[3] == 1)
            vga_blu = {VGA_B_BITS{1'b1}};
        else
            vga_blu = {VGA_B_BITS{1'b0}};
            
    // MOVING BOX LOGIC
            
    always@(posedge pxl_clk)
        if (update_box == 1) begin
            if ((box_x_dir == 1 && box_x_reg == BOX_X_MAX - 1) || (box_x_dir == 0 && box_x_reg == BOX_X_MIN + 1))
                box_x_dir <= ~box_x_dir;
            if ((box_y_dir == 1 && box_y_reg == BOX_Y_MAX - 1) || (box_y_dir == 0 && box_y_reg == BOX_Y_MIN + 1))
                box_y_dir <= ~box_y_dir;
            
            if (box_x_dir == 1)
                box_x_reg <= box_x_reg + 1;
            else
                box_x_reg <= box_x_reg - 1;
            if (box_y_dir == 1)
                box_y_reg <= box_y_reg + 1;
            else
                box_y_reg <= box_y_reg - 1;
        end
        
    always@(posedge pxl_clk)
        if (box_cntr_reg == BOX_CLK_DIV - 1)
            box_cntr_reg <= 'b0;
        else
            box_cntr_reg <= box_cntr_reg + 1;
    
    assign update_box = (box_cntr_reg == BOX_CLK_DIV - 1) ? 1 : 0;
    assign pixel_in_box = ((h_cntr_reg >= box_x_reg) && (h_cntr_reg < box_x_reg + BOX_WIDTH) &&
                           (v_cntr_reg >= box_y_reg) && (v_cntr_reg < box_y_reg + BOX_WIDTH)) ? 1 : 0;
    
    //SYNC GENERATION
    
    always@(posedge pxl_clk)
        if (h_cntr_reg == H_MAX - 1) begin
            h_cntr_reg <= 0;
            if (v_cntr_reg == V_MAX - 1)
                v_cntr_reg <= 0;
            else
                v_cntr_reg <= v_cntr_reg + 1;
        end else
            h_cntr_reg <= h_cntr_reg + 1;
    
    
    always@(posedge pxl_clk)
        if (h_cntr_reg >= H_FP + FRAME_WIDTH - 1 && h_cntr_reg < H_FP + FRAME_WIDTH + H_PW - 1)
            h_sync_reg <= H_POL;
        else
            h_sync_reg <= ~H_POL;

    always@(posedge pxl_clk)
        if (v_cntr_reg >= V_FP + FRAME_HEIGHT - 1 && v_cntr_reg < V_FP + FRAME_HEIGHT + V_PW - 1)
            v_sync_reg <= V_POL;
        else
            v_sync_reg <= ~V_POL;
            
    assign active = (h_cntr_reg < FRAME_WIDTH && v_cntr_reg < FRAME_HEIGHT) ? 1 : 0;
    
    always@(posedge pxl_clk) begin
        v_sync_dly_reg <= v_sync_reg;
        h_sync_dly_reg <= h_sync_reg;
        vga_red_reg <= vga_red;
        vga_grn_reg <= vga_grn;
        vga_blu_reg <= vga_blu;
    end
    
    assign vga_hs_o = h_sync_dly_reg;
    assign vga_vs_o = v_sync_dly_reg;
    assign vga_r = vga_red_reg;
    assign vga_g = vga_grn_reg;
    assign vga_b = vga_blu_reg;
endmodule
