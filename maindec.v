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
	input wire[4:0] rt,
	output wire memtoreg,memwrite,
	output wire branch,alusrc,
	output wire regdst,regwrite,
	output wire jump,jr
    );
	reg[7:0] controls;
	assign {regwrite,regdst,alusrc,branch,memwrite,memtoreg,jump,jr} = controls;
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
					`JR:								controls <= 8'b00000001;
					//`JALR:								controls <= 12'b1_01_000000110;
					//自陷指令
					//`BREAK,`SYSCALL:                    controls <= 12'b0_00_000000000;
					default:  begin
						controls <= 8'b00000000;
						//is_invalid <= 1'b1;
					end
				endcase
			//`lw:controls <= 9'b1010010;//LW
			//`SW:controls <= 9'b0010100;//SW
			//`ADDI:controls <= 9'b1010000;//ADDI
			//分支指令
			`BEQ,`BNE,`BGTZ,`BLEZ:		controls <=8'b00010000;
			`REGIMM_INST:
				case (rt)
					`BGEZ,`BLTZ:		controls <=8'b00010000;
					`BGEZAL,`BLTZAL: ;
					default:  begin
						controls <= 8'b000000000;
					end
				endcase
            //跳转指令
			`J:		controls <= 8'b00000010;//J
			`JAL: ;
			default:  controls <= 8'b00000000;//illegal op
		endcase
	end
endmodule
