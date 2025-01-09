#include <stdlib>;
#define colors [2,0xFFFFFFFF,0x000000FF];
#include "ball.asm";
#include "players.asm";
#include "tiles.asm";
#define tilemapAddr 0;
#define tilesetAddr 0;
#define vramAddr 0;
#define ballVec [0,0.5];
#define ballVelocity [0,0];
#define points [0,0];
#define paddles [0,0];
#define ballAddr 0;
sys gfx.getVRAMBuffer %B,%A;
sys mem.fill %B,76800,2;
write %B,&vramAddr;
sys gfx.new %B;
sys gfx.setPalette &colors;
sys gfx.sprite.new %C,0,0,0,&ball;
write %C,&ballAddr;
sys mem.malloc 512,%B,%A;
write %B,&tilesetAddr;
sys mem.copy tileset,%B,13;
sys gfx.tilemap.new %D,0,0,&tilemapData,%B,40,30;
sys gfx.tilemap.render %D;
call reset;
call initPaddles;
GameLoop:
sys gfx.windowClosed %A;
cmp %A,1;
jz Exit;
read &vramAddr,%A;
sys mem.fill %A,76800,2;
read &ballAddr,%A;
push %A;
call ballInBounds;
pop %A;
cmp %A,1;
jnz GLRest;
call bounceBall;
GLRest:
mov 0,%A;
call paddleBounce;
call bounceStack;
call renderPaddles;
call doPoints;
call writePs;
call ballVecConvert;
call addBallVec;
call renderScores;
sys gfx.tilemap.render %D;
sys gfx.tilemap.blit %D;
sys gfx.sprite.render %C;
sys gfx.render;
jmp GameLoop;
Exit:
exit;
