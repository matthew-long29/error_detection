`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/09/2026 10:10:21 AM
// Design Name: 
// Module Name: tb_top
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


module tb_top;
    logic clk;
    logic reset;
    wire data_out;
    wire error;
    wire packet_done;
    
    top top (clk, reset, data_out, error, packet_done);
    initial clk = 0;
    always #0.5 clk = ~clk;
    initial begin
        reset = 1;
        #10
        reset = 0;
    end
    
endmodule
