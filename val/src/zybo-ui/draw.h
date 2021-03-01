#include "stdio.h"
#include "stdint.h"

#define ROW_MAX 19
#define COL_MAX 45
#define X_OFFSET 12
#define Y_OFFSET 16


struct cursor_status {
    int isSwitches ;
    int isButtons  ;
    int bank_index ;
};

extern struct cursor_status curr_stat;
extern int X_POS;
extern int Y_POS;

extern uint32_t LEDOUT_all;
extern uint32_t BANK_LEDS;
extern uint32_t BANK_SWITCHES;
extern uint32_t BANK_SWITCHES_SELECTED;
extern uint32_t BANK_BUTTONS;
extern uint32_t BANK_BUTTONS_SELECTED;

void draw_whitespace_chars(int char_count)
{
    for(int i = 0; i < char_count; i++) printf(" ");
}

void draw_controls_guide() {
    printf("[q]uit [a]ssert [s]elect [c]ycle [h]⬅ [j]⬇ [k]⬆ [l]⮕");
}

void draw_controls_status() {
    printf("X: %2d, Y: %2d, isSwitches: %d, isButtons: %d, bank_index: %2d", 
            X_POS - X_OFFSET, Y_POS - Y_OFFSET, 
            curr_stat.isSwitches, curr_stat.isButtons, curr_stat.bank_index);
}

void draw_empty_row() {
    draw_whitespace_chars(COL_MAX + 1);
}

void draw_7seg_led(int digit, int segment, int count)
{
    int i = 0;
    if (LEDOUT_all & ((1 << segment) << (digit << 3))) {
        while (i < count) { printf("▓"); i++; }
    } else {
        while (i < count) { printf("░"); i++; }
    }
}

void draw_7seg_top() {
    draw_whitespace_chars(13);
    draw_7seg_led(3, 0, 3);
    draw_whitespace_chars(6);
    draw_7seg_led(2, 0, 3);
    draw_whitespace_chars(6);
    draw_7seg_led(1, 0, 3);
    draw_whitespace_chars(6);
    draw_7seg_led(0, 0, 3);
}

void draw_7seg_upper_mid() {
    draw_whitespace_chars(12);
    draw_7seg_led(3, 5, 1);
    draw_whitespace_chars(3);
    draw_7seg_led(3, 1, 1);
    draw_whitespace_chars(4);
    draw_7seg_led(2, 5, 1);
    draw_whitespace_chars(3);
    draw_7seg_led(2, 1, 1);
    draw_whitespace_chars(4);
    draw_7seg_led(1, 5, 1);
    draw_whitespace_chars(3);
    draw_7seg_led(1, 1, 1);
    draw_whitespace_chars(4);
    draw_7seg_led(0, 5, 1);
    draw_whitespace_chars(3);
    draw_7seg_led(0, 1, 1);
    draw_whitespace_chars(4);
}

void draw_7seg_mid() {
    draw_whitespace_chars(13);
    draw_7seg_led(3, 6, 3);
    draw_whitespace_chars(6);
    draw_7seg_led(2, 6, 3);
    draw_whitespace_chars(6);
    draw_7seg_led(1, 6, 3);
    draw_whitespace_chars(6);
    draw_7seg_led(0, 6, 3);
}

void draw_7seg_lower_mid() {
    draw_whitespace_chars(12);
    draw_7seg_led(3, 4, 1);
    draw_whitespace_chars(3);
    draw_7seg_led(3, 2, 1);
    draw_whitespace_chars(4);
    draw_7seg_led(2, 4, 1);
    draw_whitespace_chars(3);
    draw_7seg_led(2, 2, 1);
    draw_whitespace_chars(4);
    draw_7seg_led(1, 4, 1);
    draw_whitespace_chars(3);
    draw_7seg_led(1, 2, 1);
    draw_whitespace_chars(4);
    draw_7seg_led(0, 4, 1);
    draw_whitespace_chars(3);
    draw_7seg_led(0, 2, 1);
    draw_whitespace_chars(4);
}

void draw_7seg_bottom() {
    printf("7-Segment");
    draw_whitespace_chars(4);
    draw_7seg_led(3, 3, 3);
    draw_whitespace_chars(2);
    draw_7seg_led(3, 7, 1);
    draw_whitespace_chars(3);
    draw_7seg_led(2, 3, 3);
    draw_whitespace_chars(2);
    draw_7seg_led(2, 7, 1);
    draw_whitespace_chars(3);
    draw_7seg_led(1, 3, 3);
    draw_whitespace_chars(2);
    draw_7seg_led(1, 7, 1);
    draw_whitespace_chars(3);
    draw_7seg_led(0, 3, 3);
    draw_whitespace_chars(2);
    draw_7seg_led(0, 7, 1);
    draw_whitespace_chars(3);
}

void draw_led(int index) {
    if (BANK_LEDS & 1 << index) printf("▓");
    else printf("░");
}

void draw_leds_row() {
    printf("LEDs");
    draw_whitespace_chars(8);
    for (int i = 15; i >= 0; i--) {
        draw_led(i);
        if(i % 4 == 0) draw_whitespace_chars(2);
        else           draw_whitespace_chars(1);
    }
}

void draw_horiz_sep_chars(int char_count)
{
    for(int i = 0; i < char_count; i++) printf("=");
}

void draw_horiz_sep_row() {
    draw_horiz_sep_chars(COL_MAX + 1);
}

void draw_switch(int index, int row) {
    if (BANK_SWITCHES & 1 << index) { 
        if (BANK_SWITCHES_SELECTED & 1 << index) { // toggled off
            if (row == 0)   printf("░");
            else            printf("▒");
        } else { // switch is on
            if (row == 0)   printf("█");
            else            printf("░");
        }
    } else { 
        if (BANK_SWITCHES_SELECTED & 1 << index) { // toggled on
            if (row == 0)   printf("▒");
            else            printf("░");
        } else { // switch is off
            if (row == 0)   printf("░");
            else            printf("⎕");
        }
        
    }
}

void draw_switches(int row) {
    if (row == 1) { 
        printf("Switches"); 
        draw_whitespace_chars(4);
    } else { 
        draw_whitespace_chars(12);
    }
    for (int i = 15; i >= 0; i--) {
        draw_switch(i, row);
        if(i % 4 == 0) draw_whitespace_chars(2);
        else           draw_whitespace_chars(1);
    }
}


void draw_button(int index) {
    if (BANK_BUTTONS_SELECTED & 1 << index) { 
        printf("▒");
    } else if (BANK_BUTTONS & 1 << index) { 
        printf("█");
    } else { // button is deasserted
        printf("░");
    }
}

void draw_buttons() {
    printf("Buttons"); 
    draw_whitespace_chars(5);
    for (int i = 15; i >= 0; i--) {
        draw_button(i);
        if(i % 4 == 0) draw_whitespace_chars(2);
        else           draw_whitespace_chars(1);
    }
}

void draw_rows() {
    for (int row = 0; row <= ROW_MAX; row++) {
        switch (row) {
            case  0: draw_controls_guide(); break;
            case  1: draw_controls_status(); break;
            case  2: draw_empty_row(); break;
            case  3: draw_7seg_top(); break;
            case  4: draw_7seg_upper_mid(); break;
            case  5: draw_7seg_upper_mid(); break;
            case  6: draw_7seg_mid(); break;
            case  7: draw_7seg_lower_mid(); break;
            case  8: draw_7seg_lower_mid(); break;
            case  9: draw_7seg_bottom(); break;
            case 10: draw_empty_row(); break;
            case 11: draw_leds_row(); break;
            case 12: draw_empty_row(); break;
            case 13: draw_horiz_sep_row(); break;
            case 14: draw_empty_row(); break;
            case 15: draw_switches(0); break;
            case 16: draw_switches(1); break;
            case 17: draw_empty_row(); break;
            case 18: draw_buttons(); break;
            case 19: draw_empty_row(); break;
        }
        printf("\n");
    }
}