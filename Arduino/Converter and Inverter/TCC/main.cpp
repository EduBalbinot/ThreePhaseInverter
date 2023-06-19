 /*
  * TCC.cpp
  *
  * Created: 08/03/2023 08:26:16
  * Author : Eduardo Balbinot
  */ 
 
 #define F_CPU 16000000UL
 
 #include <stdio.h>
 #include <avr/io.h>
 #include <avr/interrupt.h>
 #include <util/delay.h>
 #include "data.hpp"
 
 extern int lim;
 extern struct moment a[];

 #define HVRead PC0								//Pino leitura da alta tensão
 #define PVRead PC1								//Pino leitura da entrada módulo PV
 #define ARead PC3								//Pino leitura da corrente do módulo PV
     
   int i = 1 ;
   unsigned int OC = 0;
   int lastADC = 0;
   float fm;
   
//    char strSerial[]="jjjjjjj";
//  void EnviarSerial(int valor);


   
   ISR(TIMER1_COMPA_vect) {						//Interrompe quando chega em OCR1A
  	 PORTD = a[i].port;							//Seta quais portas estão ativas
	 OC = (unsigned int) (a[i].counter*fm);		//Calcula o novo OCR1A
  	 TCNT1 = 0;									//Zera o contador do interrupt
  	 OCR1A = OC;								//Seta o valor da próxima interrupção
	 
  	 i++;
  	 if(i>lim) i=0;
   }
 
 int main(void)
 {
    cli();										// Desabilita interrupções globais
  
    DDRD|=(1<<2) | (1<<3) | (1<<4) | (1<<5);
	DDRD|=(1<<PORTD1);//PB0 como saída
	PORTD= 0;
	//TIMER 1
    TCCR1A = 0;									// Zera configurações do Timer 1
    TCCR1B = 0;									// Zera configurações do Timer 1
    TCNT1 = 0;									// Inicializa contador do Timer 1 em 0
    ICR1 = 65535;  
    TCCR1A |= (1 << WGM12);						// Ativa modo CTC (Clear Timer on Compare Match) para OCR1A
    TCCR1B |= (1 << CS10);						// Sem prescaler
    TIMSK1 |= (1 << OCIE1A) ;					// Ativa interrupção dos comparadores
    OCR1A = 1000;								// <65536 Valor dos interrupt
    sei();										// Habilita interrupções globais
 
	//CONVERSOR AD
	ADCSRA|=(1<<ADEN);							// Habilita conversor AD
	ADCSRA|=(1<<ADPS0)|(1<<ADPS1)|(1<<ADPS2);	// Configura prescaler para 128
	ADMUX|=(1<<REFS0);							// Configura referencia do ADC para o VCC
	ADMUX&=0b11110000;							// Limpa o MUX
	ADMUX|=HVRead;								// Configura pra leitura do canal


// 	UCSR0A = 0;
// 	UCSR0B = (1<<RXCIE0) | (1<<RXEN0) | (1<<TXEN0);
// 	// RXCIE0 - HABILITA A INTERRUPÇÃO POR RX
// 	// RXEN0 - HABILITA A RECEPÇÃO RX NO PINO PD0
// 	// TXEN0 - HABILITA A TRANSMISSÃO TX NO PINO PD1
// 	UCSR0C = (1<<UCSZ00) | (1<<UCSZ01);
// 	// MODO ASSÍNCRONO, SEM PARIDADE, 1 STOP BIT, 8 BITS DE DADOS
// 	UBRR0 = 103;
// 	// BAUD RATE 9600
// 	sei();


     while (1) 
     {
		 ADCSRA|=(1<<ADSC);						// Inicia conversão
		 while(ADCSRA&(1<<ADSC));				// Aguarda ADSC voltar para 0
		 lastADC = ADC;							
		 //fm = 24-(float)lastADC/(972/(24-1));	
		 //if(fm <= 1) 
		 fm = 1;
		 //EnviarSerial(lastADC);
  		_delay_ms(100);
     }
 }
 
//  void EnviarSerial(int valor)
//  {
// 	char i=0;
// 	sprintf(strSerial," %d ", valor);
// 	 while(strSerial[i])
// 	 {
// 	  while(!(UCSR0A & (1<<UDRE0)));      //permanece no while até o UDRE0 indicar que o buffer de transmissão está vazio
//	  UDR0 = strSerial[i];				// transmite
// 	  i++;
// 	 }
// 	  while(!(UCSR0A & (1<<UDRE0)));	//permanece no while até o UDRE0 indicar que o buffer de transmissão está vazio
//	  UDR0 = 13;					// transmite
//  }

