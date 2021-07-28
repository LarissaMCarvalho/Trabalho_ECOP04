# 1 "delay.c"
# 1 "<built-in>" 1
# 1 "<built-in>" 3
# 288 "<built-in>" 3
# 1 "<command line>" 1
# 1 "<built-in>" 2
# 1 "/opt/microchip/xc8/v2.32/pic/include/language_support.h" 1 3
# 2 "<built-in>" 2
# 1 "delay.c" 2
# 1 "./delay.h" 1



 void tempo(int tempo_x);
# 2 "delay.c" 2

void tempo(int tempo_x){
    volatile unsigned char j, k;

    while(tempo_x>0){
        for(j = 0; j < 10; j++) {
            for(k = 0; k < 3; k++);
        }
        tempo_x--;
    }
}
