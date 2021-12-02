module centerLight (Clock, Reset, L, R, NL, NR, lightOn, restartGame);
	input logic Clock, Reset;
	
	// L - True when left key (KEY[3]) is pressed
	// R - True when right key (KEY[0]) is pressed
	// NL - True when the light to the left of this one is ON
	// NR - True when the light on the right of this one is ON
	input logic L, R, NL, NR, restartGame;
	
	// lightOn – True when this normal light should be ON/lit
	output logic lightOn;
	
	// YOUR CODE GOES HERE
	logic ps; // Present State
	logic ns; // Next State

	// State encoding
	parameter lit = 1'b1, notLit = 1'b0;

	// Next State logic
	always_comb
		case (ps)
			lit: if ((L & ~R) | (~L & R))	ns = notLit;
				else		ns = lit;
			notLit: if ((NR & L & ~R) | (NL & R) & ~L)	ns = lit;
				else		ns = notLit;
		endcase

	// Output logic - could also be another always, or part of above block
	assign lightOn = ps;

	// DFFs
	always_ff @(posedge Clock)
		if (Reset | restartGame)
			ps <= lit;
		else
			ps <= ns;

endmodule

module centerLight_testbench();
	logic L, R, NL, NR;
	logic lightOn;
	logic Clock, Reset;

	centerLight dut (Clock, Reset, L, R, NL, NR, lightOn);
    
	// Set up the clock
	parameter CLOCK_PERIOD = 100;
	initial begin
    	Clock <= 0;
		forever #(CLOCK_PERIOD/2) Clock <= ~Clock;
	end

	// Set up the inputs to the design. Each line is a clock cycle.
	initial begin
		@(posedge Clock); Reset <= 1;
		@(posedge Clock); Reset <= 0; 
		@(posedge Clock);
		@(posedge Clock);
		@(posedge Clock);
		@(posedge Clock); L <= 1; R <= 0; NL <= 0; NR <= 0;
		@(posedge Clock);           
		@(posedge Clock);            
		@(posedge Clock);
		@(posedge Clock); L <= 0; R <= 1; NL <= 0; NR <= 0;
		@(posedge Clock);           
		@(posedge Clock);            
		@(posedge Clock);
		@(posedge Clock); L <= 1; R <= 0; NL <= 0; NR <= 1;
		@(posedge Clock);           
		@(posedge Clock);            
		@(posedge Clock);
		@(posedge Clock); L <= 0; R <= 1; NL <= 1; NR <= 0;
		@(posedge Clock);           
		@(posedge Clock);            
		@(posedge Clock);

		$stop; // End the simulation
	end
endmodule
	
	