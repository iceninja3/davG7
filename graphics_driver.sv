module graphics_driver #(YBIT_WIDTH, XBIT_WIDTH)
    (
        input logic[9:0] hc,
        input logic[9:0] vc,
        input logic[6:0] score,
        input logic[XBIT_WIDTH:0] paddle1_x,
        input logic[YBIT_WIDTH:0] paddle1_y,
        input logic[XBIT_WIDTH:0] paddle2_x,
        input logic[YBIT_WIDTH:0] paddle2_y,
        input logic[XBIT_WIDTH:0] ball_x,
        input logic[YBIT_WIDTH:0] ball_y,

        
        output logic[9:0] addressOut,
        output logic[7:0] color
    );

    
function integer max(input integer a, input integer b);
        begin
            pos = a + 32*b;
        end
 endfunction
    
    localparam HPIXELS = 32;
    localparam BLOCKING_FACTOR = 20;
    localparam BLK = 8'h00;
    localparam WHT = 8'hff;

    logic [9:0] address;

    assign addressOut = address;
    assign address = (vc / BLOCKING_FACTOR) * HPIXELS + (hc / BLOCKING_FACTOR);
    assign color = test_sprite[address];
    logic [7:0] test_sprite [0:767] = '{ //(0-31)x(0-23) -> general conversion: (a, b) -> (a+32*b)
    //  0       1       2      3      4      5      6      7      8      9      10     11     12     13     14     15     16     17     18     19     20     21     22     23      24      25      26     27     28     29     30     31      
        BLK,    BLK,    BLK,   BLK,   BLK,   BLK,   BLK,   BLK,   BLK,   BLK,   BLK,   BLK,   BLK,   BLK,   BLK,   WHT,   WHT,   BLK,   BLK,   BLK,   BLK,   BLK,   BLK,   BLK,    BLK,    BLK,    BLK,   BLK,   BLK,   BLK,   BLK,   BLK,   // 0
        BLK,    BLK,    BLK,   BLK,   BLK,   BLK,   BLK,   BLK,   BLK,   BLK,   BLK,   BLK,   BLK,   BLK,   BLK,   WHT,   WHT,   BLK,   BLK,   BLK,   BLK,   BLK,   BLK,   BLK,    BLK,    BLK,    BLK,   BLK,   BLK,   BLK,   BLK,   BLK,   // 1
        BLK,    BLK,    BLK,   BLK,   BLK,   BLK,   BLK,   BLK,   BLK,   BLK,   BLK,   BLK,   BLK,   BLK,   BLK,   WHT,   WHT,   BLK,   BLK,   BLK,   BLK,   BLK,   BLK,   BLK,    BLK,    BLK,    BLK,   BLK,   BLK,   BLK,   BLK,   BLK,   // 2
        BLK,    BLK,    BLK,   BLK,   BLK,   BLK,   BLK,   BLK,   BLK,   BLK,   BLK,   BLK,   BLK,   BLK,   BLK,   WHT,   WHT,   BLK,   BLK,   BLK,   BLK,   BLK,   BLK,   BLK,    BLK,    BLK,    BLK,   BLK,   BLK,   BLK,   BLK,   BLK,   // 3
        BLK,    BLK,    BLK,   BLK,   BLK,   BLK,   BLK,   BLK,   BLK,   BLK,   BLK,   BLK,   BLK,   BLK,   BLK,   WHT,   WHT,   BLK,   BLK,   BLK,   BLK,   BLK,   BLK,   BLK,    BLK,    BLK,    BLK,   BLK,   BLK,   BLK,   BLK,   BLK,   // 4
        BLK,    BLK,    BLK,   BLK,   BLK,   BLK,   BLK,   BLK,   BLK,   BLK,   BLK,   BLK,   BLK,   BLK,   BLK,   WHT,   WHT,   BLK,   BLK,   BLK,   BLK,   BLK,   BLK,   BLK,    BLK,    BLK,    BLK,   BLK,   BLK,   BLK,   BLK,   BLK,   // 5
        BLK,    BLK,    BLK,   BLK,   BLK,   BLK,   BLK,   BLK,   BLK,   BLK,   BLK,   BLK,   BLK,   BLK,   BLK,   WHT,   WHT,   BLK,   BLK,   BLK,   BLK,   BLK,   BLK,   BLK,    BLK,    BLK,    BLK,   BLK,   BLK,   BLK,   BLK,   BLK,   // 6
        BLK,    BLK,    BLK,   BLK,   BLK,   BLK,   BLK,   BLK,   BLK,   BLK,   BLK,   BLK,   BLK,   BLK,   BLK,   WHT,   WHT,   BLK,   BLK,   BLK,   BLK,   BLK,   BLK,   BLK,    BLK,    BLK,    BLK,   BLK,   BLK,   BLK,   BLK,   BLK,   // 7
        BLK,    BLK,    BLK,   BLK,   BLK,   BLK,   BLK,   BLK,   BLK,   BLK,   BLK,   BLK,   BLK,   BLK,   BLK,   WHT,   WHT,   BLK,   BLK,   BLK,   BLK,   BLK,   BLK,   BLK,    BLK,    BLK,    BLK,   BLK,   BLK,   BLK,   BLK,   BLK,   // 8
        BLK,    BLK,    BLK,   BLK,   BLK,   BLK,   BLK,   BLK,   BLK,   BLK,   BLK,   BLK,   BLK,   BLK,   BLK,   WHT,   WHT,   BLK,   BLK,   BLK,   BLK,   BLK,   BLK,   BLK,    BLK,    BLK,    BLK,   BLK,   BLK,   BLK,   BLK,   BLK,   // 9
        BLK,    BLK,    BLK,   BLK,   BLK,   BLK,   BLK,   BLK,   BLK,   BLK,   BLK,   BLK,   BLK,   BLK,   BLK,   WHT,   WHT,   BLK,   BLK,   BLK,   BLK,   BLK,   BLK,   BLK,    BLK,    BLK,    BLK,   BLK,   BLK,   BLK,   BLK,   BLK,   // 10
        BLK,    BLK,    BLK,   BLK,   BLK,   BLK,   BLK,   BLK,   BLK,   BLK,   BLK,   BLK,   BLK,   BLK,   BLK,   WHT,   WHT,   BLK,   BLK,   BLK,   BLK,   BLK,   BLK,   BLK,    BLK,    BLK,    BLK,   BLK,   BLK,   BLK,   BLK,   BLK,   // 11
        BLK,    BLK,    BLK,   BLK,   BLK,   BLK,   BLK,   BLK,   BLK,   BLK,   BLK,   BLK,   BLK,   BLK,   BLK,   WHT,   WHT,   BLK,   BLK,   BLK,   BLK,   BLK,   BLK,   BLK,    BLK,    BLK,    BLK,   BLK,   BLK,   BLK,   BLK,   BLK,   // 12
        BLK,    BLK,    BLK,   BLK,   BLK,   BLK,   BLK,   BLK,   BLK,   BLK,   BLK,   BLK,   BLK,   BLK,   BLK,   WHT,   WHT,   BLK,   BLK,   BLK,   BLK,   BLK,   BLK,   BLK,    BLK,    BLK,    BLK,   BLK,   BLK,   BLK,   BLK,   BLK,   // 13
        BLK,    BLK,    BLK,   BLK,   BLK,   BLK,   BLK,   BLK,   BLK,   BLK,   BLK,   BLK,   BLK,   BLK,   BLK,   WHT,   WHT,   BLK,   BLK,   BLK,   BLK,   BLK,   BLK,   BLK,    BLK,    BLK,    BLK,   BLK,   BLK,   BLK,   BLK,   BLK,   // 14
        BLK,    BLK,    BLK,   BLK,   BLK,   BLK,   BLK,   BLK,   BLK,   BLK,   BLK,   BLK,   BLK,   BLK,   BLK,   WHT,   WHT,   BLK,   BLK,   BLK,   BLK,   BLK,   BLK,   BLK,    BLK,    BLK,    BLK,   BLK,   BLK,   BLK,   BLK,   BLK,   // 15
        BLK,    BLK,    BLK,   BLK,   BLK,   BLK,   BLK,   BLK,   BLK,   BLK,   BLK,   BLK,   BLK,   BLK,   BLK,   WHT,   WHT,   BLK,   BLK,   BLK,   BLK,   BLK,   BLK,   BLK,    BLK,    BLK,    BLK,   BLK,   BLK,   BLK,   BLK,   BLK,   // 16
        BLK,    BLK,    BLK,   BLK,   BLK,   BLK,   BLK,   BLK,   BLK,   BLK,   BLK,   BLK,   BLK,   BLK,   BLK,   WHT,   WHT,   BLK,   BLK,   BLK,   BLK,   BLK,   BLK,   BLK,    BLK,    BLK,    BLK,   BLK,   BLK,   BLK,   BLK,   BLK,   // 17
        BLK,    BLK,    BLK,   BLK,   BLK,   BLK,   BLK,   BLK,   BLK,   BLK,   BLK,   BLK,   BLK,   BLK,   BLK,   WHT,   WHT,   BLK,   BLK,   BLK,   BLK,   BLK,   BLK,   BLK,    BLK,    BLK,    BLK,   BLK,   BLK,   BLK,   BLK,   BLK,   // 18
        BLK,    BLK,    BLK,   BLK,   BLK,   BLK,   BLK,   BLK,   BLK,   BLK,   BLK,   BLK,   BLK,   BLK,   BLK,   WHT,   WHT,   BLK,   BLK,   BLK,   BLK,   BLK,   BLK,   BLK,    BLK,    BLK,    BLK,   BLK,   BLK,   BLK,   BLK,   BLK,   // 19
        BLK,    BLK,    BLK,   BLK,   BLK,   BLK,   BLK,   BLK,   BLK,   BLK,   BLK,   BLK,   BLK,   BLK,   BLK,   WHT,   WHT,   BLK,   BLK,   BLK,   BLK,   BLK,   BLK,   BLK,    BLK,    BLK,    BLK,   BLK,   BLK,   BLK,   BLK,   BLK,   // 20
        BLK,    BLK,    BLK,   BLK,   BLK,   BLK,   BLK,   BLK,   BLK,   BLK,   BLK,   BLK,   BLK,   BLK,   BLK,   WHT,   WHT,   BLK,   BLK,   BLK,   BLK,   BLK,   BLK,   BLK,    BLK,    BLK,    BLK,   BLK,   BLK,   BLK,   BLK,   BLK,   // 21
        BLK,    BLK,    BLK,   BLK,   BLK,   BLK,   BLK,   BLK,   BLK,   BLK,   BLK,   BLK,   BLK,   BLK,   BLK,   WHT,   WHT,   BLK,   BLK,   BLK,   BLK,   BLK,   BLK,   BLK,    BLK,    BLK,    BLK,   BLK,   BLK,   BLK,   BLK,   BLK,   // 22
        BLK,    BLK,    BLK,   BLK,   BLK,   BLK,   BLK,   BLK,   BLK,   BLK,   BLK,   BLK,   BLK,   BLK,   BLK,   WHT,   WHT,   BLK,   BLK,   BLK,   BLK,   BLK,   BLK,   BLK,    BLK,    BLK,    BLK,   BLK,   BLK,   BLK,   BLK,   BLK    // 23
    };

    reg first_col = 13;

    always @(score) begin
    //which blocks should be the blocks to display score? PUT HERE
    //we decided each player will have two digits to represent their score
    // reminder: since max score is 99 have the game go to a game ended page with a winner (FSM-like) when a score >99 is reached
    // We should split each score to be displayed into two separate digits:
        // - Do [score%10] for the one's digit
        // - Do [score-(score%10)] for the ten's digit
        case (score%10) // one's digit
            1: // (13, 1), (13, 2), (13, 3), (13, 4), (13, 5) 
            begin
                test_sprite[45:60] = WHT;
            end
            2: begin // (11, 1), (12, 1), (13, 1), (13, 2), (11, 3), (12, 3), (13, 3), (11, 4), (11, 5), (12, 5), (13, 5)
                
                
                test_sprite[11+32]=WHT;
                test_sprite[12+32]=WHT;
                test_sprite[13+32]=WHT;
                test_sprite[13+2*32]=WHT;
                test_sprite[11+3*32]=WHT;
                test_sprite[12+3*32]=WHT;
                test_sprite[13+3*32]=WHT;
                test_sprite[11+4*32]=WHT;
                test_sprite[11+5*32]=WHT;
                test_sprite[12+5*32]=WHT;
                test_sprite[13+5*32]=WHT;
            end

            3: begin // (11, 1), (12, 1), (13, 1), (13, 2), (11, 3), (12, 3), (13, 3), (13, 4), (11, 5), (12, 5), (13, 5) //11
                test_sprite[11+32]=WHT;
                test_sprite[12+32]=WHT;
                test_sprite[13+32]=WHT;
                test_sprite[13+2*32]=WHT;
                test_sprite[11+3*32]=WHT;
                test_sprite[12+3*32]=WHT;
                test_sprite[13+3*32]=WHT;
                test_sprite[13+4*32]=WHT;
                test_sprite[11+5*32]=WHT;
                test_sprite[12+5*32]=WHT;
                test_sprite[13+5*32]=WHT;
                //11
            end

            4: begin// (11, 1), (13, 1), (11, 2), (13, 2), (11, 3), (12, 3), (13, 3), (13, 4), (13, 5) //9
                test_sprite[11+32]=WHT;
                test_sprite[13+32]=WHT;
                test_sprite[11+2*32]=WHT;
                test_sprite[13+2*32]=WHT;
                test_sprite[11+3*32]=WHT;
                test_sprite[12+3*32]=WHT;
                test_sprite[13+3*32]=WHT;
                test_sprite[13+4*32]=WHT;
                test_sprite[13+5*32]=WHT;
            end
            
            5: begin // (11, 1), (12, 1), (13, 1), (11, 2), (11, 3), (12, 3), (13, 3), (13, 4), (11, 5), (12, 5), (13, 5) //11
                test_sprite[11+32]=WHT;
                test_sprite[12+32]=WHT;
                test_sprite[13+32]=WHT;
                test_sprite[11+2*32]=WHT;
                test_sprite[11+3*32]=WHT;
                test_sprite[12+3*32]=WHT;
                test_sprite[13+3*32]=WHT;
                test_sprite[13+4*32]=WHT;
                test_sprite[11+5*32]=WHT;
                test_sprite[12+5*32]=WHT;
                test_sprite[13+5*32]=WHT;          
            end

            6: // (11, 1), (12, 1), (13, 1), (11, 2), (11, 3), (12, 3), (13, 3), (11, 4), (13, 4), (11, 5), (12, 5), (13, 5)
            7: // (11, 1), (12, 1), (13, 1), (13, 2), (13, 3), (13, 4), (13, 5) 
            8: // (11, 1), (12, 1), (13, 1), (11, 2), (13, 2), (11, 3), (12, 3), (13, 3), (11, 4), (13, 4), (11, 5), (12, 5), (13, 5)
            9: // (11, 1), (12, 1), (13, 1), (11, 2), (13, 2), (11, 3), (12, 3), (13, 3), (13, 4), (13, 5)
        case (score-(score%10)) // ten's digit
            1: 
                
            2:
            3:
            4: 
            5:
            6:
            7:
            8:
            9:
    end
    
    always @(paddle1_x) {

    }
endmodule


