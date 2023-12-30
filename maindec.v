`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/10/23 15:21:30
// Design Name: 
// Module Name: maindec
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
`include"defines2.vh"

module maindec(
	input wire[5:0] op,
	input wire[5:0] funct,
	input wire[4:0] rt,
	output wire memtoreg,memwrite,
	output wire branch,alusrc,
	output wire [1:0]regdst,
	output wire regwrite,
	output wire jump,jr,jal
    );
	reg[9:0] controls;
	assign {regwrite,regdst,alusrc,branch,memwrite,memtoreg,jump,jr,jal} = controls;
	always @(*) begin
		case (op)
		    `R_TYPE:
				case (funct)
					// `ADD,`ADDU,`SUB,`SUBU,`SLT,`SLTU,
					// `AND,`NOR,`OR,`XOR,
					// `SLLV,`SLL,`SRAV,`SRA,`SRLV,`SRL,
					// `MFHI,`MFLO:						controls <= 12'b1_01_000000000;
					// `DIV,`DIVU,`MULT,`MULTU,
					// `MTHI,`MTLO:						controls <= 12'b0_00_000001000;
					`JR:								controls <= 10'b0_00_0000010;
					`JALR:								controls <= 10'b1_01_0000011;
					//自陷指令
					//`BREAK,`SYSCALL:                    controls <= 12'b0_00_000000000;
					default:  begin
						controls <= 10'b0_00_0000000;
						//is_invalid <= 1'b1;
					end
				endcase
			//`lw:controls <= 9'b1010010;//LW
			//`SW:controls <= 9'b0010100;//SW
			//`ADDI:controls <= 9'b1010000;//ADDI
			//分支指令
			`BEQ,`BNE,`BGTZ,`BLEZ:		controls <=10'b0_00_0100000;
			`REGIMM_INST:
				case (rt)
					`BGEZ,`BLTZ:		controls <=10'b0_00_0100000;
					`BGEZAL,`BLTZAL:    controls <=10'b1_10_0100001;
					default:  begin
						controls <= 10'b0_00_0000000;
					end
				endcase
            //跳转指令
			`J:		controls <= 10'b0_00_0000100;//J
			`JAL:   controls <= 10'b1_10_0000101;
			default:  controls <= 10'b0_00_0000000;//illegal op
		endcase
	end
endmodule
