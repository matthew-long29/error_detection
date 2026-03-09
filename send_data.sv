`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/27/2026 02:23:14 PM
// Design Name: 
// Module Name: send_data
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


 module send_data#(parameter bram_depth = 360)(
    input clk_data,
    input reset,
    output logic data_out,
    output logic data_valid
    );
    
    //Load the packets into BRAM, note only including 1 byte per line due to bram width constraints
    //BRAM max size: 3,780 Kb, load in 30 packets BRAM (8 bits by 360 bits) initialized at 2880 Kb
    (* ram_style = "block" *) logic [7:0] packets_array [0:bram_depth - 1];
    initial begin
        $readmemh("packets.mem", packets_array);
    end
    
    //Tracking position in bram
    logic [9:0] byte_counter;
    logic [2:0] bit_counter;
    
    
    always_ff @(posedge clk_data) begin
        if (reset) begin
           bit_counter <= 7;
           byte_counter <= 0;
           data_out <= 0;
           data_valid <= 0;
        end else begin
            data_out <= packets_array[byte_counter][bit_counter];
            data_valid <= 1;
            if (bit_counter == 0) begin
                bit_counter <= 7;
                if(byte_counter == bram_depth - 1) begin
                    byte_counter <= 0;
                end else begin
                    byte_counter <= byte_counter + 1;
                end
            end else begin
                bit_counter <= bit_counter - 1;
            end
            
            
            
            
        end
        
    end
    
    
    
endmodule
