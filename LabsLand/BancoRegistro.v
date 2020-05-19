module BancoRegistro #(      		 //   #( Parametros
         parameter BIT_ADDR = 4,  //   BIT_ADDR Número de bit para la dirección
         parameter BIT_DATO = 2  //  BIT_DATO  Número de bit para el dato
        // No realizo paramitrezacion ya que veo que es mas complejo y no entiendo unas variables del programa
			)
	(/*
    input [BIT_ADDR-1:0] addrRa, dado que BIT_ADDR esta parametrizado con el numereo 8 y le resto 1 queda un 7 a 0 igual a 8 bits
    input [BIT_ADDR-1:0] addrRb, lo mismo 8bits
    
	 output [BIT_DATO-1:0] datOutRa, BIT_DATO 
    output [BIT_DATO-1:0] datOutRb,
    
	 input [BIT_ADDR:0] addrW,
    input [BIT_DATO-1:0] datW,
    */
	 //input RegWrite,
    output [6:0]G_HEX0,
    output [6:0]G_HEX1,
    input [9:0] V_SW,
    //input clk,
    input G_CLOCK_50,
    input [1:0] V_BT);
    
// Aignacion de reloj
wire clk;
assign clk = G_CLOCK_50;

//asignacion de reset

wire rst;
assign rst = V_BT[0];

//asignación Escribir

wire RegWrite;
assign RegWrite = V_BT[1];

//Número de bit para la dirección

wire [1:0] addrRa;
assign addrRa =V_SW[1:0];

wire [1:0] addrRb;
assign addrRb=V_SW[3:2];

wire [1:0] addrW;
assign addrW = V_SW[5:4];

wire [3:0]datW;
assign datW = V_SW [9:6];

//output displays

wire [3:0] datOutRa;
wire [3:0] datOutRb;

// La cantdiad de registros es igual a: 
localparam NREG = 2 ** BIT_ADDR; //no entiendo que hace esta linea ??????????????????????
  
//configiración del banco de registro 
reg [BIT_DATO-1: 0] breg [NREG-1:0];


assign  datOutRa = breg[addrRa];
assign  datOutRb = breg[addrRb];

always @(posedge clk) begin
	if (RegWrite == 1)
     breg[addrW] <= datW;
  if (rst==1)
    breg[addrW] <= datW;

  end

//instancia de display
BCDtoSSeg d2(.V_SW1(datOutRa), .G_HEX(G_HEX0));
BCDtoSSeg d3(.V_SW1(datOutRb), .G_HEX(G_HEX1));

endmodule

