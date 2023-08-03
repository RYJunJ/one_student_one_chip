#include <klib.h>
#include <klib-macros.h>
#include <stdint.h>
#include <stdlib.h>

#if !defined(__ISA_NATIVE__) || defined(__NATIVE_USE_KLIB__)

size_t strlen(const char *s) {
  size_t cnt = 0;
  int i = 0;
  while(s[i]) {
    cnt++;
    i++;
  }
  return cnt;
}

char *strcpy(char *dst, const char *src) {
  int i = 0;
  while(src[i]) {
    dst[i] = src[i];
    i++;
  }
  dst[i] = '\0';
  return dst;
}

char *strncpy(char *dst, const char *src, size_t n) {
  size_t i;
  for (i = 0; i < n && src[i] != '\0'; i++)
    dst[i] = src[i];
  for ( ; i < n; i++)
    dst[i] = '\0';
  return dst;
}

char *strcat(char *dst, const char *src) {
  int i = 0, j = 0;
  while(dst[i])
    i++;
  while(src[j]) {
    dst[i] = src[j];
    i++;
    j++;
  }
  dst[i] = '\0';
  return dst;
}

int strcmp(const char *s1, const char *s2) {
  int i = -1, tmp = -1;
  unsigned char tp1, tp2;
  do {
    i++;
    tp1 = s1[i];
    tp2 = s2[i];
    tmp = tp1 - tp2;
    if(tmp)
      break;
  }while(s1[i]&&s2[i]);
  return (tmp < 0) ? -1 : (tmp > 0 ? 1 : 0);
}

int strncmp(const char *s1, const char *s2, size_t n) {
  int i = -1, tmp;
  unsigned char tp1, tp2;
  do {
    i++;
    tp1 = s1[i];
    tp2 = s2[i];
    tmp = tp1 - tp2;
    if(tmp || (i == n-1))
      break;
  }while(s1[i]&&s2[i]);
  return tmp;
}

void *memset(void *s, int c, size_t n) {
  unsigned char *tmp = s;
  for(int i = 0; i < n; i++)
    tmp[i] = c;
  return s;
}

void *memmove(void *dst, const void *src, size_t n) {
  unsigned char *tmp = (unsigned char *)malloc(n+5);
  const unsigned char *tp_src = src;
  unsigned char *tp_dst = dst;
  for(int i = 0; i < n; i++)
    tmp[i] = tp_src[i];
  for(int i = 0; i < n; i++)
    tp_dst[i] = tmp[i];
  free(tmp);
  return dst;
}

void *memcpy(void *out, const void *in, size_t n) {
  const unsigned char *tp_src = in;
  unsigned char *tp_dst = out;
  //printf("MEMCPY: out == %p, in == %p\n", out, in);
  for(int i = 0; i < n; i++)
    tp_dst[i] = tp_src[i];
  return out;
}

int memcmp(const void *s1, const void *s2, size_t n) {
  int i = -1, tmp;
  const unsigned char *tp1 = s1;
  const unsigned char *tp2 = s2;
  do {
    i++;
    tmp = tp1[i] - tp2[i];
    if(tmp || (i == n-1))
      break;
  }while(tp1[i]&&tp2[i]);
  return tmp;
}

#endif
