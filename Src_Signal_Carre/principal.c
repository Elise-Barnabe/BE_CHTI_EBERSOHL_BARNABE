#include "gassp72.h"

void timer_callback(void);
int variable=0;
int Periode_en_Tck = 10;

int main(void)
{
	CLOCK_Configure();
	GPIO_Configure(GPIOB,1,OUTPUT, OUTPUT_PPULL);
	Timer_1234_Init_ff(TIM4, Periode_en_Tck);
	Active_IT_Debordement_Timer(TIM4,2,timer_callback);
	Run_Timer(TIM4);
	while	(1){}
}
