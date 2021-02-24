`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/24/2021 02:39:56 PM
// Design Name: 
// Module Name: MEMORY_TB
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


module MEMORY_TB();
    reg clk;
    reg write_en;
    reg [15:0] input_addr;
    reg [15:0] input_data;
    wire [15:0] output_data;

    MEMORY m0(
        clk,
        write_en,
        input_addr,
        input_data,
        output_data
    );

    always #5 clk = ~clk;

    initial begin
        // initial config
        #0 clk = 1'b0;

        // write to a memory location and read from it
        #10 input_addr = 16'b00101;
            input_data = 16'hFFFF;
            write_en = 1'b1;
        #10 write_en = 1'b0;
            
        #10 $finish;
    end
endmodule
