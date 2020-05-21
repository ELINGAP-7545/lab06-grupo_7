module TestBench;

	// Inputs
	reg [3:0] addrRa;
	reg [3:0] addrRb;
	reg [4:0] addrW;
	reg [3:0] datW;
	reg RegWrite;
	reg clk;
	reg rst;

	// Outputs
	wire [3:0] datOutRa;
	wire [3:0] datOutRb;

	// Instantiate the Unit Under Test (UUT)
	BancoRegistro uut (
		.addrRa(addrRa), 
		.addrRb(addrRb), 
		.datOutRa(datOutRa), 
		.datOutRb(datOutRb), 
		.addrW(addrW), 
		.datW(datW), 
		.RegWrite(RegWrite), 
		.clk(clk), 
		.rst(rst)
	);

	initial begin
		// Initialize Inputs
		addrRa = 0;
		addrRb = 0;
		addrW = 0;
		datW = 0;
		RegWrite = 0;
		clk = 0;
		rst = 0;

		// Wait 100 ns for global reset to finish
		#100;
      for (addrRa = 0; addrRa < 8; addrRa = addrRa + 1) begin
			#5 addrRb=addrRa+8;
			 $display("el valor de registro %d =  %d y %d = %d", addrRa,datOutRa,addrRb,datOutRb) ;
    end
		
	end
      
endmodule

