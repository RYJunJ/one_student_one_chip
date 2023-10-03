#include <NDL.h>
#include <assert.h>
#include <stdio.h>

extern uint32_t sdl_start_time;

int SDL_Init(uint32_t flags) {
  NDL_Init(flags);
  sdl_start_time = NDL_GetTicks();
  return 0;
}

void SDL_Quit() {
  NDL_Quit();
}

char *SDL_GetError() {
  return "Navy does not support SDL_GetError()";
}

int SDL_SetError(const char* fmt, ...) {
  printf("!!Should not reach SDL_SetError!!\n");
  assert(0);
  return -1;
}

int SDL_ShowCursor(int toggle) {
  printf("!!Should not reach SDL_ShowCursor!!\n");
  assert(0);
  return 0;
}

void SDL_WM_SetCaption(const char *title, const char *icon) {
  /*
  printf("!!Should not reach SDL_WM_SetCaption!!\n");
  assert(0);
  */
}
