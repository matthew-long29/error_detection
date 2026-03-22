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
    parameter num_packets = 30;
   
    logic clk;
    logic reset;
    wire data_out;
    wire error;
    wire packet_done;
    
    
    logic expected_error [0:num_packets - 1];
    logic expected_current;
    integer counter;
    initial begin
        $readmemb("expected_results.mem", expected_error);
    end
    
    top top (clk, reset, data_out, error, packet_done);
    initial clk = 0;
    always #0.5 clk = ~clk;
    initial begin
        reset = 1;
        #10
        reset = 0;
        for (counter = 0; counter < num_packets; counter++) begin
        @(posedge packet_done);
            expected_current = expected_error[counter];
        end

        $finish;
    end
    
    //SVA Check
  
    integer pass_count = 0;
    integer total_incorrect = 0;
    
    property check_crc;
        @(posedge clk)
        packet_done |-> (error == expected_current);
        
        
    endproperty
    
    error_test: assert property (check_crc)
    begin
        pass_count++; 
    end else begin
        total_incorrect++;
       
    end
 
    
    
    final begin
        $display("Packets Correct : %0d", pass_count);
        $display("Total incorrect : %0d", total_incorrect);
    end
    
endmodule
