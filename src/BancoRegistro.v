`timescale 1ns / 1ps
module BancoRegistro #(      		 //   #( Parametros
         parameter BIT_ADDR = 8,  //   BIT_ADDR Número de bit para la dirección
         parameter BIT_DATO = 4  //  BIT_DATO  Número de bit para el dato
	(
    input [BIT_ADDR-1:0] addrRa,
    input [BIT_ADDR-1:0] addrRb,
    
	 output [BIT_DATO-1:0] datOutRa,
    output [BIT_DATO-1:0] datOutRb,
    
	 input [BIT_ADDR:0] addrW,
    input [BIT_DATO-1:0] datW,
    
	 input RegWrite,
    input clk,
    input rst
    );

// La cantdiad de registros es igual a: 
localparam NREG = 2 ** BIT_ADDR;
  
//configiración del banco de registro 
reg [BIT_DATO-1: 0] breg [NREG-1:0];


assign  datOutRa = breg[addrRa];
assign  datOutRb = breg[addrRb];

always @(posedge clk) begin
	if (RegWrite == 1)
     breg[addrW] <= datW;
  end


endmodule

