#include <stdlib>;
title:
call init;
read &tilesetAddr,%B;
sys gfx.tilemap.new %B,112,200,&pressx,%B,12,3;
sys gfx.tilemap.render %B;
sys gfx.tilemap.blit %B;
call drawLogo;
tloop:
sys gfx.render;
sys gfx.getPressedKeys %B;
read %B,%A;
cmp %A,0;
jz tloop;
add 1,%B;
read %A,%B;
cmp %B,gfx.keys.x;
jz start;
jmp tloop;
start:
mov 0,%A;
mov 0,%B;
mov 0,%C;
mov 0,%D;
jmp initGame;

drawLogo:
push %A;
push %B;
push %C;
push %D;
push %E;
push %F;
mov 0,%C;
tloop:
cmp %C,1044;
jz tend;
mod %C,58;
mov %F,%D;
div %C,58;
mov %F,%B;
//%B=Y,%D=X;
add %D,131;
mov %A,%D;
add 40,%B;
mov %A,%B;
add %C,&pongLogo;
read %A,%E;
//%E=current pixel;
mul %B,320;
add %A,%D;
read &vramAddr,%B;
add %A,%B;
write %E,%A;
inc %C;
jmp tloop;
tend:
pop %F;
pop %E;
pop %D;
pop %C;
pop %B;
pop %A;
ret;