`ifndef _opcodes_h
`define _opcodes_h

`define OPCODE_ADD    4'b0000
`define OPCODE_SUB    4'b0001
`define OPCODE_OR     4'b0010
`define OPCODE_XOR    4'b0011
`define OPCODE_AND    4'b0100
`define OPCODE_NOT    4'b0101
`define OPCODE_READ   4'b0110
`define OPCODE_WRITE  4'b0111
`define OPCODE_LOAD   4'b1000
`define OPCODE_CMP    4'b1001
`define OPCODE_SHL    4'b1010
`define OPCODE_SHR    4'b1011
`define OPCODE_JUMP   4'b1100
`define OPCODE_JUMPEQ 4'b1101

`endif
