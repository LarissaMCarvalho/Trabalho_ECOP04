//Larissa Maria Carvalho
//2020003531

#include "config.h"
#include "bits.h"
#include "lcd.h"
#include "keypad.h"
#include "delay.h"
#include "ssd.h"
#include "pwm.h"
#include "pic18f4520.h"

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
        TRISA = 0x00;
        bitClr(PORTA, 5);
        bitClr(PORTA, 4);
        bitSet(PORTA, 3);
        bitSet(PORTA, 2);
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

    TRISD = 0x00;
    TRISA = 0x00;
    PORTD = 0x00;

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
                PORTD = 0x00;
                pos = 0;
                
                lcdInit();
                lcdCommand(0x01);
                for (i = 0; i < 15; i++) {
                    lcdData(msg_inicio[i]);
                }
                tempo(3000);
                
                for (i = 0; i < rodada; i++) {
                    PORTD = 0x00;
                    tempo(2000);
                    PORTD = resp[i];
                    pwmFrequency(100*resp[i]);
                    for (k = 0; k < 3; k++) {
                        for (j = 1; j > 0; j = j * 2) {
                            bitSet(TRISC, 1);
                            tempo(700);
                            break;
                        }
                        bitClr(TRISC, 1);
                    }
                    PORTB = 0x00;
                    PORTD = 0x00;
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
                    if (bitTst(tecla, 0)) { //asterisco
                        vetor[pos] = 8;
                        if(vetor[pos] != resp[pos]){ 
                            erro=1;
                        }
                        pwmFrequency(100*8);
                        for (k = 0; k < 3; k++) {
                            for (j = 1; j > 0; j = j * 2) {
                                bitSet(TRISC, 1);
                                tempo(200);
                                break;
                            }
                            bitClr(TRISC, 1);
                        }
                        PORTB = 0x00;
                        PORTD = 0x00;
                        imprime_img(img4);
                    }
                    if (bitTst(tecla, 1)) { //tecla 7
                        vetor[pos] = 4;
                        if(vetor[pos] != resp[pos]){
                            erro=1;
                        }
                        pwmFrequency(100*4);
                        for (k = 0; k < 3; k++) {
                            for (j = 1; j > 0; j = j * 2) {
                                bitSet(TRISC, 1);
                                tempo(200);
                                break;
                            }
                            bitClr(TRISC, 1);
                        }
                        PORTB = 0x00;
                        PORTD = 0x00;
                        imprime_img(img3);
                    }
                    if (bitTst(tecla, 2)) { //tecla 4
                        vetor[pos] = 2;
                        if(vetor[pos] != resp[pos]){
                           erro=1;
                        }
                        pwmFrequency(100*2);
                        for (k = 0; k < 3; k++) {
                            for (j = 1; j > 0; j = j * 2) {
                                bitSet(TRISC, 1);
                                tempo(200);
                                break;
                            }
                            bitClr(TRISC, 1);
                        }
                        PORTB = 0x00;
                        PORTD = 0x00;
                        imprime_img(img2);
                    }
                    if (bitTst(tecla, 3)) { //tecla 1
                        vetor[pos] = 1;
                        if(vetor[pos] != resp[pos]){
                           erro=1;
                        }
                        pwmFrequency(100);
                        for (k = 0; k < 3; k++) {
                            for (j = 1; j > 0; j = j * 2) {
                                bitSet(TRISC, 1);
                                tempo(200);
                                break;
                            }
                            bitClr(TRISC, 1);
                        }
                        PORTB = 0x00;
                        PORTD = 0x00;
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
                        PORTD = 0x00;
                        tempo(2000);
                        PORTD = 0xFF;
                    }
                    pos=0;
                    rodada=0;
                    turno=0;
                }
                
                if(pos == 20){
                    for(i=0; i<3; i++){
                        tempo(2000);
                        PORTD = 0x00;
                        tempo(2000);
                        PORTD = 0xFF;
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
