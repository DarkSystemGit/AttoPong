#include <stdlib>;
title:
call init;
read &tilesetAddr,%B;
sys gfx.tilemap.new %B,112,200,&pressx,%B,12,3;
sys gfx.tilemap.render %B;
sys gfx.tilemap.blit %B;
sys gfx.copyRectVRAM &pongLogo,58,18,131,40;
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
