#include <stdlib>;
#define paddleSprites [0,0,0,0];
#define paddlePos [0,0];
#define canPress 1;
#define paddleOff 0;
#define lastAiMove 0;
renderScores:
push %A;
push %B;
push %C;
push %D;
read &points,%B;
add 3,%B;
mov %A,%D;
add 31,&tilemapData;
write %D,%A;
add 1,&points;
read %A,%B;
add 3,%B;
mov %A,%D;
add 8,&tilemapData;
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
//
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
push %C;
call limitPaddles;
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
handleKeys:
push %A;
push %B;
push %C;
push %D;
sys gfx.getPressedKeys %B;
mov %B,%D;
read %D,%C;
cmp %C,0;
jz hkRet;
mov 0,%B;
inc %D;
hkLoop:
cmp %B,%C;
jz hkRet;
add %B,%D;
read %A,%A;
push %A;
call handleKey;
inc %B;
jmp hkLoop;
hkRet:
write 1,&canPress;
pop %D;
pop %C;
pop %B;
pop %A;
ret;
handleKey:
push %A;
push %B;
push %F;
sub %SBP,2;
mov %A,%SBP;
pop %B;
read &canPress,%A;
cmp %A,0;
jz hkhRet;
cmp %B,gfx.keys.up;
jz hkUp;
cmp %B,gfx.keys.down;
jz hkDown;
hkhRet:
add %SBP,2;
mov %A,%SBP;
pop %F;
pop %B;
pop %A;
ret;
hkUp:

write 0,&canPress;
read &paddlePos,%F;
subf %F,1.25;
write %F,&paddlePos;
jmp hkhRet;
hkDown:

write 0,&canPress;
read &paddlePos,%F;
addf %F,1.25;
write %F,&paddlePos;
jmp hkhRet;

limitPaddles:
push %A;
push %B;
push %F;
sub %SBP,3;
mov %A,%SBP;
pop %B;
read %B,%F;
add %SBP,3;
mov %A,%SBP;
cmp %F,112;
jg movPos;
cmp %F,-112;
jlt movNeg;
lpEnd:
write %F,%B;
pop %F;
pop %B;
pop %A;
ret;
movPos:
mov 112,%F;
jmp lpEnd;
movNeg:
mov -112,%F;
jmp lpEnd;
generateRandomNum:
push %D;
push %E;
push %A;
push %B;
push %C;
push %F;
push %H;
sub %SBP,7;
mov %A,%SBP;
pop %F;
pop %H;
add %SBP,7;
mov %A,%SBP;
sys time.new %D;
sys time.setToCurrent %D;
sys time.getUnix %D,%E;
sys time.free %D;
sys random.new 0,%A;
sys randomDistrubution.new %B;
sys random.setSeed %A,%E;
sys randomDistrubution.setUniform %B,%H,%F;
sys random.setDistribution %A,%B;
sys random.get %A,%C;
sys random.free %A;
sys randomDistrubution.free %B; 
push %C;
dec %SBP;
pop %H;
pop %F;
pop %C;
pop %B;
pop %A;
pop %E;
pop %D;
inc %SBP;
ret;
paddleAI:
push %A;
push %B;
push %F;
push %H;
push -1;
push 1;
call generateRandomNum;
pop %B;
read &paddleOff,%F;
addf %F,%B;
div %F,2;
write %F,&paddleOff;
read &ballAddr,%A;
inc %A;
read %A,%F;
add 1,&paddlePos;
read %A,%H;
//%H=old pos, %F=ball y
push %F;
addf %H,120;
mov %F,%H;
pop %F;
subf %F,%H;
cmp %F,0;
jg movaid;
jlt movaiu;
paiend:
push %F;
addf %H,-120;
mov %F,%H;
pop %F;
addf %H,%F;
read &frameCount,%A;
push %F;
mod %A,8;
cmp %F,0;
pop %F;
jz pair;
add 1,&paddlePos;
write %F,%A;
pair:
pop %H;
pop %F;
pop %B;
pop %A;
ret;
movaid:
read &paddleOff,%B;
addf 1,%B;
push %H;
read &lastAiMove,%H;
addf %F,%H;
div %F,2;
pop %H;
write %F,&lastAiMove;
jmp paiend;
movaiu:
read &paddleOff,%B;
addf -1,%B;
push %H;
read &lastAiMove,%H;
addf %F,%H;
div %F,2;
pop %H;
write %F,&lastAiMove;
jmp paiend;