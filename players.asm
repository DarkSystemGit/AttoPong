#include <stdlib>;

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