module graphics_driver
    (
        input logic[9:0] hc,
        input logic[9:0] vc,
        
        output logic[9:0] addressOut,
        output logic[7:0] color
    );
    
    localparam HPIXELS = 32;
    localparam BLOCKING_FACTOR = 20;
    localparam BLK = 8'h00;
    localparam WHT = 8'hff;

    logic [9:0] address;

    assign addressOut = address;
    assign address = (vc / BLOCKING_FACTOR) * HPIXELS + (hc / BLOCKING_FACTOR);
    assign color = test_sprite[address];
    logic [7:0] test_sprite [0:767] = '{ 
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

    
endmodule