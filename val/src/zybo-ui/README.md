# `zybo-ui`

## Quickstart
In the `bash` terminal:
1. `make`: compile the UI program/driver
2. `./t5`: run the UI program

## Pertinent Files
* Source
    * `draw.h`: header file for drawing UI assets
    * `driver.h`: header file for accessing the AXI peripheral's registers
    * `t5.c`: main file and cursor control
    * `driver.c`: a predecessor, simplified driver for interfacing with RTL
* Notes
    * [`draw.md`](draw.md)