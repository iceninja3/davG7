module paddle #(parameter DY, TOP_BOUNDARY, BOTTOM_BOUNDARY, YBIT_WIDTH) 
(
    //need an input for initial position of the paddle at start of game (left or right)
input logic clk, rst, btn, xPos
// btn is associated with a specific user and is assigned in top module

output [YBIT_WIDTH:0] yPos,
//output [10:0] xPos
);


always_ff @(posedge ck) begin
    if(reset) begin
        yPos <= 240;
        //reset paddle to center of some screen. hmmm how to do this for left and right paddle though?
    end
    else if (yPos == TOP_BOUNDARY || yPos = BOTTOM_BOUNDARY)begin
        //yPos <= yPos;
    end
    else begin
        yPos <= yPos + btn*DY;
    end
end

// make sure paddle doesn't go off of screen with boundary checking
// make sure 


endmodule

// in top module instantiate this module two times for two paddles