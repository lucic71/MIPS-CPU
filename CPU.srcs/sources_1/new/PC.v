`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/08/2021 09:29:55 PM
// Design Name: 
// Module Name: PC
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


module PC(
    input clk,
    input [15:0] new_pc,
    input [2:0] pc_op,
    output [15:0] pc
);

    `include "PC_OP.vh";

    reg [15:0] curr_pc;

    always @(posedge clk) begin
        case (pc_op)
            `PC_OP_INC: curr_pc = curr_pc + 1;
            `PC_OP_ASSIGN: curr_pc = new_pc;
            `PC_OP_RESET: curr_pc = 16'b0;
        endcase
    end

endmodule
