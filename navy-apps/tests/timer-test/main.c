#include <stdio.h>
#include <stdbool.h>
#include <NDL.h>

int main() {
  unsigned long long last_half_sec = 0;
  while(true) {
    unsigned long long ms = NDL_GetTicks();
    if(ms / 500 > last_half_sec) {
      last_half_sec = ms / 500;
      printf("%lldth half_sec!\n", last_half_sec);
    }
  }
  return 0;
}
