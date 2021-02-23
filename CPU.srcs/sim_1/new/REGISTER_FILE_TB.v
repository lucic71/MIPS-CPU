`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Design Name: 
// Module Name: REGISTER_FILE_TB
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


module REGISTER_FILE_TB();
    reg clk;
    reg en;
    reg reg_write;
    reg [2:0] reg_sel_1, reg_sel_2, write_reg_sel;
    reg [15:0] write_data;
    wire [15:0] reg_data_1, reg_data_2;

    REGISTER_FILE rf0(
        clk,
        en,
        reg_write,
        reg_sel_1,
        reg_sel_2,
        write_reg_sel,
        write_data,
        reg_data_1,
        reg_data_2
    );

    always #5 clk = ~clk;

    initial begin
        // initial configuration
        #0 clk = 1'b0;
           en = 1'b0;
        #10 en = 1'b1;

        // write a register then read it
        #10 reg_write = 1'b1;
            write_data = 16'hFFFF;
            write_reg_sel = 3'b001;
        #20 reg_write = 1'b0;
            reg_sel_1 = 3'b001;

        // write a register and read it at the same time (shoulrd return old value on output)
        #10 reg_write = 1'b1;
            write_data = 16'hF0F0;
            write_reg_sel = 3'b010;
            reg_sel_1 = 3'b010;
            reg_write = 1'b0;
            
        #40 $finish;
    end
endmodule
