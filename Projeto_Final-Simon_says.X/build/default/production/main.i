# 1 "main.c"
# 1 "<built-in>" 1
# 1 "<built-in>" 3
# 288 "<built-in>" 3
# 1 "<command line>" 1
# 1 "<built-in>" 2
# 1 "/opt/microchip/xc8/v2.32/pic/include/language_support.h" 1 3
# 2 "<built-in>" 2
# 1 "main.c" 2



# 1 "./config.h" 1
# 26 "./config.h"
#pragma config OSC=HS
#pragma config FCMEN = OFF
#pragma config IESO = OFF
#pragma config PWRT = OFF
#pragma config BOREN = OFF
#pragma config BORV = 46
#pragma config WDT=OFF
#pragma config WDTPS = 1
#pragma config MCLRE=ON
#pragma config LPT1OSC = OFF
#pragma config PBADEN = ON
#pragma config CCP2MX = PORTC
#pragma config STVREN = OFF
#pragma config LVP=OFF
#pragma config XINST = OFF
#pragma config DEBUG = OFF

#pragma config CP0 = OFF
#pragma config CP1 = OFF
#pragma config CP2 = OFF
#pragma config CP3 = OFF
#pragma config CPB = OFF
#pragma config CPD = OFF

#pragma config WRT0 = OFF
#pragma config WRT1 = OFF
#pragma config WRT2 = OFF
#pragma config WRT3 = OFF
#pragma config WRTB = OFF
#pragma config WRTC = OFF
#pragma config WRTD = OFF

#pragma config EBTR0 = OFF
#pragma config EBTR1 = OFF
#pragma config EBTR2 = OFF
#pragma config EBTR3 = OFF
#pragma config EBTRB = OFF
# 5 "main.c" 2
# 1 "./bits.h" 1
# 6 "main.c" 2
# 1 "./lcd.h" 1
# 23 "./lcd.h"
 void lcdCommand(unsigned char cmd);
 void lcdData(unsigned char valor);
 void lcdInit(void);
# 7 "main.c" 2
# 1 "./keypad.h" 1
# 23 "./keypad.h"
 unsigned int kpRead(void);
 void kpDebounce(void);
 void kpInit(void);
# 8 "main.c" 2
# 1 "./delay.h" 1



 void tempo(int tempo_x);
# 9 "main.c" 2
# 1 "./ssd.h" 1
# 22 "./ssd.h"
 void ssdDigit(char val, char pos);
 void ssdUpdate(void);
 void ssdInit(void);
# 10 "main.c" 2
# 1 "./pwm.h" 1
# 23 "./pwm.h"
 void pwmSet1(unsigned char porcento);
 void pwmSet2(unsigned char porcento);
 void pwmFrequency(unsigned int freq);
 void pwmInit(void);
# 11 "main.c" 2
# 1 "./pic18f4520.h" 1
# 12 "main.c" 2

int rodada = 0, pos = 0;

void imprime_img(char img[32]) {
    char i;
    lcdInit();
    lcdCommand(0x40);

    for (i = 0; i < 32; i++) {
        lcdData(img[i]);
    }

    lcdCommand(0x8c);
    lcdData(0);
    lcdData(1);
    lcdCommand(0xcc);
    lcdData(2);
    lcdData(3);

    pos++;
    if (pos == 5) {
        lcdCommand(0x84);
        lcdData('B');
        lcdData('O');
        lcdData('M');
        lcdData('!');
    }
    if (pos == 10) {
        lcdCommand(0x83);
        lcdData('O');
        lcdData('T');
        lcdData('I');
        lcdData('M');
        lcdData('O');
        lcdData('!');
    }
    if (pos == 15) {
        lcdCommand(0x82);
        lcdData('P');
        lcdData('E');
        lcdData('R');
        lcdData('F');
        lcdData('E');
        lcdData('I');
        lcdData('T');
        lcdData('O');
    }
    if (pos == 20) {
        lcdCommand(0x81);
        lcdData('*');
        lcdData('P');
        lcdData('A');
        lcdData('R');
        lcdData('A');
        lcdData('B');
        lcdData('E');
        lcdData('N');
        lcdData('S');
        lcdData('*');
    }
}

void num_rodada() {
    char intervalo;
    for(intervalo=0; intervalo<60; intervalo++){
        (*(volatile __near unsigned char*)0xF92) = 0x00;
        (((*(volatile __near unsigned char*)0xF80)) &= ~(1<<(5)));
        (((*(volatile __near unsigned char*)0xF80)) &= ~(1<<(4)));
        (((*(volatile __near unsigned char*)0xF80)) |= (1<<(3)));
        (((*(volatile __near unsigned char*)0xF80)) |= (1<<(2)));
        ssdDigit(((rodada) % 10), 3);
        ssdDigit(((rodada) / 10), 2);
        ssdUpdate();
        tempo(100);
    }
}

void main(void) {
    char img1[32] = {
        0x03, 0x07, 0x07, 0x07, 0x03, 0x00, 0x01, 0x03,
        0x10, 0x18, 0x18, 0x18, 0x10, 0x00, 0x00, 0x1E,
        0x05, 0x09, 0x01, 0x01, 0x06, 0x08, 0x10, 0x00,
        0x00, 0x00, 0x00, 0x00, 0x10, 0x10, 0x10, 0x18
    };
    char img2[32] = {
        0x01, 0x03, 0x03, 0x03, 0x01, 0x00, 0x00, 0x0F,
        0x18, 0x1C, 0x1C, 0x1C, 0x18, 0x00, 0x10, 0x18,
        0x00, 0x00, 0x00, 0x00, 0x01, 0x01, 0x01, 0x03,
        0x14, 0x12, 0x10, 0x10, 0x0C, 0x02, 0x01, 0x00
    };
    char img3[32] = {
        0x01, 0x03, 0x03, 0x03, 0x01, 0x00, 0x00, 0x01,
        0x18, 0x1C, 0x1C, 0x1C, 0x18, 0x00, 0x10, 0x18,
        0x02, 0x04, 0x00, 0x00, 0x01, 0x01, 0x01, 0x01,
        0x14, 0x12, 0x10, 0x10, 0x08, 0x08, 0x08, 0x08
    };
    char img4[32] = {
        0x03, 0x07, 0x07, 0x07, 0x13, 0x08, 0x05, 0x03,
        0x10, 0x18, 0x18, 0x18, 0x12, 0x04, 0x08, 0x10,
        0x01, 0x01, 0x01, 0x01, 0x02, 0x04, 0x04, 0x08,
        0x00, 0x00, 0x00, 0x00, 0x10, 0x08, 0x08, 0x04
    };
    char msg_inicio[15] = "Escute a musica";
    char msg[8] = "Sua vez!";
    char msg_perdeu[12] = "Voce Perdeu!";
    int resp[20] = {1, 2, 8, 2, 4, 2, 4, 1, 4, 8, 2, 4, 1, 4, 8, 2, 8, 8, 1, 2};
    int vetor[20];
    unsigned int tecla = 16, turno = 0;
    char i, k, j, erro;

    (*(volatile __near unsigned char*)0xF95) = 0x00;
    (*(volatile __near unsigned char*)0xF92) = 0x00;
    (*(volatile __near unsigned char*)0xF83) = 0x00;

    ssdInit();
    kpInit();
    pwmInit();

    for (;;) {
        if(rodada == 0){
            rodada++;
        }
        switch (turno) {
            case 0:
                num_rodada();
                (*(volatile __near unsigned char*)0xF83) = 0x00;
                pos = 0;

                lcdInit();
                lcdCommand(0x01);
                for (i = 0; i < 15; i++) {
                    lcdData(msg_inicio[i]);
                }
                tempo(3000);

                for (i = 0; i < rodada; i++) {
                    (*(volatile __near unsigned char*)0xF83) = 0x00;
                    tempo(2000);
                    (*(volatile __near unsigned char*)0xF83) = resp[i];
                    pwmFrequency(100*resp[i]);
                    for (k = 0; k < 3; k++) {
                        for (j = 1; j > 0; j = j * 2) {
                            (((*(volatile __near unsigned char*)0xF94)) |= (1<<(1)));
                            tempo(700);
                            break;
                        }
                        (((*(volatile __near unsigned char*)0xF94)) &= ~(1<<(1)));
                    }
                    (*(volatile __near unsigned char*)0xF81) = 0x00;
                    (*(volatile __near unsigned char*)0xF83) = 0x00;
                }

                lcdInit();
                lcdCommand(0x01);
                for (i = 0; i < 8; i++) {
                    lcdData(msg[i]);
                }
                erro = 0;
                turno = 1;
            case 1:
                kpDebounce();
                if (kpRead() != tecla) {
                    tecla = kpRead();
                    if (((tecla) & (1<<(0)))) {
                        vetor[pos] = 8;
                        if(vetor[pos] != resp[pos]){
                            erro=1;
                        }
                        pwmFrequency(100*8);
                        for (k = 0; k < 3; k++) {
                            for (j = 1; j > 0; j = j * 2) {
                                (((*(volatile __near unsigned char*)0xF94)) |= (1<<(1)));
                                tempo(200);
                                break;
                            }
                            (((*(volatile __near unsigned char*)0xF94)) &= ~(1<<(1)));
                        }
                        (*(volatile __near unsigned char*)0xF81) = 0x00;
                        (*(volatile __near unsigned char*)0xF83) = 0x00;
                        imprime_img(img4);
                    }
                    if (((tecla) & (1<<(1)))) {
                        vetor[pos] = 4;
                        if(vetor[pos] != resp[pos]){
                            erro=1;
                        }
                        pwmFrequency(100*4);
                        for (k = 0; k < 3; k++) {
                            for (j = 1; j > 0; j = j * 2) {
                                (((*(volatile __near unsigned char*)0xF94)) |= (1<<(1)));
                                tempo(200);
                                break;
                            }
                            (((*(volatile __near unsigned char*)0xF94)) &= ~(1<<(1)));
                        }
                        (*(volatile __near unsigned char*)0xF81) = 0x00;
                        (*(volatile __near unsigned char*)0xF83) = 0x00;
                        imprime_img(img3);
                    }
                    if (((tecla) & (1<<(2)))) {
                        vetor[pos] = 2;
                        if(vetor[pos] != resp[pos]){
                           erro=1;
                        }
                        pwmFrequency(100*2);
                        for (k = 0; k < 3; k++) {
                            for (j = 1; j > 0; j = j * 2) {
                                (((*(volatile __near unsigned char*)0xF94)) |= (1<<(1)));
                                tempo(200);
                                break;
                            }
                            (((*(volatile __near unsigned char*)0xF94)) &= ~(1<<(1)));
                        }
                        (*(volatile __near unsigned char*)0xF81) = 0x00;
                        (*(volatile __near unsigned char*)0xF83) = 0x00;
                        imprime_img(img2);
                    }
                    if (((tecla) & (1<<(3)))) {
                        vetor[pos] = 1;
                        if(vetor[pos] != resp[pos]){
                           erro=1;
                        }
                        pwmFrequency(100);
                        for (k = 0; k < 3; k++) {
                            for (j = 1; j > 0; j = j * 2) {
                                (((*(volatile __near unsigned char*)0xF94)) |= (1<<(1)));
                                tempo(200);
                                break;
                            }
                            (((*(volatile __near unsigned char*)0xF94)) &= ~(1<<(1)));
                        }
                        (*(volatile __near unsigned char*)0xF81) = 0x00;
                        (*(volatile __near unsigned char*)0xF83) = 0x00;
                        imprime_img(img1);
                    }
                }

                if (erro>0){
                    lcdInit();
                    lcdCommand(0x01);
                    for (i = 0; i < 12; i++) {
                        lcdData(msg_perdeu[i]);
                    }
                    for(i=0; i<3; i++){
                        tempo(2000);
                        (*(volatile __near unsigned char*)0xF83) = 0x00;
                        tempo(2000);
                        (*(volatile __near unsigned char*)0xF83) = 0xFF;
                    }
                    pos=0;
                    rodada=0;
                    turno=0;
                }

                if(pos == 20){
                    for(i=0; i<3; i++){
                        tempo(2000);
                        (*(volatile __near unsigned char*)0xF83) = 0x00;
                        tempo(2000);
                        (*(volatile __near unsigned char*)0xF83) = 0xFF;
                    }
                    rodada = 0;
                    turno = 0;
                }

                if (pos == rodada) {
                    tempo(3000);
                    lcdInit();
                    lcdCommand(0x01);
                    tempo(3000);
                    rodada++;
                    turno = 0;
                }
                break;
        }
    }
}
