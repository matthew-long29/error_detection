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

    parameter num_packets = 100000;
    logic CLK_DATA; //10MHz
    logic reset;
    logic data_in;
    logic data_valid;
    wire packet_done;
    wire error;

    error_rx dut (CLK_DATA, reset, data_in, data_valid, packet_done, error);
    initial CLK_DATA = 0;
    always #0.050 CLK_DATA = ~CLK_DATA;
    
    
    
    logic [95:0] packets [0:num_packets - 1];
    logic expected_error [0:num_packets - 1];
    logic expected_current;
    initial begin
        $readmemh("packets.data", packets);
        $readmemb("expected_results.data", expected_error);
    end
    
    initial begin
        reset = 1;
        data_valid = 0;
        

        repeat(4) @(posedge CLK_DATA);
        
        reset <= 0;
        
        for (int pkt = 0; pkt < num_packets; pkt++) begin


            for (int i = 95; i >= 0; i--) begin
                @(posedge CLK_DATA);
                expected_current <= expected_error[pkt];
                data_valid <= 1;
                data_in <= packets[pkt][i];
            end

        @(posedge packet_done);
        
        end
        
        $finish;
    end
    
    //SVA Check
  
    integer pass_count = 0;
    integer total_incorrect = 0;
    integer false_error = 0;
    integer missed_error = 0;
   
    
    property check_crc;
        @(posedge CLK_DATA)
        packet_done |-> (error == expected_current);
    endproperty
    
    error_test: assert property (check_crc)
    begin
        pass_count++; 
    end else begin
        total_incorrect++;
        if (expected_current == 0 && error == 1)
            false_error++;
        else if (expected_current == 1 && error == 0)
            missed_error++;
    end
 
    
    
    final begin
        $display("Packets Correct : %0d", pass_count);
        $display("Total incorrect : %0d", false_error);
        $display("False Detect : %0d", false_error);
        $display("Missed error: %0d", missed_error);
    end
endmodule