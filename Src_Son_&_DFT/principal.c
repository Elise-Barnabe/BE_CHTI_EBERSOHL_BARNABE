#include "gassp72.h"
#include "stdlib.h"

#define M2TIR 985661
extern short Son;
extern int LongueurSon;
extern int PeriodeSonMicroSec;

typedef struct {
int position;		// index courant dans le tableau d'echantillons
int taille;		// nombre d'echantillons de l'enregistrement
short int * son;	// adresse de base du tableau d'echantillons en ROM
int resolution;		// pleine echelle du modulateur PWM
int Tech_en_Tck;	// periode d'ech. audio en periodes d'horloge CPU
} type_etat;

type_etat etat;

int PeriodeSonTick = 6552;
int Periode_PWM_en_Tck = 655;

void timer_callback(void);

const int SYSTICK_PER = 5*72000;

extern int M2(unsigned short* adresse, int k);
extern short Table_Signal;
unsigned short *dma_buf;
int occurences[6];
int k_freq[6]={17, 18, 19, 20, 23, 24};
int score[6];
//pas fréquentiel de 5kHz 
// f1 = 80kHz donc k = 17 de même pour les freq suivantes

void sys_callback (void){
	//GPIO_Set(GPIOB, 1);
	// Démarrage DMA pour 64 points
	Start_DMA1(64);
	Wait_On_End_Of_DMA1();
	Stop_DMA1;
	
	int tabM2[6];
	for(int i =0; i<6;i++){
		int k = k_freq[i];
		tabM2[i]=M2(dma_buf,k);
		if(tabM2[i]>M2TIR){
			occurences[i]++;
		}else{
			if(occurences[i]>10){
				score[i]++;
				etat.position = 0;
			}
			occurences[i]=0;
		}
	}
	//GPIO_Clear(GPIOB, 1);
}




int main(void)
{
	dma_buf = malloc(64*sizeof(unsigned short));
	// activation de la PLL qui multiplie la fréquence du quartz par 9
	CLOCK_Configure();
	// PA2 (ADC voie 2) = entrée analog
	GPIO_Configure(GPIOA, 2, INPUT, ANALOG);

	GPIO_Configure(GPIOB, 0, OUTPUT, ALT_PPULL);
	etat.resolution = PWM_Init_ff( TIM3, 3, Periode_PWM_en_Tck );
	etat.son = &Son;
	etat.taille = LongueurSon;
	etat.position=LongueurSon;
	

	
	//GPIO_Configure(GPIOB,1,OUTPUT, OUTPUT_PPULL);
	Timer_1234_Init_ff(TIM4, PeriodeSonTick);
	// config port PB0 pour être utilisé par TIM3-CH3
	
	// config TIM3-CH3 en mode PWM
	
	
	Active_IT_Debordement_Timer(TIM4,2,timer_callback);
	Run_Timer(TIM4);
	
	Init_TimingADC_ActiveADC_ff( ADC1, 0x33 );
	Single_Channel_ADC( ADC1, 2 );
	// Déclenchement ADC par timer2, periode (72MHz/320kHz)ticks
	Init_Conversion_On_Trig_Timer_ff( ADC1, TIM2_CC2, 225 );
	// Config DMA pour utilisation du buffer dma_buf (a créér)
	Init_ADC1_DMA1( 0, dma_buf );

	// Config Timer, période exprimée en périodes horloge CPU (72 MHz)
	Systick_Period_ff( SYSTICK_PER );
	// enregistrement de la fonction de traitement de l'interruption timer
	// ici le 3 est la priorité, sys_callback est l'adresse de cette fonction, a créér en C
	Systick_Prio_IT( 3, sys_callback );
	SysTick_On;
	SysTick_Enable_IT;
	while	(1){}
}
