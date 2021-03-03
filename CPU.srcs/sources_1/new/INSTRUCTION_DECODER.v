`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/24/2021 11:10:22 AM
// Design Name: 
// Module Name: INSTRUCTION_DECODER
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
//  Output lines are chunks from instr_data as defined by ISA.
//  Even if the operations are not conditioned by anything,
//  they are synchronous (makes testing easier).
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module INSTRUCTION_DECODER(
    input clk,
    input en,
    input [15:0] instr_data,
    output reg [2:0] reg_sel_1,
    output reg [2:0] reg_sel_2,
    output reg [2:0] write_reg_sel,
    output reg [15:0] imm_data,
    output reg reg_write,
    output reg [5:0] alu_op
);

    always @(posedge clk) begin
        if (en) begin
            reg_sel_1 = instr_data[7:5];
            reg_sel_2 = instr_data[4:2];
            write_reg_sel = instr_data[11:9];
            imm_data = {instr_data[7:0], instr_data[7:0]};
            alu_op = {instr_data[15:12], instr_data[8:8]};

            case (instr_data[15:12])
                4'b0111: reg_write = 1'b0;
                4'b1100: reg_write = 1'b0;
                4'b1101: reg_write = 1'b0;
                default: reg_write = 1'b1;
            endcase
        end
    end

endmodule
