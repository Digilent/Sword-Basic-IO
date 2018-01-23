set_property -dict {PACKAGE_PIN AD12 IOSTANDARD LVDS} [get_ports clk_p]
set_property -dict {PACKAGE_PIN AD11 IOSTANDARD LVDS} [get_ports clk_n]
create_clock -period 5.000 -name sys_clk_pin -waveform {0.000 2.500} -add [get_ports clk_p]

set_property -dict { PACKAGE_PIN Y13   IOSTANDARD LVCMOS15 } [get_ports { btnurst }]; #IO_0_VRN_33 Sch=user_rst

set_property -dict {PACKAGE_PIN A11 IOSTANDARD LVCMOS33} [get_ports ss_clk]
set_property -dict {PACKAGE_PIN E11 IOSTANDARD LVCMOS33} [get_ports ss_sdo]
set_property -dict {PACKAGE_PIN A12 IOSTANDARD LVCMOS33} [get_ports ss_en]

set_property -dict {PACKAGE_PIN J16 IOSTANDARD LVCMOS33} [get_ports {led[0]}]
set_property -dict {PACKAGE_PIN H16 IOSTANDARD LVCMOS33} [get_ports {led[1]}]
set_property -dict {PACKAGE_PIN H11 IOSTANDARD LVCMOS33} [get_ports {led[2]}]
set_property -dict {PACKAGE_PIN H12 IOSTANDARD LVCMOS33} [get_ports {led[3]}]
set_property -dict {PACKAGE_PIN H14 IOSTANDARD LVCMOS33} [get_ports {led[4]}]
set_property -dict {PACKAGE_PIN G14 IOSTANDARD LVCMOS33} [get_ports {led[5]}]
set_property -dict {PACKAGE_PIN G13 IOSTANDARD LVCMOS33} [get_ports {led[6]}]
set_property -dict {PACKAGE_PIN F13 IOSTANDARD LVCMOS33} [get_ports {led[7]}]
set_property -dict {PACKAGE_PIN F12 IOSTANDARD LVCMOS33} [get_ports {led[8]}]
set_property -dict {PACKAGE_PIN E13 IOSTANDARD LVCMOS33} [get_ports {led[9]}]
set_property -dict {PACKAGE_PIN C12 IOSTANDARD LVCMOS33} [get_ports {led[10]}]
set_property -dict {PACKAGE_PIN B12 IOSTANDARD LVCMOS33} [get_ports {led[11]}]
set_property -dict {PACKAGE_PIN F11 IOSTANDARD LVCMOS33} [get_ports {led[12]}]
set_property -dict {PACKAGE_PIN AB27 IOSTANDARD LVCMOS33} [get_ports {led[13]}]
set_property -dict {PACKAGE_PIN AC27 IOSTANDARD LVCMOS33} [get_ports {led[14]}]
set_property -dict {PACKAGE_PIN G30 IOSTANDARD LVCMOS33} [get_ports {led[15]}]

set_property -dict {PACKAGE_PIN F15 IOSTANDARD LVCMOS33} [get_ports led16_b]
set_property -dict {PACKAGE_PIN E14 IOSTANDARD LVCMOS33} [get_ports led16_g]
set_property -dict {PACKAGE_PIN E16 IOSTANDARD LVCMOS33} [get_ports led16_r]
set_property -dict {PACKAGE_PIN E15 IOSTANDARD LVCMOS33} [get_ports led17_b]
set_property -dict {PACKAGE_PIN C14 IOSTANDARD LVCMOS33} [get_ports led17_g]
set_property -dict {PACKAGE_PIN D14 IOSTANDARD LVCMOS33} [get_ports led17_r]

set_property -dict {PACKAGE_PIN AG19 IOSTANDARD LVCMOS18} [get_ports {sw[0]}]
set_property -dict {PACKAGE_PIN AH19 IOSTANDARD LVCMOS18} [get_ports {sw[1]}]
set_property -dict {PACKAGE_PIN AH17 IOSTANDARD LVCMOS18} [get_ports {sw[2]}]
set_property -dict {PACKAGE_PIN AF16 IOSTANDARD LVCMOS18} [get_ports {sw[3]}]
set_property -dict {PACKAGE_PIN AH16 IOSTANDARD LVCMOS18} [get_ports {sw[4]}]
set_property -dict {PACKAGE_PIN AE16 IOSTANDARD LVCMOS18} [get_ports {sw[5]}]
set_property -dict {PACKAGE_PIN AJ19 IOSTANDARD LVCMOS18} [get_ports {sw[6]}]
set_property -dict {PACKAGE_PIN AK19 IOSTANDARD LVCMOS18} [get_ports {sw[7]}]
set_property -dict {PACKAGE_PIN AJ17 IOSTANDARD LVCMOS18} [get_ports {sw[8]}]
set_property -dict {PACKAGE_PIN AJ16 IOSTANDARD LVCMOS18} [get_ports {sw[9]}]
set_property -dict {PACKAGE_PIN AK16 IOSTANDARD LVCMOS18} [get_ports {sw[10]}]
set_property -dict {PACKAGE_PIN AK15 IOSTANDARD LVCMOS18} [get_ports {sw[11]}]
set_property -dict {PACKAGE_PIN AG15 IOSTANDARD LVCMOS18} [get_ports {sw[12]}]
set_property -dict {PACKAGE_PIN AH15 IOSTANDARD LVCMOS18} [get_ports {sw[13]}]
set_property -dict {PACKAGE_PIN AG14 IOSTANDARD LVCMOS18} [get_ports {sw[14]}]
set_property -dict {PACKAGE_PIN AF15 IOSTANDARD LVCMOS18} [get_ports {sw[15]}]

set_property -dict {PACKAGE_PIN AK14 IOSTANDARD SSTL15} [get_ports {kypd_row[0]}]
set_property -dict {PACKAGE_PIN AK13 IOSTANDARD SSTL15} [get_ports {kypd_row[1]}]
set_property -dict {PACKAGE_PIN AJ12 IOSTANDARD SSTL15} [get_ports {kypd_row[2]}]
set_property -dict {PACKAGE_PIN AF12 IOSTANDARD SSTL15} [get_ports {kypd_row[3]}]
set_property -dict {PACKAGE_PIN AH10 IOSTANDARD SSTL15} [get_ports {kypd_row[4]}]
set_property -dict {PACKAGE_PIN AE13 IOSTANDARD SSTL15} [get_ports {kypd_col[0]}]
set_property -dict {PACKAGE_PIN AJ14 IOSTANDARD SSTL15} [get_ports {kypd_col[1]}]
set_property -dict {PACKAGE_PIN AJ13 IOSTANDARD SSTL15} [get_ports {kypd_col[2]}]
set_property -dict {PACKAGE_PIN AH14 IOSTANDARD SSTL15} [get_ports {kypd_col[3]}]
set_property -dict {PACKAGE_PIN AG12 IOSTANDARD SSTL15} [get_ports {kypd_col[4]}]

set_property -dict {PACKAGE_PIN F30 IOSTANDARD LVCMOS33} [get_ports uart_tx_out]

# VGA
set_property -dict {PACKAGE_PIN AA23 IOSTANDARD LVCMOS33} [get_ports {vga_b[3]}]
set_property -dict {PACKAGE_PIN AC24 IOSTANDARD LVCMOS33} [get_ports {vga_b[4]}]
set_property -dict {PACKAGE_PIN AD24 IOSTANDARD LVCMOS33} [get_ports {vga_b[5]}]
set_property -dict {PACKAGE_PIN AB23 IOSTANDARD LVCMOS33} [get_ports {vga_b[6]}]
set_property -dict {PACKAGE_PIN AB22 IOSTANDARD LVCMOS33} [get_ports {vga_b[7]}]
set_property -dict {PACKAGE_PIN AA22 IOSTANDARD LVCMOS33} [get_ports {vga_g[2]}]
set_property -dict {PACKAGE_PIN AC21 IOSTANDARD LVCMOS33} [get_ports {vga_g[3]}]
set_property -dict {PACKAGE_PIN Y21 IOSTANDARD LVCMOS33} [get_ports {vga_g[4]}]
set_property -dict {PACKAGE_PIN AC20 IOSTANDARD LVCMOS33} [get_ports {vga_g[5]}]
set_property -dict {PACKAGE_PIN AB20 IOSTANDARD LVCMOS33} [get_ports {vga_g[6]}]
set_property -dict {PACKAGE_PIN AA20 IOSTANDARD LVCMOS33} [get_ports {vga_g[7]}]
set_property -dict {PACKAGE_PIN AD21 IOSTANDARD LVCMOS33} [get_ports vga_hs]
set_property -dict {PACKAGE_PIN AC25 IOSTANDARD LVCMOS33} [get_ports {vga_r[3]}]
set_property -dict {PACKAGE_PIN AB24 IOSTANDARD LVCMOS33} [get_ports {vga_r[4]}]
set_property -dict {PACKAGE_PIN Y24 IOSTANDARD LVCMOS33} [get_ports {vga_r[5]}]
set_property -dict {PACKAGE_PIN Y23 IOSTANDARD LVCMOS33} [get_ports {vga_r[6]}]
set_property -dict {PACKAGE_PIN AD22 IOSTANDARD LVCMOS33} [get_ports {vga_r[7]}]
#set_property -dict { PACKAGE_PIN AC22  IOSTANDARD LVCMOS33 } [get_ports { vga_scl }]; #IO_L8P_T1_12 Sch=vga_scl
#set_property -dict { PACKAGE_PIN AA21  IOSTANDARD LVCMOS33 } [get_ports { vga_sda }]; #IO_L2N_T0_12 Sch=vga_sda
set_property -dict {PACKAGE_PIN AE23 IOSTANDARD LVCMOS33} [get_ports vga_vs]

# PS/2 Connections
#set_property -dict { PACKAGE_PIN AF23  IOSTANDARD LVCMOS33 } [get_ports { ps2_clk[0] }]; #IO_L11N_T1_SRCC_12 Sch=ps2_clk[0]
set_property -dict { PACKAGE_PIN AE24  IOSTANDARD LVCMOS33 } [get_ports { ps2_clk }]; #IO_L12N_T1_MRCC_12 Sch=ps2_clk[1]
#set_property -dict { PACKAGE_PIN AD23  IOSTANDARD LVCMOS33 } [get_ports { ps2_data[0] }]; #IO_L12P_T1_MRCC_12 Sch=ps2_data[0]
set_property -dict { PACKAGE_PIN AF22  IOSTANDARD LVCMOS33 } [get_ports { ps2_data }]; #IO_L13P_T2_MRCC_12 Sch=ps2_data[1]