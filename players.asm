#include <stdlib>;
#define paddleSprites [0,0,0,0];
#define paddlePos [0,0];
renderScores:
push %A;
push %B;
push %C;
push %D;
read &points,%B;
add 3,%B;
mov %A,%D;
add 8,&tilemapData;
write %D,%A;
add 1,&points;
read %A,%B;
add 3,%B;
mov %A,%D;
add 31,&tilemapData;
write %D,%A;
pop %D;
pop %C;
pop %B;
pop %A;
ret;
writePs:
push %A;
push %B;
push %C;
sub %SBP,3;
mov %A,%SBP;
pop %B;
add %SBP,3;
mov %A,%SBP;
cmp %B,1;
jz addP1;
cmp %B,2;
jz addP2;
wpeof:
pop %C;
pop %B;
pop %A;
ret;
addP1:
read &points,%B;
inc %B;
call reset;
write %B,&points;
jmp wpeof;
addP2:
add &points,1;
read %A,%B;
inc %B;
write %B,%A;
call reset;
jmp wpeof;

initPaddles:
push %A;
push %B;
sys gfx.sprite.new %B,0,104,0,&paddle;
write %B,&paddleSprites;
sys gfx.sprite.new %B,0,120,0,&paddle;
add &paddleSprites,1;
write %B,%A;
sys gfx.sprite.new %B,304,104,0,&paddle;
add &paddleSprites,2;
write %B,%A;
sys gfx.sprite.new %B,304,120,0,&paddle;
add &paddleSprites,3;
write %B,%A;
pop %A;
pop %B;
ret;

renderPaddles:
push %A;
push %B;
push %C;
push %D;
push %E;
push %F;
push %H;
mov 0,%H;
bp;
rpLoop:
cmp %H,3;
jz rpeol;
add %H,&paddleSprites;
read %A,%A;
inc %A;
mov %A,%B;
//%B=sprite y coord addr
mod %H,2;
add %F,&paddlePos;
mov %A,%C;
//%C=addr of pos
read %C,%A;
read %B,%D;
add %A,%D;
write %A,%B;
dec %B;
sys gfx.sprite.render %B;
inc %H;
jmp rpLoop;
rpeol:
pop %H;
push %F;
pop %E;
pop %D;
pop %C;
pop %B;
pop %A;
ret;