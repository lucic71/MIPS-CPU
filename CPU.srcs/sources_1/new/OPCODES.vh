`ifndef _opcodes_h
`define _opcodes_h

localparam OPCODE_ADD    = 4'b0000;
localparam OPCODE_SUB    = 4'b0001;
localparam OPCODE_OR     = 4'b0010;
localparam OPCODE_XOR    = 4'b0011;
localparam OPCODE_AND    = 4'b0100;
localparam OPCODE_NOT    = 4'b0101;
localparam OPCODE_READ   = 4'b0110;
localparam OPCODE_WRITE  = 4'b0111;
localparam OPCODE_LOAD   = 4'b1000;
localparam OPCODE_CMP    = 4'b1001;
localparam OPCODE_SHL    = 4'b1010;
localparam OPCODE_SHR    = 4'b1011;
localparam OPCODE_JUMP   = 4'b1100;
localparam OPCODE_JUMPEQ = 4'b1101;

`endif
