#include <sdl-file.h>
#include <assert.h>
#include <stdio.h>

SDL_RWops* SDL_RWFromFile(const char *filename, const char *mode) {
  printf("!!Should not reach SDL_RWFromFile!!\n");
  assert(0);
  return NULL;
}

SDL_RWops* SDL_RWFromMem(void *mem, int size) {
  printf("!!Should not reach SDL_RWFromMem!!\n");
  assert(0);
  return NULL;
}
