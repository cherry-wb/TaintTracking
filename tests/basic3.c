#include <stdlib.h>
#include <stdio.h>
#include <time.h>

int doStuff(int a, int b) {
    
    int c = (a+3)*(a);
    c += b;

    return c;
}


int main() {

    srand(time(NULL));
    int x;
    x = rand()%20;
    
    int y = 5;

    if(x % 2) {
        printf("Y = %d\n", y);
        return y;
    }    

    int w = doStuff(x,y);

    printf("W = %d\n", w);
    return w;
}
