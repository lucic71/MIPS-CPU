`timescale 1ns / 1ps
`include "OPCODES.vh"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/24/2021 05:20:08 PM
// Design Name: 
// Module Name: ALU
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


module ALU(
    input clk,
    input en,
    input [15:0] reg_1,
    input [15:0] reg_2,
    input [4:0] alu_op,
    input [15:0] pc,
    input [15:0] imm,
    output reg [15:0] result,
    output reg take_branch
);

    reg [17:0] result_int;
    reg take_branch_int;

    wire [15:0] left_shift_result;
    wire [15:0] right_shift_result;

    LEFT_SHIFTER rs(reg_1, reg_2[3:0], left_shift_result);
    RIGHT_SHIFTER rs(reg_1, reg_2[3:0], right_shift_result);

    always @(posedge clk) begin
        if (en) begin
            case (alu_op)
                // TODO: implement signed and unsigned addition and
                // substraction
                OPCODE_ADD: begin
                    result_int <= reg_1 + reg_2;
                    take_branch_int = 1'b0;
                end
                OPCODE_SUB: begin
                    result_int <= reg_1 - reg_2;
                    take_branch_int = 1'b0;
                end
                OPCODE_OR: begin
                    result_int <= reg_1 | reg_2;
                    take_branch_int = 1'b0;
                end
                OPCODE_XOR: begin
                    result_int <= reg_1 ^ reg_2;
                    take_branch_int = 1'b0;
                end
                OPCODE_AND: begin
                    result_int <= reg_1 & reg_2;
                    take_branch_int = 1'b0;
                end
                OPCODE_NOT: begin
                    result_int <= ~reg_1;
                    take_branch_int = 1'b0;
                end
                OPCODE_READ: begin
                    result_int <= reg_1 + imm[4:0];
                    take_branch_int = 1'b0;
                end
                OPCODE_WRITE: begin
                    result_int <= reg_1 + imm[15:11];
                    take_branch_int = 1'b0;
                end
                OPCODE_LOAD: begin
                    if (alu_op[0:0])
                        result_int[15:0] <= {imm[7:0], 8'b0};
                    else begin
                        result_int[15:0] <= {8'b0, imm[7:0]};
                        take_branch_int = 1'b0;
                    end
                end
                OPCODE_CMP: begin
                    result_int[CMP_BIT_EQ:CMP_BIT_EQ] <= (reg_1 == reg_2);
                    result_int[CMP_BIT_AZ:CMP_BIT_AZ] <= (reg_1 == 16'h0000);
                    result_int[CMP_BIT_BZ:CMP_BIT_BZ] <= (reg_2 == 16'h0000);
                    if (alu_op[0:0]) begin
                        result_int[CMP_BIT_AGB:CMP_BIT_AGB] <= ($unsigned(reg_1) > $unsigned(reg_2));
                        result_int[CMP_BIT_ALB:CMP_BIT_ALB] <= ($unsigned(reg_1) < $unsigned(reg_2));
                    end else begin
                        result_int[CMP_BIT_AGB:CMP_BIT_AGB] <= ($signed(reg_1) > $signed(reg_2));
                        result_int[CMP_BIT_ALB:CMP_BIT_ALB] <= ($signed(reg_1) < $signed(reg_2));
                    end

                    result_int[15:15] = 1'b0;
                    result_int[9:0] = 10'b0;
                    take_branch_int = 1'b0;
                end
                OPCODE_SHL: begin
                    result_int[15:0] <= left_shift_result;
                    take_branch_int = 1'b0;
                end
                OPCODE_SHR: begin
                    result_int[15:0] <= right_shift_result;
                    take_branch_int = 1'b0;
                end
                OPCODE_JUMP: begin
                    if (alu_op[0:0] == 1'b0)
                        result_int[15:0] <= reg_1;
                    take_branch_int = 1'b1;
                end
                OPCODE_JUMPEQ: begin
                    result_int[15:0] = reg_2;

                    case ({alu_op[0:0], imm[1:0]})
                        CJF_EQ: take_branch_int <= reg_1[CMP_BIT_EQ:CMP_BIT_EQ];
                        CJF_AZ: take_branch_int <= reg_1[CMP_BIT_AZ:CMP_BIT_AZ];
                        CJF_BZ: take_branch_int <= reg_1[CMP_BIT_BZ:CMP_BIT_BZ];
                        CJF_ANZ: take_branch_int <= ~reg_1[CMP_BIT_AZ:CMP_BIT_AZ];
                        CJF_BNZ: take_branch_int <= ~reg_1[CMP_BIT_BZ:CMP_BIT_BZ];
                        CJF_AGB: take_branch_int <= reg_1[CMP_BIT_AGB:CMP_BIT_AGB];
                        CJF_ALB: take_branch_int <= reg_1[CMP_BIT_ALB:CMP_BIT_ALB];
                        default: take_branch_int <= 1'b0;
                    endcase
                end
            endcase
        end
    end

endmodule
