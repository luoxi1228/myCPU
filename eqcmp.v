`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/11/23 22:57:01
// Design Name: 
// Module Name: eqcmp
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
`include "defines2.vh"

module eqcmp(
	input wire [31:0] a,b,
	input wire [5:0]op,
	input wire [4:0]rt,
	output reg y
    );
	always@(*) begin
		case(op)
			`BEQ : y = (a == b);
			`BNE : y = (a != b);
			`BGTZ : y = ((a[31] == 1'b0) & (a != `ZeroWord));// >0
			`BLEZ : y = ((a[31] == 1'b1) | (a == `ZeroWord));// <=0
			`REGIMM_INST : begin   //以下四条跳转指令，op相同根据rt的值进行区分
				case(rt) 
					`BGEZ,`BGEZAL : y = (a[31] == 1'b0);// >=0
					`BLTZ,`BLTZAL : y = (a[31] == 1'b1);// <0
					default :y = 1'b0;
				endcase
			end
			default :y = 1'b0;
		endcase
	end
endmodule
