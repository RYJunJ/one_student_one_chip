#define SDL_malloc  malloc
#define SDL_free    free
#define SDL_realloc realloc

#define SDL_STBIMAGE_IMPLEMENTATION
#include "SDL_stbimage.h"

SDL_Surface* IMG_Load_RW(SDL_RWops *src, int freesrc) {
  assert(src->type == RW_TYPE_MEM);
  assert(freesrc == 0);
  return NULL;
}

SDL_Surface* IMG_Load(const char *filename) {
  printf("file: %s\n", filename);
  FILE *img_file = fopen(filename, "rb");
  if(!img_file) printf("\n!IMG FILE DOES NOT EXIST!\n");
  fseek(img_file, 0, SEEK_END);
  long img_size = ftell(img_file);
  void *buf = (void *)SDL_malloc(img_size);
  fseek(img_file, 0, SEEK_SET);
  fread(buf, 1, img_size, img_file);
  SDL_Surface *tmp_surf = STBIMG_LoadFromMemory((const unsigned char *)buf, img_size);
  fclose(img_file);
  SDL_free(buf);
  return tmp_surf;
}

int IMG_isPNG(SDL_RWops *src) {
  return 0;
}

SDL_Surface* IMG_LoadJPG_RW(SDL_RWops *src) {
  return IMG_Load_RW(src, 0);
}

char *IMG_GetError() {
  return "Navy does not support IMG_GetError()";
}
