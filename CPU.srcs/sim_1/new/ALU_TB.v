`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/26/2021 07:05:57 PM
// Design Name: 
// Module Name: ALU_TB
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

module ALU_TB();
    `include "OPCODES.vh"
    `include "CMP_BIT_MAP.vh"

    task validate_result(
        input [6*8:1] op_name,
        input [15:0] expected,
        input [15:0] actual
    );
        begin
            if (actual != expected) begin
                $display("TESTBENCH ERROR: %s result is incorrect!", op_name);
                $display("Expected: %h, Actual: %h", expected, actual);
                $stop;
            end else
                $display("%s result correct!", op_name);
        end
    endtask

    task validate_take_branch(
        input [6*8:1] op_name,
        input expected,
        input actual
    );
        begin
            if (actual != expected) begin
                $display("TESTBENCH ERROR: %s take_branch is incorrect!", op_name);
                $display("Expected: %b, Actual: %b", expected, actual);
                $stop;
            end else
                $display("%s take_branch correct!", op_name);
        end
    endtask

    reg clk;
    reg en;
    reg [15:0] reg_1;
    reg [15:0] reg_2;
    reg [4:0] alu_op;
    reg [15:0] pc;
    reg [15:0] imm;
    wire [15:0] result;
    wire take_branch;
    reg [15:0] expected;

    localparam clk_period = 5;

    ALU alu0(
        clk,
        en,
        reg_1,
        reg_2,
        alu_op,
        pc,
        imm,
        result,
        take_branch
    );

    always #clk_period clk = ~clk;

    initial begin
        clk = 1'b0;
        en = 1'b0;
    end

    always @(posedge clk) begin
        en = 1'b1;
        pc = 16'h0;
        imm = 16'h0;

        // Test ADD
        reg_1 = 16'h0001;
        reg_2 = 16'h0001;
        alu_op = {`OPCODE_ADD, 1'b0};

        #clk_period;
        validate_result("ADD", 16'h0002, result);
        validate_take_branch("ADD", 1'b0, take_branch);
        #clk_period;
    
        // Test SUB
        reg_1 = 16'h0006;
        reg_2 = 16'h0002;
        alu_op = {`OPCODE_SUB, 1'b0};

        #clk_period;
        validate_result("SUB", 16'h0004, result);
        validate_take_branch("SUB", 1'b0, take_branch);
        #clk_period;
        
        // Test OR
        reg_1 = 16'hAAAA;
        reg_2 = 16'h5555;
        alu_op = {`OPCODE_OR, 1'b0};

        #clk_period;
        validate_result("OR", 16'hFFFF, result);
        validate_take_branch("OR", 1'b0, take_branch);
        #clk_period;

        // Test XOR
        reg_1 = {12'h000, 4'b1010};
        reg_2 = {12'h000, 4'b1100};
        alu_op = {`OPCODE_XOR, 1'b0};

        #clk_period;
        validate_result("XOR", {12'h000, 4'b0110}, result);
        validate_take_branch("XOR", 1'b0, take_branch);
        #clk_period;

        // Test AND
        reg_1 = 16'hFF00;
        reg_2 = 16'h00FF;
        alu_op = {`OPCODE_AND, 1'b0};

        #clk_period;
        validate_result("AND", 16'h0000, result);
        validate_take_branch("XOR", 1'b0, take_branch);
        #clk_period;

        // Test READ
        reg_1 = 16'h0000;
        imm = {11'b0, 5'b10000};
        alu_op = {`OPCODE_READ, 1'b0};

        #clk_period;
        validate_result("READ", 16'h0010, result);
        validate_take_branch("READ", 1'b0, take_branch);
        #clk_period;

        // Test WRITE
        reg_1 = 16'h0000;
        imm = {8'b1111_0000, 8'b1111_0000};
        alu_op = {`OPCODE_WRITE, 1'b0};

        #clk_period;
        validate_result("WRITE", {11'b0, 5'b11110}, result);
        validate_take_branch("WRITE", 1'b0, take_branch);
        #clk_period;

        // Test LOAD high byte
        imm = 16'hFFFF;
        alu_op = {`OPCODE_LOAD, 1'b1};

        #clk_period;
        validate_result("LOAD H", 16'hFF00, result);
        validate_take_branch("LOAD H", 1'b0, take_branch);
        #clk_period;

        // Test LOAD low byte
        imm = 16'hFFFF;
        alu_op = {`OPCODE_LOAD, 1'b0};

        #clk_period;
        validate_result("LOAD L", 16'h00FF, result);
        validate_take_branch("LOAD L", 1'b0, take_branch);
        #clk_period;

        // Test CMP EQ
        reg_1 = 16'hFF00;
        reg_2 = 16'hFF00;
        alu_op = {`OPCODE_CMP, 1'b0};

        #clk_period;
        expected = 16'b0;
        expected[`CMP_BIT_EQ:`CMP_BIT_EQ] = 1'b1;
        validate_result("CMP EQ", expected, result);
        validate_take_branch("CMP EQ", 1'b0, take_branch);
        #clk_period;

        // Test CMP AZ (will set ALB bit as well)
        reg_1 = 16'h0;
        reg_2 = 16'h0001;
        alu_op = {`OPCODE_CMP, 1'b0};

        #clk_period;
        expected = 16'b0;
        expected[`CMP_BIT_AZ:`CMP_BIT_AZ] = 1'b1;
        expected[`CMP_BIT_ALB:`CMP_BIT_ALB] = 1'b1;
        validate_result("CMP AZ", expected, result);
        validate_take_branch("CMP AZ", 1'b0, take_branch);
        #clk_period;

        // Test CMP BZ (will set AGB bit as well)
        reg_1 = 16'h0001;
        reg_2 = 16'h0;
        alu_op = {`OPCODE_CMP, 1'b0};

        #clk_period;
        expected = 16'b0;
        expected[`CMP_BIT_BZ:`CMP_BIT_BZ] = 1'b1;
        expected[`CMP_BIT_AGB:`CMP_BIT_AGB] = 1'b1;
        validate_result("CMP BZ", expected, result);
        validate_take_branch("CMP BZ", 1'b0, take_branch);
        #clk_period;

        // Test CMP signed
        reg_1 = 16'hFFFF;
        reg_2 = 16'h0001;
        alu_op = {`OPCODE_CMP, 1'b0};

        #clk_period;
        expected = 16'b0;
        expected[`CMP_BIT_ALB:`CMP_BIT_ALB] = 1'b1;
        validate_result("CMP S", expected, result);
        validate_take_branch("CMP S", 1'b0, take_branch);
        #clk_period;

        // Test CMP unsigned
        reg_1 = 16'h0002;
        reg_2 = 16'h0001;
        alu_op = {`OPCODE_CMP, 1'b1};

        #clk_period;
        expected = 16'b0;
        expected[`CMP_BIT_AGB:`CMP_BIT_AGB] = 1'b1;
        validate_result("CMP U", expected, result);
        validate_take_branch("CMP U", 1'b0, take_branch);
        #clk_period;

        // Test SHL
        reg_1 = 16'h0001;
        reg_2 = 16'h0003;
        alu_op = {`OPCODE_SHL, 1'b0};

        #clk_period;
        validate_result("SHL", (reg_1 << 3), result);
        validate_take_branch("SHL", 1'b0, take_branch);
        #clk_period;

        // Test SHR
        reg_1 = 16'h0010;
        reg_2 = 16'h0004;
        alu_op = {`OPCODE_SHR, 1'b0};

        #clk_period;
        validate_result("SHR", 16'h0001, result);
        validate_take_branch("SHR", 1'b0, take_branch);
        #clk_period;

        // Test JUMP
        reg_1 = 16'hABCD;
        alu_op = {`OPCODE_JUMP, 1'b0};

        #clk_period;
        validate_result("JUMP", reg_1, result);
        validate_take_branch("JUMP", 1'b1, take_branch);
        #clk_period;

        // Test JUMPEQ
        reg_1 = 16'b0;
        reg_1[`CMP_BIT_AZ:`CMP_BIT_AZ] = 1'b1;
        reg_2 = 16'h001F;
        alu_op = {`OPCODE_JUMPEQ, 1'b0};
        imm = {14'b0, 2'b01};

        #clk_period;
        validate_result("JUMPEQ", reg_2, result);
        validate_take_branch("JUMPEQ", 1'b1, take_branch);
        #clk_period;

        $finish;
    end

endmodule
