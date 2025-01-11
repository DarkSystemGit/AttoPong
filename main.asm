#include <stdlib>;
#define colors [4,0xFFFFFFFF,0x000000FF,0x8C8C8CFF,0xbab9b6FF];
#include "ball.asm";
#include "players.asm";
#include "tiles.asm";
#include "title.asm";
#define tilemapAddr 0;
#define tilesetAddr 0;
#define vramAddr 0;
#define ballVec [0,0.5];
#define ballVelocity [0,0];
#define points [0,0];
#define paddles [0,0];
#define ballAddr 0;
#define frameCount 0;
call title;


init:
sys gfx.getVRAMBuffer %B,%A;
sys mem.fill %B,76800,2;
write %B,&vramAddr;
sys gfx.new %B;
sys gfx.setPalette &colors;
sys mem.malloc 512,%B,%A;
sys mem.copy tileset,%B,32;
write %B,&tilesetAddr;
ret;
initGame:
sys gfx.sprite.new %C,0,0,0,&ball;
write %C,&ballAddr;
read &tilesetAddr,%B;
sys gfx.tilemap.new %D,0,0,&tilemapData,%B,40,30;
call reset;
call initPaddles;
GameLoop:
read &frameCount,%A;
inc %A;
write %A,&frameCount;
read &paddlePos,%F;
sys gfx.windowClosed %A;
cmp %A,1;
jz Exit;
read &vramAddr,%A;
sys mem.fill %A,76800,2;
call handleKeys;
call paddleAI;
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
call checkWin;
jmp GameLoop;
Exit:
exit;
Win:
mov 0,%A;
mov 0,%B;
mov 0,%C;
read &vramAddr,%A;
sys mem.fill %A,76800,2;
read &tilesetAddr,%A;
sys gfx.tilemap.new %B,0,0,&winTM,%A,40,30;
pop %A;
add 3,%A;
mov %A,%C;
add &winTM,619;
write %C,%A;
sys gfx.tilemap.render %B;
sys gfx.tilemap.blit %B;
elStart:
sys gfx.render;
sys gfx.getPressedKeys %B;
read %B,%A;
cmp %A,0;
jz elStart;
add 1,%B;
read %A,%B;
cmp %B,gfx.keys.x;
jz Exit;
jmp elStart;

checkWin:
push %A;
read &points,%A;
cmp %A,10;
jz twowin;
add 1,&points;
read %A,%A;
cmp %A,10;
jz onewin;
pop %A;
ret;
onewin:
push 1;
jmp Win;
twowin:
push 2;
jmp Win;