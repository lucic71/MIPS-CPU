`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/24/2021 12:10:40 PM
// Design Name: 
// Module Name: INSTRUCTION_DECODER_TB
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


module INSTRUCTION_DECODER_TB();

    reg clk;
    reg en;
    reg [15:0] instr_data;
    wire [2:0] reg_sel_1;
    wire [2:0] reg_sel_2;
    wire [2:0] write_reg_sel;
    wire [15:0] imm_data;
    wire reg_write;
    wire [5:0] alu_op;

    INSTRUCTION_DECODER id0(
        clk,
        en,
        instr_data,
        reg_sel_1,
        reg_sel_2,
        write_reg_sel,
        imm_data,
        reg_write,
        alu_op
    );

    always #5 clk = ~clk;

    initial begin
        #0 clk = 1'b0;
           en = 1'b0;
        #10 en = 1'b1;

        // RRR type
        #10 instr_data = 16'b0000_001_0_010_011_00;

        // RRs
        #10 instr_data = 16'b0001_XXX_1_110_111_00;

        // RRd
        #10 instr_data = 16'b0010_001_0_010_XXXXX;

        // R
        #10 instr_data = 16'b0011_001_1_XXXXXXXX;

        // Rimm
        #10 instr_data = 16'b0100_001_0_01001100;

        // Imm
        #10 instr_data = 16'b0101_001_1_01001100;

        #20 $finish;
    end

endmodule
