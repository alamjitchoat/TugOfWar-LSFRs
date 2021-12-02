module tugOfWarClock (CLOCK_50, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, KEY, LEDR, SW);
	input  logic		   CLOCK_50; // 50MHz clock.
	output logic [6:0]	HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
	output logic [9:0]	LEDR;
	input  logic [3:0]	KEY;		 // True when not pressed, False when pressed
	input  logic [9:0]	SW;

	// Hook up FSM inputs and outputs.
	logic reset, Left, Right, cout;
	assign reset = SW[9];		 // Reset when SW[9] is true.
	assign LEDR[0] = 1'b0;      // have LEDR[0] be off
	logic [8:0] LSFRoutput; 
	logic [9:0] sum;
	
	
	assign HEX4 = 7'b1111111;
   assign HEX3 = 7'b1111111;
   assign HEX2 = 7'b1111111;
   assign HEX1 = 7'b1111111;
	
	// Generate clk off of CLOCK_50, whichClock picks rate.
	logic [31:0] clk;
	parameter whichClock = 15;
	clock_divider cdiv (.clock(CLOCK_50), .divided_clocks(clk));
	
	
	LSFR l (LSFRoutput[8:0], clk[whichClock], reset);
	adder add(sum[9:0], SW[8:0], LSFRoutput[8:0], 0, cout);
	assign LeftComp = sum[9];
	
	
	buttonInput keyZero (.Clock(clk[whichClock]), .Reset(reset), .Out(Right), .Key(~KEY[0]));
	buttonInput keyThreeComp (.Clock(clk[whichClock]), .Reset(reset), .Out(Left), .Key(LeftComp));
	
	centerLight middleLight (.Clock(clk[whichClock]), .Reset(reset), .L(Left), .R(Right), .NL(LEDR[6]), .NR(LEDR[4]), .lightOn(LEDR[5]), .restartGame(restartGame));
	
	normalLight oneLight (.Clock(clk[whichClock]), .Reset(reset), .L(Left), .R(Right), .NL(LEDR[2]), .NR(1'b0), .lightOn(LEDR[1]), .restartGame(restartGame));
	normalLight twoLight (.Clock(clk[whichClock]), .Reset(reset), .L(Left), .R(Right), .NL(LEDR[3]), .NR(LEDR[1]), .lightOn(LEDR[2]), .restartGame(restartGame));
	normalLight threeLight (.Clock(clk[whichClock]), .Reset(reset), .L(Left), .R(Right), .NL(LEDR[4]), .NR(LEDR[2]), .lightOn(LEDR[3]), .restartGame(restartGame));
	normalLight fourLight (.Clock(clk[whichClock]), .Reset(reset), .L(Left), .R(Right), .NL(LEDR[5]), .NR(LEDR[3]), .lightOn(LEDR[4]), .restartGame(restartGame));
	
	
	normalLight sixLight (.Clock(clk[whichClock]), .Reset(reset), .L(Left), .R(Right), .NL(LEDR[7]), .NR(LEDR[5]), .lightOn(LEDR[6]), .restartGame(restartGame));
	normalLight sevenLight (.Clock(clk[whichClock]), .Reset(reset), .L(Left), .R(Right), .NL(LEDR[8]), .NR(LEDR[6]), .lightOn(LEDR[7]), .restartGame(restartGame));
	normalLight eightLight (.Clock(clk[whichClock]), .Reset(reset), .L(Left), .R(Right), .NL(LEDR[9]), .NR(LEDR[7]), .lightOn(LEDR[8]), .restartGame(restartGame));
	normalLight nineLight (.Clock(clk[whichClock]), .Reset(reset), .L(Left), .R(Right), .NL(1'b0), .NR(LEDR[8]), .lightOn(LEDR[9]), .restartGame(restartGame));
	
	displayVictory gameOver (.Clock(clk[whichClock]), .Reset(reset), .L(Left), .R(Right), .LED1(LEDR[1]), .LED9(LEDR[9]), .HEX0(HEX0), .HEX5(HEX5), .restartGame(restartGame));
	
endmodule

// divided_clocks[0] = 25MHz, [1] = 12.5Mhz, ... [23] = 3Hz, [24] = 1.5Hz, [25] = 0.75Hz, ...
// HARDWARE ONLY - not to be used in simulation
module clock_divider (clock, divided_clocks);
	input  logic        clock;
	output logic [31:0] divided_clocks;

	initial
		divided_clocks = 0;

	always_ff @(posedge clock)
		divided_clocks <= divided_clocks + 1;
        
endmodule

module tugOfWarClock_testbench();
	logic		   CLOCK_50; // 50MHz clock.
	logic [6:0]	HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
	logic [9:0]	LEDR;
	logic [3:0]	KEY;		 // True when not pressed, False when pressed
	logic [9:0]	SW;
	logic reset, Left, Right;
	
	
	tugOfWarClock dut (CLOCK_50, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, KEY, LEDR, SW);
    
	// Set up the clock
	parameter CLOCK_PERIOD = 100;
	initial begin
    	CLOCK_50 <= 0;
		forever #(CLOCK_PERIOD/2) CLOCK_50 <= ~CLOCK_50;
	end

	// Set up the inputs to the design. Each line is a clock cycle.
	initial begin
		@(posedge CLOCK_50); SW[9] <= 1;
		@(posedge CLOCK_50); SW[0] <= 0; 
		@(posedge CLOCK_50);
		@(posedge CLOCK_50);
		@(posedge CLOCK_50);
		@(posedge CLOCK_50); Left <= 0; Right <= 0; 
		@(posedge CLOCK_50);
		@(posedge CLOCK_50);
		@(posedge CLOCK_50);
		@(posedge CLOCK_50); Left <= 1; Right <= 0; 
		@(posedge CLOCK_50);
		@(posedge CLOCK_50);
		@(posedge CLOCK_50);
		@(posedge CLOCK_50); Left <= 0; Right <= 1; 
		@(posedge CLOCK_50);
		@(posedge CLOCK_50);
		@(posedge CLOCK_50);  

		$stop; // End the simulation
	end
endmodule

