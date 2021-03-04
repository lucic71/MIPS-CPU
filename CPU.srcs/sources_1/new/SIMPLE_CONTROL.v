`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/02/2021 09:28:06 PM
// Design Name: 
// Module Name: SIMPLE_CONTROL
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


module SIMPLE_CONTROL(
    input clk,
    input reset,
    output [3:0] state
);

    reg [3:0] state_int;

    always @(posedge clk) begin
        if (reset)
            state_int = 4'b0001;
        else begin
            case (state_int)
                4'b0001: state_int = 4'b0010;
                4'b0010: state_int = 4'b0100;
                4'b0100: state_int = 4'b1000;
                4'b1000: state_int = 4'b0001;
                default: state_int = 4'b0001;
            endcase
        end
    end

    assign state = state_int;

endmodule
