#include <stdlib>;
#define colors [2,0xFFFFFFFF,0x000000FF];
#define ball [
0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
0,0,0,0,1,1,1,1,1,1,1,1,0,0,0,0,
0,0,0,0,1,1,1,1,1,1,1,1,0,0,0,0,
0,0,0,0,1,1,1,1,1,1,1,1,0,0,0,0,
0,0,0,0,1,1,1,1,1,1,1,1,0,0,0,0,
0,0,0,0,1,1,1,1,1,1,1,1,0,0,0,0,
0,0,0,0,1,1,1,1,1,1,1,1,0,0,0,0,
0,0,0,0,1,1,1,1,1,1,1,1,0,0,0,0,
0,0,0,0,1,1,1,1,1,1,1,1,0,0,0,0,
0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
];
#define screenDivider [
0,0,0,0,0,0,0,0,
0,0,0,0,0,0,0,0,
0,0,0,1,1,0,0,0,
0,0,0,1,1,0,0,0,
0,0,0,1,1,0,0,0,
0,0,0,1,1,0,0,0,
0,0,0,0,0,0,0,0,
0,0,0,0,0,0,0,0,
];
#define vramAddr 0;
#define ballVec [45,1];
#define ballVelocity [0,0];
#define ballAddr 0;
sys gfx.getVRAMBuffer %B,%A;
sys mem.fill %B,76800,2;
write %B,&vramAddr;
sys gfx.new %B;
sys gfx.setPalette &colors;
sys gfx.sprite.new %C,0,0,0,&ball;
write %C,&ballAddr;
GameLoop:
sys gfx.windowClosed %A;
cmp %A,1;
jz Exit;
read &vramAddr,%A;
sys mem.fill %A,76800,2;
call ballVecConvert;
call addBallVec;
sys gfx.sprite.render %C;
sys gfx.render;
jmp GameLoop;
Exit:
exit;

addBallVec:
push %A;
push %F;
push %H;
push %B;
push %J;
push %I;
read &ballAddr,%B;
read &ballVelocity,%H;
add 1,&ballVelocity;
read %A,%J;
//%H=x,%J=y
read %B,%F;
addf %F,%H;
write %F,%B;
//y
add 1,%B;
read %A,%F;
addf %J,%F;
write %F,%A;

pop %I;
pop %J;
pop %B;
pop %H;
pop %F;
pop %A;
ret;

ballVecConvert:
push %F;
push %A;
push %B;
push %H;
push %I;
push %J;
read &ballVec,%F;
add 1,&ballVec;
read %A,%H;
mulf %F,0.01745329251;
sys math.cos %F,%I;
push %F;
mulf %I,%H;
write %F,&ballVelocity;
pop %F;
sys math.sin %F,%F;
mulf %F,%H;
add 1,&ballVelocity;
write %F,%A;
pop %J;
pop %I;
pop %H;
pop %B;
pop %A;
pop %F;
ret;
