# Laboratorio #6 Diseño de Banco de Registro

## Grupo 7

### Integrantes

Juan David Sandoval Suárez - 39718

Bryan Daniel Melo Guzman - 49686

Fabian Santiago Martin Morantes - 60821

# Introducción


Para este paquete de trabajo, deben estar inscrito en un grupo y clonar la información del siguiente link [WP06](https://classroom.github.com/g/XHLhUCe3). Una vez aceptado el repositorio debe descargarlo en su computador, para ello debe clonar el mismo. Si no sabe cómo hacerlo revise la metodología de trabajo, donde se explica el proceso

Las documentación deben estar diligencia en el archivo README.md del repositorio clonado.

Una vez clone el repositorio, realice lo siguiente:


## Descipción 
Se debe diseñar un banco de registro tal que:

* El banco de registro debe tener 16 registros de R/W.
* Permitir la lectura de 2 registros  simultáneamente 
* Permitir la escritura  de 1 registro, acorde a la señal de control regwrite
* Contar con señal de rst, la cual  ponga  todos los registros en un valor conocido.

![caja negra](https://github.com/ELINGAP-7545/lab06-grupo_7/blob/master/Img/caja%20negra.png)

* Visualizar la información, en al menos dos display de 7 segmentos (información de cada registro leído).
* El ingreso de la información se debe hacer por medio de los interruptores.


**Opcional. Da mas puntos:**
* Parametrizar el tamaño de palabra de cada registro  y la cantidad de registro ( Por defecto =4 bits). Se recomienda leer el documento de este [link](https://ocw.mit.edu/courses/electrical-engineering-and-computer-science/6-884-complex-digital-systems-spring-2005/related-resources/parameter_models.pdf) .
* Pre cargar el banco de registro con información.  _Usar $readmenh_  (Investigar: "Initialize Memory in Verilog").

Entregables:

* Documentación
* Archivo `testbench` el cuál debe simular la escritura de 16 registros y 8 lecturas mas el rst, el resultado de la simulación debe visualizarse en diagrama de tiempo.
* Vídeo de la implementación.
* Código HDL de la solución.
.

 ![banco registro](https://github.com/ELINGAP-7545/lab06-grupo_7/blob/master/Img/banco%20registro.png)


# Implementación en LabsLand

### Asignación de variable

Principalmente se realiza la asignación para la cantidad de bits que tendrá cada registro como se muestra en la siguiente tabla se asigna la distribución que se verá en la FPGA:


![caja](https://github.com/ELINGAP-7545/lab06-grupo_7/blob/master/Img/Switches%20Virtuales.jpg)

## Adaptación de código a LabsLand


### Entradas, Salidas y Parametros

Vamos a utilizar los 10 switches virtuales que trae la FPGA virtual por defecto, utilizando de “V_SW” los 9 bits [9:0], 2 botones de “V_BT” se utilizan dos bits [1:0] para asignarlos a Reg de escritura y el reset, como salidas utilizamos dos displays “G_HEX0” es de 7 bits [6:0] y “G_HEX1” es de 7 bits [6:0], por último la entrada de reloj “G_CLOCK50”.


```verilog
module BancoRegistro #(      		 //   #( Parametros
         parameter BIT_ADDR = 8,  //   BIT_ADDR Número de bit para la dirección
         parameter BIT_DATO = 4,  //  BIT_DATO  Número de bit para el dato
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


```

### Asignación de Entradas y salidas dependiendo "reg" o "wire"

Todas las asignaciones que hagamos a continuación se realizaran con "wire" ya que son conexiones de entrada a salida, creamos y asignamos de la siguiente manera:


#### Entradas

Wire clk se asigna a G_CLOCK_50.

Wire rst se asigna a V_BT en el bit menos significativo que lo asignara al primer botón de derecha a izquierda [0]

Wire RegWrite se asigna a V_BT en el bit menos significativo que lo asignara al segundo botón de derecha a izquierda [1]

Wire addrRa se asignará a V_SW para dos bits los cuales corresponde a [1:0]

Wire addrRb se asignará a V_SW para dos bits los cuales corresponde a [3:2]

Wire addrW se asignará a V_SW para dos bits los cuales corresponde a [5:4]

Wire datW se asignará a V_SW para dos bits los cuales corresponde a [9:6]

Principalmente se realiza la asignación para la cantidad de bits que tendrá cada registro, como se muestra en la siguiente tabla se asigna la distribución que se verá en la FPGA:

```verilog

//Número de bit para la dirección

wire [1:0] addrRa;
assign addrRa =V_SW[1:0];

wire [1:0] addrRb;
assign addrRb=V_SW[3:2];

wire [1:0] addrW;
assign addrW = V_SW[5:4];

wire [3:0]datW;
assign datW = V_SW [9:6];

```

Es importante tener en cuenta la cantidad de wire [N:0], ya que sin esto no funcionaria.

#### Salidas 

Se utilizan dos displays "G_HEX0" y "GHEX1" de 7 bits cada uno, en este paso debemos realizar una instanciación llamando BDCtoSSeg

```verilog
//output displays

wire [3:0] datOutRa;
wire [3:0] datOutRb;

//instancia de display
BCDtoSSeg d2(.V_SW1(datOutRa), .G_HEX(G_HEX0));
BCDtoSSeg d3(.V_SW1(datOutRb), .G_HEX(G_HEX1));
```
### Reset

Utilizamos un if anidado para que este pase por cada registro y los ponga en 0

```verilog

  if (rst == 1)//reset banco de registros 
     breg[2'b00] <= 0;
      if (rst == 1)
        breg[2'b01] <= 0;
          if (rst == 1)
            breg[2'b10] <= 0;
              if (rst == 1)
                breg[2'b11] <= 0;
  end

```

## Código Verilog para LabsLand

A continuación, encontraran el código completo que se implementó para el Banco de registro y para los 7 segmentos, este código ya se encuentra parametrizado.

### Banco de Registro

```verilog

module BancoRegistro #(      		 //   #( Parametros
         parameter BIT_ADDR = 2,  //   BIT_ADDR Número de bit para la dirección
         parameter BIT_DATO = 4  //  BIT_DATO  Número de bit para el dato
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
    output [6:0]G_HEX2,
    output [6:0]G_HEX3,
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

//Número de bit para la dirección y asignacion

wire [BIT_ADDR-1:0] addrRa;
assign addrRa =V_SW[1:0];

wire [BIT_ADDR-1:0] addrRb;
assign addrRb=V_SW[3:2];

wire [BIT_ADDR-1:0] addrW;
assign addrW = V_SW[5:4];

wire [BIT_DATO-1:0]datW;
assign datW = V_SW [9:6];

//output displays

wire [BIT_DATO-1:0] datOutRa;
wire [BIT_DATO-1:0] datOutRb;

// La cantdiad de registros es igual a: 
localparam NREG = 2 ** BIT_ADDR; //Se encarga de la cantidad de registros
  
//configiración del banco de registro 
reg [BIT_DATO-1: 0] breg [NREG-1:0];


assign  datOutRa = breg[addrRa];
assign  datOutRb = breg[addrRb];

always @(posedge clk) begin
	if (RegWrite == 1)
     breg[addrW] <= datW;//Escritura en banco de registro

  if (rst == 1)//reset banco de registros 
     breg[2'b00] <= 0;
      if (rst == 1)
        breg[2'b01] <= 0;
          if (rst == 1)
            breg[2'b10] <= 0;
              if (rst == 1)
                breg[2'b11] <= 0;
  end

//instancia de display

BCDtoSSeg d2(.V_SW1(datOutRa), .G_HEX(G_HEX2));
BCDtoSSeg d3(.V_SW1(datOutRb), .G_HEX(G_HEX3));

endmodule

```

### Display o BCDtoSSeg

```verilog
module BCDtoSSeg (V_SW1, G_HEX);

   input wire [3:0] V_SW1;
   output wire [6:0] G_HEX;

    reg [6:0] SSeg;
    wire [3:0]  BCD;
    
    assign BCD =V_SW1;
    assign G_HEX = SSeg;

always @ ( * ) begin
  case (BCD)
      4'b0000: SSeg = 7'b1000000; // "0"  
      4'b0001: SSeg = 7'b1111001; // "1" 
      4'b0010: SSeg = 7'b0100100; // "2" 
      4'b0011: SSeg = 7'b0110000; // "3" 
      4'b0100: SSeg = 7'b0011001; // "4" 
      4'b0101: SSeg = 7'b0010010; // "5" 
      4'b0110: SSeg = 7'b0000010; // "6" 
      4'b0111: SSeg = 7'b1111000; // "7" 
      4'b1000: SSeg = 7'b0000000; // "8"  
      4'b1001: SSeg = 7'b0011000; // "9" 
      4'ha: SSeg = 7'b0001000;  
      4'hb: SSeg = 7'b0000011;
      4'hc: SSeg = 7'b0100111;
      4'hd: SSeg = 7'b0100001;
      4'he: SSeg = 7'b0000100;
      4'hf: SSeg = 7'b0001110;
    default:
    SSeg = 0;
  endcase
end

endmodule
```
## Sinterización y simulación 

En esta parte ya no tenemos problemas con la sinterización y podemos pasar a simular en la FPGA virtual

![caja](https://github.com/ELINGAP-7545/lab06-grupo_7/blob/master/Img/sintetizar.png)

Realizamos la simulación, no entiendo cómo debería ser el funcionamiento de para poder lograr la simulación y entenderla, esta pregunta se le realizara al profesor en la entrega del laboratorio.

![caja](https://github.com/ELINGAP-7545/lab06-grupo_7/blob/master/Img/br1.png)