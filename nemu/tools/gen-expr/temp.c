#include <cstdio>
#include <cstdlib>
#include <ctime>
using namespace std;
int sim_time;
void tst(int n) {
	printf("%d\n",rand()%100);
	if(n)
		tst(n-1);
	return;
}
int main() {
	srand(time(0));
	tst(50);
	return 0;
}
