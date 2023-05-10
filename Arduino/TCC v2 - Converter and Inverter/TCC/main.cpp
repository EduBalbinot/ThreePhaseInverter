 /*
  * TCC.cpp
  *
  * Created: 08/03/2023 08:26:16
  * Author : Eduardo Balbinot
  */ 
 
 #define F_CPU 16000000UL
 
 #include <avr/io.h>
 #include <avr/interrupt.h>
 #include <util/delay.h>
 #include "data.hpp"
 
 extern int lim;
 extern struct moment a[];

 #define HVRead PC0
 #define PVRead PC1
 #define ARead PC3
     
   int i = 1 ;
   unsigned int OC = 0;
   int lastADC = 0;
   float fm;
   
   ISR(TIMER1_COMPA_vect) {

  	 PORTD = a[i].port;
	 OC = (unsigned int) (a[i].counter*fm);
  	 TCNT1 = 0;
  	 OCR1A = OC;
	 
  	 i++;
  	 if(i>lim) i=0;
   }
 
 int main(void)
 {
    cli();  // Desabilita interrup��es globais
  
    DDRD|=(1<<2) | (1<<3) | (1<<4) | (1<<5);
	//DDRB|=(1<<PORTB5);//PB0 como sa�da
  
    TCCR1A = 0;   // Zera configura��es do Timer 1
    TCCR1B = 0;   // Zera configura��es do Timer 1
    TCNT1 = 0;    //Inicializa contador do Timer 1 em 0
    ICR1 = 65535;  
    TCCR1A |= (1 << WGM12);  // Ativa modo CTC (Clear Timer on Compare Match) para OCR1A
    TCCR1B |= (1 << CS10);   // Sem prescaler
    //TCC1RB |= (1 << CS10) | (1 << CS12); // Prescaler 1024
    TIMSK1 |= (1 << OCIE1A) ; // ativa interrup��o dos comparadores
    OCR1A = 1000;  //<65536 //valor dos interrupt
    sei();  // Habilita interrup��es globais
 
	ADCSRA|=(1<<ADEN);//habilita conversor AD
	ADCSRA|=(1<<ADPS0)|(1<<ADPS1)|(1<<ADPS2);//configura prescaler para 128
	ADMUX|=(1<<REFS0);//configura referencia do ADC para o VCC
	ADMUX&=0b11110000;//limpa o MUX
	ADMUX|=HVRead;//configura pra leitura do canal
	PORTD = (1<<5);
     while (1) 
     {
		 ADCSRA|=(1<<ADSC);//inicia convers�o
		 while(ADCSRA&(1<<ADSC));//aguarda ADSC voltar para 0
		 lastADC = ADC;	
		 fm = 2.5 - (float)lastADC/(1023/(2.5-1));
// 		 if(lastADC>0.7) PORTD = (1<<5);
// 		 else PORTD = (0<<5);
		 	
  		_delay_ms(100);
     }
 }

