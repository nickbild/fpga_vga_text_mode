# MiniVGA Text Mode

MiniVGA Text Mode generates a 400x300 @ 60Hz 3-bit color VGA signal, addressable as a 50x30 matrix of characters.  The interface is simple and can be controlled by GPIO from any number of devices, such as Arduino microcontroller dev boards or custom built retro computers.

This work builds on [MiniVGA](https://github.com/nickbild/fpga_vga), which is a 200x150 individual pixel-level addressable VGA generator, which in turn is an alternative to the massive [Vectron VGA](https://github.com/nickbild/vectron_vga) VGA generator which was built from 7400-series logic chips.

By using a text mode interface, memory and processing requirements are greatly reduced, which is critical when these resources are limited.

## How It Works

A TinyFPGA BX has been [programmed](https://github.com/nickbild/fpga_vga_text_mode/blob/main/top.v) to generate an 800x600 @ 60Hz VGA signal.  Each pixel is repeated 2 times horizontally and vertically to yield a resolution of 400x300 pixels.  This space is divided into 50x30 characters of 8x10 pixels each.  A set of 59 characters has been pre-defined, and is easily extensible.

The interface consists of an 11 bit address bus, 6 bit data bus, and an interrupt/latch signal.  To write a character on screen, set the desired address on the address bus (top left character = 0; bottom right pixel = 1,499), and set the code of the pre-defined character (see [top.v](https://github.com/nickbild/fpga_vga_text_mode/blob/main/top.v)) on the data bus.  Writing logic 1 to the interrupt will draw the character on screen.

To extend the character set, create a 8x10 binary matrix such as this:
![char_map](https://raw.githubusercontent.com/nickbild/fpga_vga_text_mode/main/media/char_map.png)

The numbers shown above are the bit positions (0=least significant, 79=most significant).  A `1` is used to specify the character pattern, a `0` is background.  Add the bit strings to the `char_set` register array in [top.v](https://github.com/nickbild/fpga_vga_text_mode/blob/main/top.v).

To demonstrate the functionality, I have written some example [Arduino code available here](https://github.com/nickbild/fpga_vga_text_mode/tree/main/arduino_example).

## Media

Example screenshot:
![MiniVGA](https://raw.githubusercontent.com/nickbild/fpga_vga_text_mode/main/media/screen_sm.jpg)

TinyFPGA BX and Arduino, angle:
![MiniVGA](https://raw.githubusercontent.com/nickbild/fpga_vga_text_mode/main/media/angle_sm.jpg)

TinyFPGA BX and Arduino, top:
![MiniVGA](https://raw.githubusercontent.com/nickbild/fpga_vga_text_mode/main/media/top_sm.jpg)

## Bill of Materials

- 1 x TinyFPGA BX
- 1 x Arduino Mega2560 (or retro computer, or anything else with 18+ GPIOs.)
- 1 x VGA breakout board
- 3 x 357ohm resistor
- 3 x 100ohm resistor
- Miscellaneous wires

## About the Author

[Nick A. Bild, MS](https://nickbild79.firebaseapp.com/#!/)
