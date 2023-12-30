`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/10/23 15:21:30
// Design Name: 
// Module Name: controller
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


module controller(
	input wire clk,rst,
	//decode stage
	input wire[5:0] opD,functD,
	input wire[4:0] rtD,
	input wire equalD,
	output wire pcsrcD,branchD,jumpD,jrD,
	
	//execute stage
	input wire flushE,
	output wire memtoregE,alusrcE,
	output wire [1:0]regdstE,
	output wire regwriteE,	
	output wire[4:0] alucontrolE,
	output wire jalE,

	//mem stage
	output wire memtoregM,memwriteM,
				regwriteM,
	//write back stage
	output wire memtoregW,regwriteW

    );
	
	//decode stage
	//wire[1:0] aluopD;
	wire memtoregD,memwriteD,alusrcD,regwriteD,jalD;
	wire [1:0]regdstD ;
	wire[4:0] alucontrolD;

	//execute stage
	wire memwriteE;

	maindec mdc(
	opD,
	functD,
	rtD,
	memtoregD,memwriteD,
	branchD,alusrcD,
	regdstD,
	regwriteD,
	jumpD,jrD,jalD
    );
	aludec ad(functD,opD,rtD,alucontrolD);

	assign pcsrcD = branchD & equalD;

	//pipeline registers
	floprc #(12) regE(//alucontrol [4:0]五位,regdstD 2�?
		clk,
		rst,
		flushE,
		{memtoregD,memwriteD,alusrcD,regdstD,regwriteD,alucontrolD,jalD},
		{memtoregE,memwriteE,alusrcE,regdstE,regwriteE,alucontrolE,jalE}
		);
	flopr #(3) regM(
		clk,rst,
		{memtoregE,memwriteE,regwriteE},
		{memtoregM,memwriteM,regwriteM}
		);
	flopr #(2) regW(
		clk,rst,
		{memtoregM,regwriteM},
		{memtoregW,regwriteW}
		);
endmodule
