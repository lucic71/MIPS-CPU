`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/27/2021 12:18:17 PM
// Design Name: 
// Module Name: RIGHT_SHIFTER
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


module RIGHT_SHIFTER(
    input [15:0] init_reg,
    input [3:0] shift,
    output reg [15:0] shifted_reg
);

    always @(init_reg or shift) begin
        case (shift)
            4'b0000: shifted_reg <= init_reg;
            4'b0001: shifted_reg <= init_reg >> 1;
            4'b0010: shifted_reg <= init_reg >> 2;
            4'b0011: shifted_reg <= init_reg >> 3;
            4'b0100: shifted_reg <= init_reg >> 4;
            4'b0101: shifted_reg <= init_reg >> 5;
            4'b0110: shifted_reg <= init_reg >> 6;
            4'b0111: shifted_reg <= init_reg >> 7;
            4'b1000: shifted_reg <= init_reg >> 8;
            4'b1001: shifted_reg <= init_reg >> 9;
            4'b1010: shifted_reg <= init_reg >> 10;
            4'b1011: shifted_reg <= init_reg >> 11;
            4'b1100: shifted_reg <= init_reg >> 12;
            4'b1101: shifted_reg <= init_reg >> 13;
            4'b1110: shifted_reg <= init_reg >> 14;
            4'b1111: shifted_reg <= init_reg >> 15;
        endcase
    end

endmodule
