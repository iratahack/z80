#ifndef _test_h_
#define _test_h_

#define FIX_POINT(a, b)     ((a<<4) | b)
#define INT(a)  (a>>4)

#define X_SPEED FIX_POINT(0, 8)
#define Y_SPEED FIX_POINT(1, 0)

#define RIGHT_SPRITE (FONT_TILE_OFFSET + 96)
#define LEFT_SPRITE (RIGHT_SPRITE + 20)

extern void print(char *string, char x, char y);
extern void displayTilesheet(void);
extern void displayLevel(void);
extern char scrollLeft(void);
extern char scrollRight(void);
extern void displayTitleScreen(char seconds);
extern void newGame(void);
extern void doGravity(void);
extern char xCollision(void);

#endif
