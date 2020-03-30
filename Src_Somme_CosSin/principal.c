#include "gassp72.h"
int somme(int arg);

int main(void)
{
	int max =0;
	int min = 0x40000000;
	for (int i=0; i<8;i++){
		if(somme(i)<min){
			min = somme(i);
		}
		if(somme(i)>max){
			max = somme(i);
		}
	}
	while	(1){}
}
