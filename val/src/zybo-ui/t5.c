#include <stdio.h>
#include <string.h>
#include <termios.h>
#include <unistd.h>
#include <time.h>
#include <fcntl.h>
#include <stdlib.h>

#include "draw.h"

#define cursorforward(x) printf("\033[%dC", (x))
#define cursorbackward(x) printf("\033[%dD", (x))
#define cursordownward(x) printf("\033[%dB", (x))
#define cursorupward(x) printf("\033[%dA", (x))

#define KEY_ESCAPE  0x001b
#define KEY_ENTER   0x000a
#define KEY_UP      0x0105
#define KEY_DOWN    0x0106
#define KEY_LEFT    0x0107
#define KEY_RIGHT   0x0108

struct termios save;

void set_ioconfig() {
    struct termios custom;
    int fd=fileno(stdin);
    tcgetattr(fd, &save);
    custom=save;

    custom.c_lflag &= ~(ICANON | ECHO);
    custom.c_cc[VMIN] = 1;
    custom.c_cc[VTIME] = 0;

    tcsetattr(fd,TCSANOW,&custom);
    // fcntl(fd, F_SETFL, fcntl(fd, F_GETFL, 0)|O_NONBLOCK);
}

void restore_ioconfig() {
    tcsetattr(fileno(stdin),TCSANOW,&save);
}

int COUNT = 0;
int STAY_ALIVE = 1;

int X_POS = X_OFFSET;
int Y_POS = Y_OFFSET;

uint32_t LEDOUT_all = 0;
uint32_t BANK_LEDS = 0;
uint32_t BANK_SWITCHES = 0;
uint32_t BANK_SWITCHES_SELECTED = 0;
uint32_t BANK_BUTTONS = 0;
uint32_t BANK_BUTTONS_SELECTED = 0;
// uint32_t BANK_SWITCHES = 0xba5e;
// uint32_t BANK_SWITCHES_SELECTED = 0xba11;
// uint32_t BANK_BUTTONS = 0xdead;
// uint32_t BANK_BUTTONS_SELECTED = 0xbeef;

void draw_frame() {
    draw_rows();
    cursorupward(ROW_MAX + 1);
}

void reset_cursor() {
    if (X_POS > 0) cursorbackward(X_POS);
    if (Y_POS > 0) cursorupward(Y_POS);
}

void restore_cursor() {
    if (X_POS > 0) cursorforward(X_POS);
    if (Y_POS > 0) cursordownward(Y_POS);
}

struct cursor_status curr_stat;

void init_cursor_status () {
    curr_stat.isSwitches = 1;
    curr_stat.isButtons  = 0;
    curr_stat.bank_index = 15;
}

void move_cursor(int x, int y) {
    if (y > 0) {
        if (curr_stat.isSwitches) {
            curr_stat.isSwitches = 0;
            curr_stat.isButtons  = 1;
            Y_POS = Y_POS + 2;
            cursordownward(2);
        }
    } else if (y < 0) {
        if (curr_stat.isButtons) {
            curr_stat.isButtons  = 0;
            curr_stat.isSwitches = 1;
            Y_POS = Y_POS - 2;
            cursorupward(2);
        }
    }
    if (x > 0) {
        if (curr_stat.bank_index > 0) {
            if (curr_stat.bank_index % 4 == 0){
                X_POS = X_POS + 3;
                cursorforward(3);
            } else {
                X_POS = X_POS + 2;
                cursorforward(2);
            }
            curr_stat.bank_index = curr_stat.bank_index - 1;
        }
    } else if (x < 0) {
        if (curr_stat.bank_index < 15) {
            if (curr_stat.bank_index % 4 == 3){
                X_POS = X_POS - 3;
                cursorbackward(3);
            } else {
                X_POS = X_POS - 2;
                cursorbackward(2);
            }
            curr_stat.bank_index = curr_stat.bank_index + 1;
        }
    }
}

#include "driver.h"

void update_regs() {
    set_reg_switches(BANK_SWITCHES);
    set_reg_buttons(BANK_BUTTONS);
    BANK_SWITCHES = get_reg_switches();
    BANK_BUTTONS = get_reg_buttons();
    BANK_LEDS = get_reg_leds();
    LEDOUT_all= get_reg_7seg();
}

void update_frame() {
    update_regs();
    reset_cursor();
    draw_frame();
    restore_cursor();
}

char getch() {
    set_ioconfig();
    char c = getchar();
    restore_ioconfig();
    return c;
}

void assert_selected() {
    BANK_SWITCHES = BANK_SWITCHES ^ BANK_SWITCHES_SELECTED;
    BANK_SWITCHES_SELECTED = 0;
    BANK_BUTTONS  = BANK_BUTTONS  ^ BANK_BUTTONS_SELECTED;
    BANK_BUTTONS_SELECTED = 0;
}

void select_on_cursor() {
    if (curr_stat.isSwitches) {
        BANK_SWITCHES_SELECTED ^= 1 << curr_stat.bank_index;
    } else
    if (curr_stat.isButtons) {
        BANK_BUTTONS_SELECTED ^= 1 << curr_stat.bank_index;
    }
}

int main(void)
{
    struct timespec tm;
    char cmd;

    set_ioconfig();
    init_cursor_status();
    init_reg_ptrs();
    system("clear");
    update_frame();

    tm.tv_sec = 0;
    tm.tv_nsec = 1000000;

    while (STAY_ALIVE) {
        cmd = getchar();
        nanosleep(&tm, NULL);
        COUNT++;
        if (COUNT%50 == 0) {
            update_frame();
        }
        // while (STAY_ALIVE && ((cmd = getch()) > 0)) {
            switch (cmd) {
                case 'q': 
                    STAY_ALIVE = 0; 
                    break;
                case 'a':
                    assert_selected();
                    update_frame();
                    break;
                case 's':
                    select_on_cursor();
                    update_frame();
                    break;
                case 'c':
                    update_frame();
                    break;
                case 'h': 
                    if (X_POS > X_OFFSET) {
                        move_cursor(-1, 0);
                        // cursorbackward(1);
                        // --X_POS;
                        update_frame();
                    }
                    break;
                case 'j':
                    if (Y_POS < ROW_MAX) {
                        move_cursor(0, 1);
                        // cursordownward(1);
                        // ++Y_POS;
                        update_frame();
                    }
                    break;
                case 'k':
                    if (Y_POS > Y_OFFSET) {
                        move_cursor(0, -1);
                        // cursorupward(1);
                        // --Y_POS;
                        update_frame();
                    }
                    break;
                case 'l':
                    if (X_POS < COL_MAX) {
                        move_cursor(1, 0);
                        // cursorforward(1);
                        // ++X_POS;
                        update_frame();
                    }
                    break;
                default: break;
            }
        // }
    }
    system("clear");
    restore_ioconfig();
    return 0;
}