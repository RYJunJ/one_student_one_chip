#include <NDL.h>
#include <sdl-timer.h>
#include <stdio.h>
#include <assert.h>

uint32_t sdl_start_time = 0;

SDL_TimerID SDL_AddTimer(uint32_t interval, SDL_NewTimerCallback callback, void *param) {
  printf("!!Should not reach SDL_AddTimer!!\n");
  assert(0);
  return NULL;
}

int SDL_RemoveTimer(SDL_TimerID id) {
  printf("!!Should not reach SDL_RemoveTimer!!\n");
  assert(0);
  return 1;
}

uint32_t SDL_GetTicks() {
  return NDL_GetTicks() - sdl_start_time;
}

void SDL_Delay(uint32_t ms) {
  uint32_t start = NDL_GetTicks();
  while(1) {
    uint32_t tmp_time = NDL_GetTicks() - start;
    if(tmp_time > 9 && tmp_time >= ms)
      return;
  }
}
