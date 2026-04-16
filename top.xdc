set_property IOSTANDARD LVDS_25 [get_ports {sys_clkp}]
set_property PACKAGE_PIN W11 [get_ports {sys_clkp}]

set_property IOSTANDARD LVDS_25 [get_ports {sys_clkn}]
set_property PACKAGE_PIN W12 [get_ports {sys_clkn}]

set_property DIFF_TERM FALSE [get_ports {sys_clkp}]

create_clock -name sys_clk -period 5 [get_ports sys_clkp]


#PIN to oscilliscope
set_property PACKAGE_PIN R6 [get_ports {clk_out}]
set_property IOSTANDARD LVCMOS33 [get_ports {clk_out}]

set_property PACKAGE_PIN R3 [get_ports {data_out}]
set_property IOSTANDARD LVCMOS33 [get_ports {data_out}]

set_property PACKAGE_PIN U6 [get_ports {packet_done}]
set_property IOSTANDARD LVCMOS33 [get_ports {packet_done}]

set_property PACKAGE_PIN U2 [get_ports {error}]
set_property IOSTANDARD LVCMOS33 [get_ports {error}]

set_property PACKAGE_PIN W15 [get_ports {exp}]
set_property IOSTANDARD LVCMOS33 [get_ports {exp}]

