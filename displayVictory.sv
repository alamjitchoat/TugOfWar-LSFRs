module displayVictory (Clock, Reset, L, R, LED1, LED9, HEX0, HEX5, restartGame);
	input logic Clock, Reset;
	input logic L, R, LED1, LED9;
	output logic restartGame;
	
	output logic [6:0] HEX0;
	output logic [6:0] HEX5;
	logic [2:0] p1Count; // represent on hex0
	logic [2:0] p2Count; // represent on hex5
	
	
	// State encoding
	enum {off, P1, P2} ps, ns;
	

// logic to enter correct state based on LED and L/R
	always_comb
	case (ps)
		off: if (LED1 & ~L & R)	ns = P1;
			  else if (LED9 & L & ~R) ns = P2;
			  else     ns = off;
		P1: if (P1)	ns = P1;
		P2: if (P2) ns = P2;
	endcase

	

// logic to display player 1's wins
	always_comb begin
		if (p1Count == 3'b000) begin
			HEX0 = 7'b1000000;  // display 0
		end
		else if (p1Count == 3'b001) begin
			HEX0 = 7'b1111001;  // display 1
		end
		else if (p1Count == 3'b010) begin
			HEX0 = 7'b0100100;  // display 2
		end
		 else if (p1Count == 3'b011) begin
			HEX0 = 7'b0110000;  // display 3
		end
		else if (p1Count == 3'b100) begin
			HEX0 = 7'b0011001;  // display 4
		end
		else if (p1Count == 3'b101) begin
			HEX0 = 7'b0010010;  // display 5
		end
		else if (p1Count == 3'b110) begin
			HEX0 = 7'b0000010;  // display 6
		end
		else if (p1Count == 3'b111) begin
			HEX0 = 7'b1111000; // display 7
		end else begin 
			HEX0 = 7'bX;
		end
end


	always_comb begin
		if (p2Count == 3'b000) begin
			HEX5 = 7'b1000000;  // display 0
		end
		else if (p2Count == 3'b001) begin
			HEX5 = 7'b1111001;  // display 1
		end
		else if (p2Count == 3'b010) begin
			HEX5 = 7'b0100100;  // display 2
		end
		 else if (p2Count == 3'b011) begin
			HEX5 = 7'b0110000;  // display 3
		end
		else if (p2Count == 3'b100) begin
			HEX5 = 7'b0011001;  // display 4
		end
		else if (p2Count == 3'b101) begin
			HEX5 = 7'b0010010;  // display 5
		end
		else if (p2Count == 3'b110) begin
			HEX5 = 7'b0000010;  // display 6
		end
		else if (p2Count == 3'b111) begin
			HEX5 = 7'b1111000; // display 7
		end else begin 
			HEX5 = 7'bX;
		end
end

	
// logic to keep game running and update count
	always_ff @(posedge Clock) begin
		if (Reset) begin
			ps <= off;
			p1Count <= 0;
			p2Count <= 0;
			restartGame <= 0;
		end else if (ps == P1) begin
			p1Count <= p1Count + 1;
			restartGame <= 1;
			ps <= off;
		end else if (ps == P2) begin
			p2Count <= p2Count + 1;
			restartGame <= 1;
			ps <= off;
		end else begin
			ps <= ns;
			restartGame <= 0;
		end	
end



endmodule




module displayVictory_testbench();
	logic Clock, Reset;
	logic L, R, LED1, LED9;
	logic restartGame;
	logic [6:0] HEX0;
	logic [6:0] HEX5;
	logic [2:0] p1Count; 
	logic [2:0] p2Count; 

	displayVictory dut (Clock, Reset, L, R, LED1, LED9, HEX0, HEX5, restartGame);
    
	// Set up the clock
	parameter CLOCK_PERIOD = 100;
	initial begin
    	Clock <= 0;
		forever #(CLOCK_PERIOD/2) Clock <= ~Clock;
	end

	// Set up the inputs to the design. Each line is a clock cycle.
	initial begin
		@(posedge Clock); Reset <= 1; p1Count <= 0; p2Count <= 0;
		@(posedge Clock); Reset <= 0; p1Count <= 0; p2Count <= 0;
		@(posedge Clock);
		@(posedge Clock);
		@(posedge Clock);
		@(posedge Clock); L <= 0; R <= 1; LED1 <= 1; LED9 <= 0; p1Count <= 1; p2Count <= 1;
		@(posedge Clock);           
		@(posedge Clock);            
		@(posedge Clock);
		@(posedge Clock); L <= 1; R <= 0; LED1 <= 0; LED9 <= 1; p1Count <= 0; p2Count <= 0;          
		@(posedge Clock);            
		@(posedge Clock);
		@(posedge Clock); 
		@(posedge Clock); p1Count <= 1; p2Count <= 1;           
		@(posedge Clock);
		@(posedge Clock); 
		@(posedge Clock);            
		@(posedge Clock); p1Count <= 1; p2Count <= 1;
		@(posedge Clock); 
		@(posedge Clock);            
		@(posedge Clock);
		@(posedge Clock); p1Count <= 0; p2Count <= 0;
		@(posedge Clock);            
		@(posedge Clock);
		@(posedge Clock); 
		@(posedge Clock); p1Count <= 1; p2Count <= 1;
		@(posedge Clock);
		@(posedge Clock); 
		@(posedge Clock);
		@(posedge Clock); p1Count <= 0; p2Count <= 0;
		@(posedge Clock);
		@(posedge Clock); 
		@(posedge Clock);
		@(posedge Clock); 		
		@(posedge Clock); p1Count <= 1; p2Count <= 1;
		@(posedge Clock);
		@(posedge Clock); 
		@(posedge Clock); p1Count <= 0; p2Count <= 0;
		@(posedge Clock); 
		@(posedge Clock);
		@(posedge Clock); 
		@(posedge Clock);p1Count <= 1; p2Count <= 1;
		@(posedge Clock);
		@(posedge Clock); 
		@(posedge Clock);
		@(posedge Clock); p1Count <= 0; p2Count <= 0;
		@(posedge Clock); 
		@(posedge Clock);
		@(posedge Clock);
		@(posedge Clock); p1Count <= 1; p2Count <= 1;
		@(posedge Clock);
		@(posedge Clock);
		@(posedge Clock); 
		@(posedge Clock);p1Count <= 0; p2Count <= 0;
		@(posedge Clock);
		@(posedge Clock); 
		@(posedge Clock);
		@(posedge Clock); p1Count <= 1; p2Count <= 1;
		@(posedge Clock);
		@(posedge Clock); 
		@(posedge Clock);
		@(posedge Clock); p1Count <= 1; p2Count <= 1;
		@(posedge Clock); 
		@(posedge Clock); Reset <= 1;
		@(posedge Clock); 
		@(posedge Clock);

		$stop; // End the simulation
	end
endmodule