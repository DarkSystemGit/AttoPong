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
sys gfx.sprite.new %B,0,112,0,&paddle;
write %B,&paddleSprites;

sys gfx.sprite.new %B,0,120,0,&paddle;
add &paddleSprites,1;
write %B,%A;

sys gfx.sprite.new %B,312,112,0,&paddle;
add &paddleSprites,2;
write %B,%A;

sys gfx.sprite.new %B,312,120,0,&paddle;
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
rpLoop:
cmp %H,4;
jz rpeol;
//bp;
add %H,&paddleSprites;
read %A,%A;
inc %A;
mov %A,%B;
//%B=sprite y coord addr
div %H,2;
sys math.floor %F,%F;
add %F,&paddlePos;
mov %A,%C;
//%C=addr of pos
read %C,%D;
mod %H,2;
cmp %F,0;
jnz add120;
mov 112,%A;
rplr:
add %A,%D;
write %A,%B;
dec %B;
sys gfx.sprite.render %B;
inc %H;
jmp rpLoop;
rpeol:
pop %H;
pop %F;
pop %E;
pop %D;
pop %C;
pop %B;
pop %A;
ret;
add120:
mov 120,%A;
jmp rplr;
