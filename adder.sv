module adder #(parameter WIDTH = 10) (out, a, b);
	output logic [WIDTH-1:0] out;
	input logic [WIDTH-1:0] a, b;
	
	
	always @(*)
		out = a + b;
	
endmodule

module adder_testbench();
	logic   [0:9]	a, b;
	logic  [0:9]	out;
	
	
	adder dut (out, a, b);
	
	initial begin
		a = 0;	b = 1;	#100; //an addition with one input being 0
		a = 256;	b = 255;	#100; // an addition with result = 511
		a = 0;   b = 0;	#100  // an adddition with result = 0
		a = 512; b = 512; #100 // unsigned overflow 
		//a = ; b = ; #100 // positive overflow
		//a = ; b = ; #100 // negative overflow
		
		$stop;
		
	end
endmodule
