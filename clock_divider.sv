module clock_divider #(parameter BASE_SPEED = 50000000) (input logic clk, input logic[19:0] speed, input logic reset, output logic outClk);
		
		// BASE_SPEED and speed are both in Hz
		// Lowest possible output frequency is 1 Hz
		// Maximum possible output frequency is 1 MHz
		
		localparam counterBits = $clog2(BASE_SPEED);
		logic[(counterBits-1):0] counter;
		logic newClk, rstTrigger, counterRst;
		logic[3:0] shiftReg;
		
		always @(posedge clk)
		begin
			if (shiftReg == 4'b1111) 
			begin 
				rstTrigger <= 1;
				counter <= 0;
			end
			else if (counterRst)
			begin
				rstTrigger <= 0;
				counter <= 0;
			end
			else 
			begin 
				rstTrigger <= 0;
				counter <= counter + 1; 
			end
			shiftReg <= {shiftReg[2:0], reset};
		end
		
		
		always_comb
		begin
			if (rstTrigger) 
			begin 
				newClk = 1'b0; 
				counterRst = 1'b0;
			end
			else if (speed == 0) 
			begin 
				newClk = 1'b0; 
				counterRst = 1'b0;
			end
			else if (counter <= ((BASE_SPEED / speed) / 2))
			begin
				newClk = 1'b0;
				counterRst = 1'b0;
			end
			else if (counter <= (BASE_SPEED / speed)) 
			begin 
				newClk = 1'b1; 
				counterRst = 1'b0;
			end
			else 
			begin 
				newClk = 1'b0;
				counterRst = 1'b1;
			end
		end
		
		assign outClk = newClk;
		
endmodule
			