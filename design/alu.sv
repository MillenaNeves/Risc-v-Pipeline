`timescale 1ns / 1ps

module alu#(
        parameter DATA_WIDTH = 32,
        parameter OPCODE_LENGTH = 4
        )
        (
        input logic [DATA_WIDTH-1:0]    SrcA,
        input logic [DATA_WIDTH-1:0]    SrcB,

        input logic [OPCODE_LENGTH-1:0]    Operation,
        output logic[DATA_WIDTH-1:0] ALUResult
        );
    
        always_comb
        begin
            case(Operation)
            4'b0000:        // AND
                    ALUResult = SrcA & SrcB;
            4'b0010:        // ADD
                    ALUResult = SrcA + SrcB;
            4'b1000:        // Equal
                    ALUResult = (SrcA == SrcB) ? 1 : 0;
            4'b0011:        // bne
                    ALUResult = (SrcA != SrcB) ? 1 : 0; 
            4'b0100:        // blt
                    ALUResult = (SrcA < SrcB) ? 1 : 0;
            4'b0101:        // bge
                   ALUResult = (SrcA >= SrcB) ? 1 : 0;
            4'b0110:        // slt e slti
                    ALUResult = (SrcA < SrcB) ? 1 : 0;
            4'b0111:        // or
                    ALUResult = SrcA | SrcB;
            4'b1000:        // xor
                    ALUResult = SrcA ^ SrcB;
            4'b1001:        // sub 
                    ALUResult = SrcA - SrcB;
            4'b1010:        // srli
                    ALUResult = SrcA >> SrcB;
            4'b1011:        // slli
                    ALUResult = SrcA << SrcB; 
            4'b1100:        // srai
                ALUResult = SrcA >>> SrcB[4:0];
            default:
                    ALUResult = 0;
            endcase
        end
endmodule

