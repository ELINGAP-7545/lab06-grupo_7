# lab06 Diseño de banco de Registro

## Grupo 7

### Integrantes

Juan David Sandoval Suárez - 39718


Bryan Daniel Melo Guzman - 49686

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

![cn](https://github.com/Fabeltranm/SPARTAN6-ATMEGA-MAX5864/blob/master/lab/lab07-BancosRgistro/doc/caja%20negra.png)

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

 ![caja](https://github.com/Fabeltranm/SPARTAN6-ATMEGA-MAX5864/blob/master/lab/lab07-BancosRgistro/doc/banco%20registro.png)

# Implementación en LabsLand

### Asignacion de variable

Principalmente se realiza la asignación para la cantidad de bist que tendrá cada registro como se muestra en la siguiente tabla se asigna la distribución que se verá en la FPGA:


![caja](https://github.com/ELINGAP-7545/lab06-grupo_7/blob/master/Img/Asig.jpeg)

Adaptación de código a LabsLand

Vamos a utilizar los 10 sw que trae la FPGA virtual por defecto utilizamos “V_SW”, 2 botones de “V_BT” para asignarlos a Reg de escritura y el reset, como salidas pondremos dos displays “G_HEX0” y “G_HEX1”, por ultimo la entrada de reloj “G_CLOCK50”.

```verilog
module BancoRegistro  #( Parametros
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