#include <stdlib>;

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
read &ballVec,%F;
subf %F,360;
mulf %F,-1;
write %F,&ballVec;
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
add &ballVec,1;
mov %A,%B;
read %B,%A;
addf %A,0.75;
write %F,%B;
//get rand num
sys time.new %D;
sys time.setToCurrent %D;
sys time.getUnix %D,%E;
sys time.free %D;
sys random.new 0,%A;
sys randomDistrubution.new %B;
sys random.setSeed %A,%E;
sys randomDistrubution.setUniform %B,0,360;
sys random.setDistribution %A,%B;
sys random.get %A,%C;
sys random.free %A;
sys randomDistrubution.free %B; 
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