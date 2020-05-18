#include "gassp72.h"
extern short Son;
extern int LongueurSon;

extern int PeriodeSonMicroSec;

void timer_callback(void);
//int variable=0;
//int Periode_en_Tck = 1000;


typedef struct {
int position;		// index courant dans le tableau d'echantillons
int taille;		// nombre d'echantillons de l'enregistrement
short int * son;	// adresse de base du tableau d'echantillons en ROM
int resolution;		// pleine echelle du modulateur PWM
int Tech_en_Tck;	// periode d'ech. audio en periodes d'horloge CPU
} type_etat;

type_etat etat;
//int PeriodeSonTick = (72*10^6)/10989;
//int Periode_PWM_en_Tck = (1/4)*PeriodeSonTick;

int PeriodeSonTick = 6552;
int Periode_PWM_en_Tck = 65520;

int main(void)
{
	CLOCK_Configure();
	GPIO_Configure(GPIOB, 0, OUTPUT, ALT_PPULL);
	etat.resolution = PWM_Init_ff( TIM3, 3, Periode_PWM_en_Tck );
	etat.son = &Son;
	etat.taille = LongueurSon;
	etat.position=0;
	

	
	//GPIO_Configure(GPIOB,1,OUTPUT, OUTPUT_PPULL);
	Timer_1234_Init_ff(TIM4, PeriodeSonTick);
	// config port PB0 pour être utilisé par TIM3-CH3
	
	// config TIM3-CH3 en mode PWM
	
	
	Active_IT_Debordement_Timer(TIM4,2,timer_callback);
	Run_Timer(TIM4);
	while	(1){}
}
