`timescale 1us / 1ns
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/15/2026 08:34:49 PM
// Design Name: 
// Module Name: tb_error_detection
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


module tb_error_detection;
    logic CLK_DATA;
    logic reset;
    logic data_in;
    logic data_valid;
    wire packet_done;
    wire error;
    logic first_bit;
    logic [63:0] data;
    error_rx #(16'h1021, 16'h0000) dut (.clk_data(CLK_DATA), .reset(reset), .data_in(data_in), .data_valid(data_valid), .packet_done(packet_done), .error(error));
    
    initial CLK_DATA = 0;
    always #500 CLK_DATA = ~CLK_DATA;
    initial begin
        reset = 1;
        first_bit = 0;
        #1500
        reset = 0;
        
        data = 64'hA3F72C8B4E6196D9; //correct code sent (crc last 2 bytes calculated using online calculator)
        
        for (int i = 63; i >= 0; i--) begin
            @(posedge CLK_DATA);
                data_in = data[i];
                if (!first_bit) begin
                    data_valid = 1; //makes data_valid only pulse for first clock cycle showing start of data transmission
                    first_bit = 1;
                end else
                    data_valid = 0;
        end
        
        //inject two errors into first 6 bytes (a 4 goes to 6 and a 1 goes to 0, total 2 bit errors)
        data = 64'hA3F72C8B6E6096D9;
        for (int i = 63; i >= 0; i--) begin
            @(posedge CLK_DATA);
                data_in = data[i];
               
        end
        
                
       end
endmodule
