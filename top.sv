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
    input sys_clk, //Target FPGA has 200MHz clock
    input reset,
    output logic data_out,
    output logic error,
    output logic packet_done
    );
    wire data_valid;

    send_data data_tx (sys_clk, reset, data_out, data_valid);
    error_rx dut (sys_clk, reset, data_out, data_valid, packet_done, error);
    
endmodule
