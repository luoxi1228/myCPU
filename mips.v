`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/11/07 10:58:03
// Design Name: 
// Module Name: mips
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


module mips(
	input wire clk,rst,
	output wire[31:0] pcF,
	input wire[31:0] instrF,
	output wire memwriteM,
	output wire[31:0] aluoutM,writedataM,
	input wire[31:0] readdataM 
    );
	
	wire [5:0] opD,functD;
	wire [1:0]regdstE;
	wire alusrcE,pcsrcD,memtoregE,memtoregM,memtoregW,
			regwriteE,regwriteM,regwriteW;
	wire [4:0] alucontrolE;
	wire flushE,equalD;
	wire [4:0] rtD;//controller模块需要的rtD
	wire jumpD,jalE,branchD;

controller(
	clk,rst,
	//decode stage
	opD,functD,
	rtD,
	equalD,
	pcsrcD,branchD,jumpD,
	
	//execute stage
	flushE,
	memtoregE,alusrcE,
	regdstE,
	regwriteE,	
	alucontrolE,
	jalE,

	//mem stage
	memtoregM,memwriteM,
				regwriteM,
	//write back stage
	memtoregW,regwriteW

    );


datapath(
	clk,rst,
	//fetch stage
	pcF,
	instrF,
	//decode stage
	pcsrcD,branchD,
	jumpD,
	equalD,
	opD,functD,
	rtD,//提供给controller模块
	//execute stage
	memtoregE,
	alusrcE,
	regdstE,
	regwriteE,
	alucontrolE,
	jalE,
	flushE,
	//mem stage
	memtoregM,
	regwriteM,
	aluoutM,writedataM,
	readdataM,
	//writeback stage
	memtoregW,
	regwriteW
    );
	
endmodule
