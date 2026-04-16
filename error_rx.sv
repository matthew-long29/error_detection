`timescale 1us / 1ns
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/12/2026 12:06:01 AM
// Design Name: 
// Module Name: error_rx
// Project Name: BIOSYNC Rx Error Detection
// Target Devices: OpalKelly XEM7310
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


module error_rx #(parameter[15:0] crc_polynomial = 16'h1021, //commonly used polynomial for wireless coms
    parameter[15:0] init = 16'hFFFF,                         // set initialy crc value
    parameter[7:0] packet_length = 96                        //bits in a packet (12 bytes = 12 * 8 = 96 bits)
    )(
    input clk_data, //1kHz clock input
    input reset,    //reset active high
    input data_in,  //Serial data input
    input enable, //Continuous signal asserted when data is actively being sent
    output logic packet_done, //Output to show end of packet
    output logic error        //High output indicates an error in the packet
    );
    
    //Bit tracking
    logic [6:0] bit_counter;

    //CRC data, used to transfer between sequential and combinational block
    logic [15:0] crc_comb;
    logic [15:0] crc_reg;
    
     
    //Sequential block, update registers
    always_ff @(posedge clk_data) begin
        if (reset) begin
            bit_counter <= 7'd0;
            crc_reg <= init;
        end else begin

            if (enable) begin
                crc_reg <= crc_comb;
                bit_counter <= bit_counter + 1; 
                
                if (bit_counter == packet_length - 1) begin
                    bit_counter <= 7'd0;
                    crc_reg <= init;
                end
                
            end  
        end
    end
    
    //Combinational logic
    always_comb begin
        //default values
        packet_done = 0;
        error = 0;
        crc_comb = crc_reg;
        
        if (enable) begin
                //CRC Calculation algorithm
                if (crc_reg[15] ^ data_in) begin
                    crc_comb = {crc_reg[14:0], 1'b0} ^ crc_polynomial;
                end else begin
                    crc_comb = {crc_reg[14:0], 1'b0};
                end
                    
                if (bit_counter == packet_length - 1) begin
                    packet_done = 1;
                    error = (crc_comb != 16'h0000);
                end
        end
        
    end
    
    
   
endmodule
