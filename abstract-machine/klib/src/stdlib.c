#include <am.h>
#include <klib.h>
#include <klib-macros.h>
#include <stdint.h>

#if !defined(__ISA_NATIVE__) || defined(__NATIVE_USE_KLIB__)
static unsigned long int next = 1;
static char *mal_addr = NULL;

int rand(void) {
  // RAND_MAX assumed to be 32767
  next = next * 1103515245 + 12345;
  return (unsigned int)(next/65536) % 32768;
}

void srand(unsigned int seed) {
  next = seed;
}

int abs(int x) {
  return (x < 0 ? -x : x);
}

int atoi(const char* nptr) {
  int x = 0;
  while (*nptr == ' ') { nptr ++; }
  while (*nptr >= '0' && *nptr <= '9') {
    x = x * 10 + *nptr - '0';
    nptr ++;
  }
  return x;
}

static void reverse(char str[], int length) {
    int start = 0;
    int end = length - 1;
    while (start < end) {
        char temp = str[start];
        str[start] = str[end];
        str[end] = temp;
        end--;
        start++;
    }
}

char* itoa(int num, char* str, int base) {
  int i = 0;
  bool isNegative = false;
 
  /* Handle 0 explicitly, otherwise empty string is
   * printed for 0 */
  if (num == 0) {
      str[0] = '0';
      str[1] = '\0';
      return str;
  }
 
  // In standard itoa(), negative numbers are handled
  // only with base 10. Otherwise numbers are
  // considered unsigned.
  if (num < 0 && base == 10) {
      isNegative = true;
      num = -num;
  }
 
  // Process individual digits
  while (num != 0) {
      int rem = num % base;
      str[i++] = (rem > 9) ? (rem - 10) + 'a' : rem + '0';
      num = num / base;
  }
 
  // If number is negative, append '-'
  if (isNegative)
      str[i++] = '-';
 
  str[i] = '\0'; // Append string terminator
 
  // Reverse the string
  reverse(str, i);
 
  return str;
}

void *malloc(size_t size) {
  // On native, malloc() will be called during initializaion of C runtime.
  // Therefore do not call panic() here, else it will yield a dead recursion:
  //   panic() -> putchar() -> (glibc) -> malloc() -> panic()
#if !(defined(__ISA_NATIVE__) && defined(__NATIVE_USE_KLIB__))
    size = (size_t)ROUNDUP(size, 8);
    char *old = (!mal_addr) ? (void *)ROUNDUP(heap.start, 8) : mal_addr;
    if(!mal_addr)
      mal_addr = (void *)ROUNDUP(heap.start, 8) + size;
    else
      mal_addr += size;
    assert((uintptr_t)heap.start <= (uintptr_t)mal_addr && (uintptr_t)mal_addr <= (uintptr_t)heap.end);
    //while((mal_addr - heap.start) % 8)
    //  mal_addr++;
    for(uint64_t *p = (uint64_t *)old; p != (uint64_t *)mal_addr; p ++)
      *p = 0;
    //assert((uintptr_t)mal_addr - (uintptr_t)heap.start <= setting->mlim);
#endif
  return old;
}

void free(void *ptr) {
}

#endif
