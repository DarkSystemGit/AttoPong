#include <stdlib>;
#define canBounce 1;
#define bounceang -360;
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
//sys math.round %F,%F;
write %F,%B;
//y
add 1,%B;
read %A,%F;
addf %J,%F;
//sys math.round %F,%F;
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
ballInBounds:
push %A;
push %B;
push %F;
push %H;
sub %SBP,4;
mov %A,%SBP;
pop %B;
add %SBP,4;
mov %A,%SBP;
push %C;
push %D;
read %B,%C;
inc %B;
read %B,%B;
//x=%C,y=%B
add %C,4;
mov %A,%C;
add %B,4;
mov %A,%B;
cmp %B,1;
jlt BiBBounce;
add %B,4;
cmp %A,240;
jg BiBBounce;
push 0;
jmp BiBRet;

BiBBounce:
push 1;

BiBRet:
dec %SBP;
pop %D;
pop %C;
pop %H;
pop %F;
pop %B;
pop %A;
inc %SBP;
ret;

bounceBall:
push %F;
push %A;
read &canBounce,%A;
cmp %A,0;
jz eofBB;
read &ballVec,%F;
mulf %F,-1;
addf %F,180;
write %F,&ballVec;
eofBB:
pop %A;
pop %F;
ret;
//reset()
reset:
push %A;
push %B;
push %C;
push %D;
push %E;
push %F;
//move ball to screen center
read &ballAddr,%B;
write 152,%B;
inc %B;
write 112,%B;
//inc speed
call accelerationFunc;
//get rand num
push 0;
push 360;
call generateRandomNum;
pop %C;
//new angle is in %C
write %C,&ballVec;
pop %F;
pop %E;
pop %D;
pop %C;
pop %B;
pop %A;
ret;
doPoints:
push %A;
push %B;
push %C;
push %F;
push %H;
push 0;
read &ballAddr,%A;
read %A,%F;
cmp %F,0;
jg cmp2;
pop %A;
push 1;
jmp dpeof;
cmp2:
cmp %F,320;
jlt dpeof;
pop %A;
push 2;
dpeof:
dec %SBP;
pop %H;
pop %F;
pop %C;
pop %B;
pop %A;
inc %SBP;
ret;
paddleBounce:
push %A;
push %B;
push %C;
push %D;
push %F;
push %H;
push %A;
read &ballAddr,%A;
read %A,%B;
inc %A;
read %A,%C;
//%B=x,%C=y
cmp %B,8;
jlt lpcmp;
cmp %B,310;
jg rpcmp;
write 1,&canBounce;
pbeol:
dec %SBP;
pop %H;
pop %F;
pop %D;
pop %C;
pop %B;
pop %A;
inc %SBP;
ret;

lpcmp:
read &paddlePos,%A;
add 112,%A;
cmp %C,%A;
jlt pbeol;
add 16,%A;
cmp %C,%A;
jg pbeol;
pop %A;
push 1;
jmp pbeol;

rpcmp:
add &paddlePos,1;
read %A,%A;
add 112,%A;
cmp %C,%A;
jlt pbeol;
add 16,%A;
cmp %C,%A;
jg pbeol;
pop %A;
push 2;
jmp pbeol;

bounceStack:
push %A;
dec %SBP;
pop %A;
inc %SBP;
cmp %A,0;
jz bseof;
write 180,&bounceang;
//bp;
call bounceBall;
write -360,&bounceang;
write 0,&canBounce;
bseof:
pop %A;
ret;
accelerationFunc:
push %A;
push %F;
push %B;
add 1,&ballVec;
read %A,%A;
cmp %A,0;
jnz afbody;
inc %A;
mov %A,%F;
jmp afend;
afbody:
div %A,7.5;
cmp %A,5;
jg subF1;
afend:
add 1,&ballVec;
read %A,%B;
addf %B,%F;
write %F,%A;
pop %B;
pop %F;
pop %A;
ret;

subF1:
subf 1,%F;
jmp afend;