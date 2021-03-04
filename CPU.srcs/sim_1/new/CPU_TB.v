`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/02/2021 09:39:27 PM
// Design Name: 
// Module Name: CPU_TB
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
//  The initial configuration has reset = 1 to set the correct state in
//  simple_control.
//
//  The first instruction is loaded on posedge of clock. To load the next
//  intsturction en_regwrite must go to posedge. Enable bits are calculated
//  in simple control.
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module CPU_TB();

    `include "OPCODES.vh"

    // id
    reg clk;
    reg [15:0] instr_data;
    wire [2:0] reg_sel_1;
    wire [2:0] reg_sel_2;
    wire [2:0] write_reg_sel;
    wire [15:0] imm_data;
    wire reg_write;
    wire [5:0] alu_op;

    // rf
    wire [15:0] reg_data_1;
    wire [15:0] reg_data_2;

    // alu
    wire [15:0] result;
    wire take_branch;

    // control
    reg reset;
    wire [3:0] state;

    wire en_decode = state[0:0];
    wire en_regread = state[1:1];
    wire en_alu = state[2:2];
    wire en_regwrite = state[3:3];

    INSTRUCTION_DECODER id(
        clk,
        en_decode,
        instr_data,
        reg_sel_1,
        reg_sel_2,
        write_reg_sel,
        imm_data,
        reg_write,
        alu_op
    );

    REGISTER_FILE rf(
        clk,
        en_regread | en_regwrite,
        reg_write & en_regwrite,
        reg_sel_1,
        reg_sel_2,
        write_reg_sel,
        result,
        reg_data_1,
        reg_data_2
    );

    ALU alu(
        clk,
        en_alu,
        reg_data_1,
        reg_data_2,
        alu_op,
        16'b0,
        imm_data,
        result,
        take_branch
    );

    SIMPLE_CONTROL sc(
        clk,
        reset,
        state
    );

    localparam clk_period = 5;
    always #clk_period clk = ~clk;

    initial begin
        clk = 1'b0;
        reset = 1'b1;

        #clk_period;

        // load.h r0, 0xfe
        instr_data = {`OPCODE_LOAD, 3'b0, 1'b0, 8'hFE};
        reset = 1'b0;
        @(posedge en_regwrite);

        // load.l r1, 0xed
        instr_data = {`OPCODE_LOAD, 3'b001, 1'b1, 8'hED};
        @(posedge en_regwrite);

        // or r2, r0, r1
        instr_data = {`OPCODE_OR, 3'b010, 1'b0, 3'b000, 3'b001, 2'b00};
        @(posedge en_regwrite);

        #(clk_period * 3) $finish;
    end


endmodule
