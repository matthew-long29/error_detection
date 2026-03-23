#Clock (differential pair)
set_property PACKAGE_PIN V4 [get_ports sys_clk_p]
set_property PACKAGE_PIN W4 [get_ports sys_clk_n]
set_property IOSTANDARD LVDS_25 [get_ports {sys_clk_p sys_clk_n}]
set_property DIFF_TERM TRUE [get_ports {sys_clk_p sys_clk_n}]

# Reset
set_property PACKAGE_PIN P6 [get_ports reset]
set_property IOSTANDARD LVCMOS33 [get_ports reset]

# Outputs
set_property PACKAGE_PIN N4 [get_ports data_out]
set_property IOSTANDARD LVCMOS33 [get_ports data_out]

set_property PACKAGE_PIN P2 [get_ports error]
set_property IOSTANDARD LVCMOS33 [get_ports error]

set_property PACKAGE_PIN L5 [get_ports packet_done]
set_property IOSTANDARD LVCMOS33 [get_ports packet_done]

