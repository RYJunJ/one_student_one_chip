#include <common.h>

//typedef struct { bool keydown; int keycode; } AM_INPUT_KEYBRD_T;
void __am_input_keybrd(AM_INPUT_KEYBRD_T *);

#if defined(MULTIPROGRAM) && !defined(TIME_SHARING)
# define MULTIPROGRAM_YIELD() yield()
#else
# define MULTIPROGRAM_YIELD()
#endif

#define NAME(key) \
  [AM_KEY_##key] = #key,

static const char *keyname[256] __attribute__((used)) = {
  [AM_KEY_NONE] = "NONE",
  AM_KEYS(NAME)
};

size_t serial_write(const void *buf, size_t offset, size_t len) {
  for(int i = 0 ; i < len ; i++)
    putch(((char *)buf)[i]);
  return len;
}

size_t events_read(void *buf, size_t offset, size_t len) {
  long cur_len = 0;
  int pt_buf = 0;
  AM_INPUT_KEYBRD_T ev = io_read(AM_INPUT_KEYBRD);
  if(ev.keycode != AM_KEY_NONE && strlen(keyname[ev.keycode]) + 5 <= len) {
    ((char *)buf)[pt_buf] = 'k';
    ((char *)buf)[pt_buf + 1] = ev.keydown ? 'd' : 'u';
    ((char *)buf)[pt_buf + 2] = ' ';
    pt_buf += 3;
    int i = 0;
    while((keyname[ev.keycode])[i]) {
      ((char *)buf)[pt_buf] = (keyname[ev.keycode])[i];
      pt_buf++;
      i++;
    }
    ((char *)buf)[pt_buf] = '\n';
    pt_buf++;
    cur_len += strlen(keyname[ev.keycode]) + 4;
  }
  ((char *)buf)[pt_buf] = '\0';
  return cur_len;
}

size_t dispinfo_read(void *buf, size_t offset, size_t len) {
  return 0;
}

size_t fb_write(const void *buf, size_t offset, size_t len) {
  return 0;
}

void init_device() {
  Log("Initializing devices...");
  ioe_init();
}
