module paddle #(parameter DY, TOP_BOUNDARY, BOTTOM_BOUNDARY, YBIT_WIDTH) 
(
    //TODO: need an input for initial position of the paddle at start of game (left or right) instead of hardcoding at 240
input logic clk, 
input logic rst, 
input logic[1:0] btn,
input logic [YBIT_WIDTH:0] xPos,
// btn is associated with a specific user and is assigned in top module

output logic [YBIT_WIDTH:0] yPos
//output [10:0] xPos
);


always_ff @(posedge clk) begin

    if(rst) begin
        yPos <= 240;
        //reset paddle to center of some screen. hmmm how to do this for left and right paddle though?
    end
    else if (yPos == TOP_BOUNDARY || yPos == BOTTOM_BOUNDARY) begin
        yPos <= yPos;
    end
    else if (btn == 1) begin
        yPos <= yPos + DY;
    end
    else if (btn == 2) begin
        yPos <= yPos - DY;
    end

end

// make sure paddle doesn't go off of screen with boundary checking
// make sure 


endmodule

// in top module instantiate this module two times for two paddles