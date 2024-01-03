#include "matmul.h"

int* __attribute__ ( ( section ( ".mprjram" ) ) ) matmul()
{
	register int i=0;
	register int j;
	register int k;
	register int sum;
	//int kk;
	register unsigned int count = 0;
	for (i=0; i<SIZE; i++){
		for (j=0; j<SIZE; j++){
			sum = 0;
			//#pragma unroll (SIZE)
			//for(k = 0;k<SIZE;k++)
				sum += A[(i*SIZE) + 0] * B[(0*SIZE) + j];
				sum += A[(i*SIZE) + 1] * B[(1*SIZE) + j];
				sum += A[(i*SIZE) + 2] * B[(2*SIZE) + j];
				sum += A[(i*SIZE) + 3] * B[(3*SIZE) + j];
				//sum += A[(i*SIZE) + k] * B[(k*SIZE) + j];
			//result.push_back(sum);
			result[(i*SIZE) + j] = sum;
		}
	}
	return result;
}
