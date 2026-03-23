`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/02/2026 06:47:17 PM
// Design Name: 
// Module Name: top
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


module top(
    //input clk,
    input sys_clk_p, //Target FPGA has 200MHz clock
    input sys_clk_n,
    input reset,
    output logic data_out,
    output logic error,
    output logic packet_done
    );
    wire data_valid;
    
    wire clk, locked;
    
    clk_wiz_0 pll_inst (
    .clk_out1(clk),
    .reset(reset),
    .locked(locked),
    .clk_in1_p(sys_clk_p),
    .clk_in1_n(sys_clk_n)
    );
    send_data data_tx (clk, reset, data_out, data_valid);
    error_rx dut (clk, reset, data_out, data_valid, packet_done, error);
    
endmodule
