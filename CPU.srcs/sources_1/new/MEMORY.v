`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/24/2021 02:24:40 PM
// Design Name: 
// Module Name: MEMORY
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
//  16 bit memory addressed with 5 bits initialized to 0.
//  Read and write operations are both synchronous.
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module MEMORY(
    input clk,
    input write_en,
    input [15:0] input_addr,
    input [15:0] input_data,
    output reg [15:0] output_data
);

    integer i;
    reg [15:0] memory [0:31];
    
    initial begin
        for (i = 0; i < 32; i = i + 1) begin
            memory[i] = 0;
        end
    end

    always @(posedge clk) begin
        if (write_en)
            memory[input_addr[5:0]] <= input_data;
        else
            output_data <= memory[input_addr[5:0]];
    end

endmodule
