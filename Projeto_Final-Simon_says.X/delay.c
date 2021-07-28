#include "delay.h"

void tempo(int tempo_x){
    volatile unsigned char j, k;
    //tempo_x = tempo_x/4;
    while(tempo_x>0){
        for(j = 0; j < 10; j++) {//j < 41
            for(k = 0; k < 3; k++);
        }
        tempo_x--;
    }
}