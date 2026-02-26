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
    //FSM
    typedef enum {CALC_CRC, READ_CRC} state;
    state current_state, next_state;
    
    //Bit tracking
    logic [6:0] bit_counter;
    
    //Crc data
    logic [15:0] crc_next;
    logic [15:0] crc_val;
    logic [15:0] rx_crc;
     
    //shift serial data into shift register, sequential data processing
    always_ff @(posedge clk_data) begin
        if (reset) begin
            bit_counter <= 7'd0;
            crc_val <= init;
            rx_crc <= 16'd0;
        end else begin
            if (data_valid) begin
                crc_val <= init; 
                bit_counter <= 7'd0;
            end else begin
                crc_val <= crc_next;
                bit_counter <= bit_counter + 1; 
                
                if (bit_counter == 7'd63) begin
                    bit_counter <= 7'd0;
                    crc_val <= init;
                end
                
                rx_crc <= {rx_crc[14:0], data_in};
            end  
        end
    end
    
    //Contains combinational logic
    always_comb begin
        //default values
        next_state = current_state;
        packet_done = 0;
        error = 0;
        crc_next = crc_val;
        
        if (!reset) begin
            case (current_state)
                CALC_CRC: begin
                //CRC Calculation algorithm
                    if (crc_val[15] ^ data_in) begin
                        crc_next = {crc_val[14:0], 1'b0} ^ crc_polynomial;
                    end else begin
                        crc_next = {crc_val[14:0], 1'b0};
                    end
                    //Next state
                    if (bit_counter == 7'd47) begin
                        next_state = READ_CRC;
                    end
                    
                end
                
                READ_CRC: begin
                    //Complete comparison once packet is finished
                    if (bit_counter == 7'd63) begin
                        error = crc_val != rx_crc;
                        packet_done = 1;
                        next_state = CALC_CRC;
                        crc_next = 16'd0;
                    end else begin
                        error = 0;
                        packet_done = 0;
                    end
                    
                end
            endcase
        end
    end
    
    //Sequential logic (switching between states)
    always_ff @(posedge clk_data) begin
        if (reset) begin
            current_state <= CALC_CRC;
        end else begin
            current_state <= next_state;
        end 
    end
    
   
endmodule
