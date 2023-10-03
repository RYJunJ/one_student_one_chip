#include <stdio.h>
int data[10];
char mhex(int idx) {
	int pw = 1;
	int ans = pw * data[idx-3];
	for(int i=idx-2;i<=idx;i++) {
		pw *= 2;
		ans += data[i] * pw;
	}
	if(ans > 9)
		return 'A' + (ans - 10);
	else
		return '0' + ans;
}
int main() {
	data[0] = 1;
	while(1) {
		printf("%c%c\n",mhex(7),mhex(3));
		int tmp = data[4]|data[3]|data[2]|data[0];
		for(int i=0;i<7;i++)
			data[i] = data[i+1];
		data[7] = tmp;
	}
	return 0;
}
