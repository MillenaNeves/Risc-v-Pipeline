`timescale 1ns / 1ps

module datamemory #(
    parameter DM_ADDRESS = 9,
    parameter DATA_W = 32
) (
    input logic clk,
    input logic MemRead,  // comes from control unit
    input logic MemWrite,  // Comes from control unit
    input logic [DM_ADDRESS - 1:0] a,  // Read / Write address - 9 LSB bits of the ALU output
    input logic [DATA_W - 1:0] wd,  // Write Data
    input logic [2:0] Funct3,  // bits 12 to 14 of the instruction
    output logic [DATA_W - 1:0] rd  // Read Data
);

  logic [31:0] raddress;
  logic [31:0] waddress;
  logic [31:0] Datain;
  logic [31:0] Dataout;
    logic [ 3:0] Wr; //Wr[3] -> controla de 31 a 24, Wr[2] -> controla de 23 a 16, Wr[1] -> controla de 15 a 8, Wr[0] -> controla de 7 a 0,

  Memoria32Data mem32 (
      .raddress(raddress),
      .waddress(waddress),
      .Clk(~clk),
      .Datain(Datain),
      .Dataout(Dataout),
      .Wr(Wr)
  );

  always_ff @(*) begin
    raddress = {{22{1'b0}}, a};
    waddress = {{22{1'b0}}, {a[8:2], {2{1'b0}}}};
    Datain = wd;
    Wr = 4'b0000;

    if (MemRead) begin
      case (Funct3)
        3'b010: begin //LW
        rd <= Dataout;
        end
        3'b000: begin//LB
            rd <=  $signed(Dataout[7:0]);//Pega só os 8 últimos dígitos
        end
        3'b100: begin  //LBU
            rd <= {24'b0, Dataout[7:0]};//Garante que seja positivo zerando os 24 primeiros e pega os 8 ultimos
        end
        3'b001:begin  //LH
            rd <= $signed(Dataout[15:0]);//
        end
        default: rd <= Dataout;
      endcase
    end else if (MemWrite) begin
      case (Funct3)
        3'b000: begin  //SH Escreve os ultimos
          Wr <= 4'b0011;//Wr ativo de 15 a 0
            Datain <= wd[15:0];// escreve
        end
        3'b001: begin  //SB Escreve os ultimos 8 bits
          Wr <= 4'b0001;//Wr tem que está ativo só onde controla de 7 a 0
            Datain <= wd[7:0];
        end
        3'b010: begin  //SW escreve palavra completa
          Wr <= 4'b1111;
          Datain <= wd;
        end
        default: begin
          Wr <= 4'b1111;
          Datain <= wd;
        end
      endcase
    end
  end

endmodule
