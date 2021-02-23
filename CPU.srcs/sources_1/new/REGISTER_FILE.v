`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/23/2021 02:15:33 PM
// Design Name: 
// Module Name: REGISTER_FILE
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


module REGISTER_FILE(
    input clk,
    input en,
    input reg_write,
    input [2:0] reg_sel_1, reg_sel_2, write_reg_sel,
    input [15:0] write_data,
    output reg [15:0] reg_data_1, reg_data_2
);

    integer i;
    reg [15:0] registers [0:7];

    initial begin
        for (i = 0; i < 8; i = i + 1) begin
            registers[i] = 0;
        end
    end

    always @(posedge clk) begin
        if (en) begin
            reg_data_1 <= registers[reg_sel_1];
            reg_data_2 <= registers[reg_sel_2];
            if (reg_write)
                registers[write_reg_sel] <= write_data;
        end
    end

endmodule
