`timescale 1ns/1ps

module top (
    // 16MHz clock
    input CLK,

    // USB pull-up resistor
    output USBPU,

    // GPIO Outputs.
    output PIN_8,
    output PIN_9,
    output PIN_10,
    // output PIN_11,  Pin looks to be dead.
    output PIN_12,
    output PIN_13,

    // GPIO Inputs.
    input PIN_1,
    input PIN_2,
    input PIN_3,
    input PIN_4,
    input PIN_5,
    input PIN_6,
    input PIN_7,
    input PIN_14,
    input PIN_15,
    input PIN_16,
    input PIN_17,
    input PIN_18,
    input PIN_19,
    input PIN_20,
    input PIN_21,
    input PIN_22,
    input PIN_23,
    input PIN_24
);

    // drive USB pull-up resistor to '0' to disable USB
    assign USBPU = 0;

    // VGA output signals.
    wire clk_20mhz;
    assign PIN_8 = red;
    assign PIN_9 = green;
    assign PIN_10 = blue;
    assign PIN_12 = h_sync;
    assign PIN_13 = v_sync;

    reg [10:0] h_counter;
    reg [0:0] h_sync;

    reg [9:0] v_counter;
    reg [0:0] v_sync;

    reg [0:0] red;
    reg [0:0] green;
    reg [0:0] blue;

    // Interrupt input.
    wire interrupt;
    assign interrupt = PIN_24;

    // Address inputs.
    wire a0;
    wire a1;
    wire a2;
    wire a3;
    wire a4;
    wire a5;
    wire a6;
    wire a7;
    wire a8;
    wire a9;
    wire a10;

    assign a0 = PIN_1;
    assign a1 = PIN_2;
    assign a2 = PIN_3;
    assign a3 = PIN_4;
    assign a4 = PIN_5;
    assign a5 = PIN_6;
    assign a6 = PIN_7;
    assign a7 = PIN_14;
    assign a8 = PIN_15;
    assign a9 = PIN_16;
    assign a10 = PIN_17;

    // Character inputs.
    wire char_in_0;
    wire char_in_1;
    wire char_in_2;
    wire char_in_3;
    wire char_in_4;
    wire char_in_5;

    assign char_in_0 = PIN_18;
    assign char_in_1 = PIN_19;
    assign char_in_2 = PIN_20;
    assign char_in_3 = PIN_21;
    assign char_in_4 = PIN_22;
    assign char_in_5 = PIN_23;


    // Create a 20MHz clock.
    // http://martin.hinner.info/vga/timing.html
    // 40 MHz = 800x600@60Hz
    SB_PLL40_CORE #(
      .DIVR(0),
      .DIVF(19),
      .DIVQ(4),
      .FILTER_RANGE(3'b001),
      .FEEDBACK_PATH("SIMPLE"),
      .DELAY_ADJUSTMENT_MODE_FEEDBACK("FIXED"),
      .FDA_FEEDBACK(4'b0000),
      .DELAY_ADJUSTMENT_MODE_RELATIVE("FIXED"),
      .FDA_RELATIVE(4'b0000),
      .SHIFTREG_DIV_MODE(2'b00),
      .PLLOUT_SELECT("GENCLK"),
      .ENABLE_ICEGATE(1'b0)
    ) pll (
      .REFERENCECLK(CLK),
      .PLLOUTCORE(clk_20mhz),
      .RESETB(1'b1),
      .BYPASS(1'b0)
    );

    reg [79:0] char_set [0:60];
    reg [5:0] char_display [0:1500];

    integer i;

    initial begin
      h_counter <= 0;
      v_counter <= 0;

      h_sync <= 0;
      v_sync <= 0;
      red <= 0;
      green <= 0;
      blue <= 0;

      // Predefined character set.
      char_set[0] <= 80'b00000000011001100110011001111110011111100110011001100110001111000001100000000000; // A
      char_set[1] <= 80'b00000000001111100110011001100110011001100011111001100110011001100011111000000000; // B
      char_set[2] <= 80'b00000000001111000110011000000110000001100000011000000110011001100011110000000000; // C
      char_set[3] <= 80'b00000000000111100011011001100110011001100110011001100110001101100001111000000000; // D
      char_set[4] <= 80'b00000000011111100000011000000110000001100011111000000110000001100111111000000000; // E
      char_set[5] <= 80'b00000000000001100000011000000110000001100011111000000110000001100111111000000000; // F
      char_set[6] <= 80'b00000000011111000110011001100110011101100000011000000110000001100111110000000000; // G
      char_set[7] <= 80'b00000000011001100110011001100110011111100111111001100110011001100110011000000000; // H
      char_set[8] <= 80'b00000000011111100001100000011000000110000001100000011000000110000111111000000000; // I
      char_set[9] <= 80'b00000000001111000110011001100110011000000110000001100000011000000110000000000000; // J
      char_set[10] <= 80'b00000000011001100110011000110110000111100001111000110110011001100110011000000000; // K
      char_set[11] <= 80'b00000000011111100000011000000110000001100000011000000110000001100000011000000000; // L
      char_set[12] <= 80'b00000000010000100100001001000010010000100101101001111110011001100100001000000000; // M
      char_set[13] <= 80'b00000000010000100110001001110010011110100101111001001110010001100100001000000000; // N
      char_set[14] <= 80'b00000000001111000110011001100110011001100110011001100110011001100011110000000000; // O
      char_set[15] <= 80'b00000000000001100000011000000110000001100011111001100110011001100011111000000000; // P
      char_set[16] <= 80'b00000000011011000001011001100110011001100110011001100110011001100011110000000000; // Q
      char_set[17] <= 80'b00000000011001100110011001100110001101100011111001100110011001100011111000000000; // R
      char_set[18] <= 80'b00000000001111000110001001100000011000000011110000000010010000100011110000000000; // S
      char_set[19] <= 80'b00000000000110000001100000011000000110000001100000011000011111100111111000000000; // T
      char_set[20] <= 80'b00000000011111100111111001100110011001100110011001100110011001100110011000000000; // U
      char_set[21] <= 80'b00000000000110000011110001111110011001100110011001100110011001100110011000000000; // V
      char_set[22] <= 80'b00000000010001100110111001111110010101100100011001000110010001100100011000000000; // W
      char_set[23] <= 80'b00000000011001100110011001111110000110000001100001111110011001100110011000000000; // X
      char_set[24] <= 80'b00000000000110000001100000011000000110000111111001100110011001100110011000000000; // Y
      char_set[25] <= 80'b00000000011111100000011000001100000110000001100000110000011000000111111000000000; // Z
      char_set[26] <= 80'b00000000001111000110011001100110011011100111011001100110011001100011110000000000; // 0
      char_set[27] <= 80'b00000000011111100111111000011000000110000001100000011100000111100001100000000000; // 1
      char_set[28] <= 80'b00000000011111100000011000000100000010000001000001100000010000100011110000000000; // 2
      char_set[29] <= 80'b00000000000111000010001001100000001100000001100000010000001000000111111000000000; // 3
      char_set[30] <= 80'b00000000001100000011000001111110011111100011011000111100001110000011000000000000; // 4
      char_set[31] <= 80'b00000000001111000110011001100000011000000011111000000110000001100111111000000000; // 5
      char_set[32] <= 80'b00000000001111000110011001100110011001100011111000000110000001100011110000000000; // 6
      char_set[33] <= 80'b00000000000011000000110000011000000110000011000000110000011000000111111000000000; // 7
      char_set[34] <= 80'b00000000001111000100001001000010001111000100001001000010010000100011110000000000; // 8
      char_set[35] <= 80'b00000000001111000110001001100000011000000111110001000010010000100011110000000000; // 9
      char_set[36] <= 80'b00000000000110000001100000000000000000000000000000000000000000000000000000000000; // .
      char_set[37] <= 80'b00000000000110000011000000110000000000000000000000000000000000000000000000000000; // ,
      char_set[38] <= 80'b00000000000110000001100000000000000110000001100000011000000110000001100000000000; // !
      char_set[39] <= 80'b00000000000000000000000000000000000000000000000001100110011001100110011000000000; // "
      char_set[40] <= 80'b00000000001001000111111001111110001001000010010001111110011111100010010000000000; // #
      char_set[41] <= 80'b00011000001111000101101001011000010110000011110000011010010110100011110000011000; // $
      char_set[42] <= 80'b00000000001110000001110000000110000001100000011000000110000111000011100000000000; // (
      char_set[43] <= 80'b00000000000111000011100001100000011000000110000001100000001110000001110000000000; // )
      char_set[44] <= 80'b00000000000000000001100000011000011111100111111000011000000110000000000000000000; // +
      char_set[45] <= 80'b00000000000000000000000000000000011111100111111000000000000000000000000000000000; // -
      char_set[46] <= 80'b00000000011001100110011000111100011111100111111000111100011001100110011000000000; // *
      char_set[47] <= 80'b00000000000001100000010000001100000010000001100000110000001000000110000000000000; // /
      char_set[48] <= 80'b00000000000000000000000000000000000000000000000000011000000110000001100000000000; // '
      char_set[49] <= 80'b00000000000000000001100000011000000000000000000000011000000110000000000000000000; // :
      char_set[50] <= 80'b00000000000011000001100000011000000000000000000000011000000110000000000000000000; // ;
      char_set[51] <= 80'b00000000000000000111111001111110000000000000000001111110011111100000000000000000; // =
      char_set[52] <= 80'b00000000011111000000001000111010011110100111101001111010010000100011110000000000; // @
      char_set[53] <= 80'b00000000000011000000000000011100001100000110000001100000011001100011110000000000; // ?
      char_set[54] <= 80'b00000000000001100110110001101000000110000001000000110110001001100110000000000000; // %
      char_set[55] <= 80'b00000000000000000000000000000000000000000100001001100110001111000001100000000000; // ^
      char_set[56] <= 80'b00000000011111100111111001111110011111100111111001111110011111100111111000000000; // cursor
      char_set[57] <= 80'b00000000000000000000000000000000000000000000000000000000000000000000000000000000; // blank
      char_set[58] <= 80'b11111111111111111111111111111111111111111111111111111111111111111111111111111111; // filled in
      char_set[59] <= 80'b00000000011001100110011001111110011111100110011001100110001111000001100000000000; // A

      // Blank out display.
      for( i = 0; i < 1500; i = i + 1 )
      begin
        char_display[i] <= 57;
      end

      // Add border.
      for( i = 0; i < 50; i = i + 1 ) // Top.
      begin
        char_display[i] <= 58;
      end
      for( i = 1450; i < 1500; i = i + 1 ) // Bottom.
      begin
        char_display[i] <= 58;
      end
      for( i = 50; i < 1450; i = i + 50 ) // Left.
      begin
        char_display[i] <= 58;
      end
      for( i = 49; i < 1450; i = i + 50 ) // Right.
      begin
        char_display[i] <= 58;
      end

    end

    ////
    // Generate VGA signal.
    ////

    reg [10:0] char_num;
    reg [10:0] h_idx;
    reg [10:0] v_idx;

    always @(posedge clk_20mhz) begin
      // Horitonal sync.
      if (h_counter > 421 && h_counter < 485)
      begin
        h_sync <= 1;
      end else begin
        h_sync <= 0;
      end

      // Vertical sync.
      if (v_counter > 600 && v_counter < 605)
      begin
        v_sync <= 1;
      end else begin
        v_sync <= 0;
      end

      // Display pixel.
      if (h_counter > 399 || v_counter > 599)  // Horizontal/vertical blanking.
    	begin
    	  red <= 0;
        green <= 0;
        blue <= 0;
    	end else // Active video.
      begin
        // Which character position (on screen) are we at.
        char_num <= (h_counter / 8) + (50 * (v_counter / 20));

        // What is the horizontal index into the current character?
        h_idx <= h_counter % 8;

        // What is the vertical index into the current character?
        v_idx <= (v_counter % 20) / 2;

        // Pixel color if not part of character.
        red <= 0;
        green <= 0;
        blue <= 1;

        // If the current position in the current character is '1', change the color.
        if (char_set[char_display[char_num]][h_idx + (v_idx * 8)] == 1'b1)
        begin
          green <= 1;
          blue <= 1;
        end
      end

      // Increment / reset counters.
      h_counter <= h_counter + 1'b1;

      if (h_counter == 528)
      begin
        h_counter <= 0;
        v_counter <= v_counter + 1'b1;
      end

      if (v_counter == 628)
      begin
        v_counter <= 0;
      end
    end

    ////
    // Load character data into memory.
    ////

    wire [10:0] screen_position;
    wire [5:0] char_selection;

    wire [5:0] column;
    wire [4:0] row;

    assign column = {a5, a4, a3, a2, a1, a0};
    assign row = {a10, a9, a8, a7, a6};
    assign screen_position = (row * 50) + column;
    assign char_selection = {char_in_5, char_in_4, char_in_3, char_in_2, char_in_1, char_in_0};

    always @(negedge clk_20mhz) begin
      if (interrupt) begin
        char_display[screen_position] <= char_selection;
      end
    end

endmodule
