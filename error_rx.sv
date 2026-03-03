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


module error_rx #(parameter[15:0] crc_polynomial,
    parameter[15:0] init
    )(
    input clk_data, //1kHz clock input
    input reset,    //reset active high
    input data_in,  //Serial data input
    input data_valid, //One clock cycle pulse, asserted to indicate the start of data transmission
    output logic packet_done, //Output to show end of packet
    output logic error        //High output indicates an error in the packet
    );
    
    //Bit tracking
    logic [6:0] bit_counter;

    //Crc data
    logic [15:0] crc_comb;
    logic [15:0] crc_reg;
    
     
     
    //Sequential data
    always_ff @(posedge clk_data) begin
        if (reset) begin
            bit_counter <= 7'd0;
            crc_reg <= init;
        end else begin

            if (data_valid) begin
                crc_reg <= crc_comb;
                bit_counter <= bit_counter + 1; 
                
                if (bit_counter == 7'd63) begin
                    bit_counter <= 7'd0;
                    crc_reg <= init;
                end
                
            end  
        end
    end
    
    //Contains combinational logic
    always_comb begin
        //default values
        packet_done = 0;
        error = 0;
        crc_comb = crc_reg;
        
        if (!reset) begin
                //CRC Calculation algorithm
                if (crc_reg[15] ^ data_in) begin
                    crc_comb = {crc_reg[14:0], 1'b0} ^ crc_polynomial;
                end else begin
                    crc_comb = {crc_reg[14:0], 1'b0};
                end
                    
                if (bit_counter == 7'd63) begin
                    packet_done = 1;
                    error = (crc_comb != 16'h0000);
                end
        end
    end
    
    
   
endmodule
