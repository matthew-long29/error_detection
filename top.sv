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
    input sys_clkp, //Target FPGA has 200MHz clock
    input sys_clkn,
    output logic clk_out,
    output logic data_out,
    output logic error,
    output logic packet_done,
    output logic exp
    );
    wire data_valid;   
    wire sys_clk; 
    IBUFGDS osc_clk(.O(sys_clk), .I(sys_clkp), .IB(sys_clkn));
    
    
    logic [15:0] reset_cnt = 0;
    logic reset = 1;    
    always @(posedge sys_clk) begin
        if (reset_cnt != 16'hFFFF) begin
            reset_cnt <= reset_cnt + 1;
            reset <= 1;
        end else begin
            reset <= 0;
        end        
    end
    
    
    
    
    send_data data_tx (sys_clk, reset, data_out, data_valid);
    error_rx dut (sys_clk, reset, data_out, data_valid, packet_done, error);
    assign clk_out = sys_clk;
    

endmodule
