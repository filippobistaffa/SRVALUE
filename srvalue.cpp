#include "srvalue.h"

int main(int argc, char *argv[]) {

	agent *csbuf = (agent *)malloc(sizeof(agent) * (K + 1) * N);
	chunk l[C] = {0};

	agent nc = readcs(argv[1], csbuf, l);
	unsigned seed = atoi(argv[2]);

	for (agent i = 0; i < nc; i++)
		QSORT(agent, csbuf + i * (K + 1) + 1, csbuf[i * (K + 1)], LTL);

	meter *sp = createsp(seed);
	value tot = 0;

	for (agent i = 0; i < nc; i++) {
		const value val = srvalue(csbuf + i * (K + 1), l, sp);
		#ifndef CSV
		printbuf(csbuf + i * (K + 1) + 1, csbuf[i * (K + 1)], NULL, NULL, " = ");
		printf("%.2f\n", val);
		#endif
		tot += val;
	}

	#ifdef CSV
	printf("%.2f\n", tot);
	#else
	printf("Solution = %.2f\n", tot);
	#endif
	free(csbuf);
	free(sp);

	return 0;
}
