#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <sys/time.h>
#include <assert.h>

static int evtdev = -1;
static int fbdev = -1;
static int screen_w = 0, screen_h = 0;
static int canvas_w = 0, canvas_h = 0;
static uint32_t **canvas;
static uint32_t nanos_start_time = 0;
static int file_frame_buffer, file_events, file_gpuconfig;

uint32_t NDL_GetTicks() {
  struct timeval now;
  gettimeofday(&now, NULL);
  return (now.tv_sec * 1000000 + now.tv_usec) / 1000 - nanos_start_time;
}

int NDL_PollEvent(char *buf, int len) {
  assert(file_events >= 0);
  if(read(file_events, buf, len))
    return 1;
  return 0;
}

void NDL_OpenCanvas(int *w, int *h) {
  if(*w == 0 && *h == 0) {
    *w = screen_w;
    *h = screen_h;
  }
  canvas_w = *w;
  canvas_h = *h;
  assert(canvas_w <= screen_w && canvas_h <= screen_h);
  canvas = (uint32_t **)malloc(canvas_h * sizeof(uint32_t *));
  for(int i = 0; i < canvas_h; i++)
    canvas[i] = (uint32_t *)malloc(canvas_w * sizeof(uint32_t));
  if (getenv("NWM_APP")) {
    printf("OPEN CANVAS NWM_APP NOOOOOOO\n");
    int fbctl = 4;
    fbdev = 5;
    screen_w = *w; screen_h = *h;
    char buf[64];
    //!!! screen_w and screen_h might be changed in NDL_Init
    int len = sprintf(buf, "%d %d", screen_w, screen_h);
    // let NWM resize the window and create the frame buffer
    write(fbctl, buf, len);
    while (1) {
      // 3 = evtdev
      int nread = read(3, buf, sizeof(buf) - 1);
      if (nread <= 0) continue;
      buf[nread] = '\0';
      if (strcmp(buf, "mmap ok") == 0) break;
    }
    close(fbctl);
  }
}

void NDL_DrawRect(uint32_t *pixels, int x, int y, int w, int h) {
  int limit_y = (canvas_h < y + h) ? canvas_h : y + h;
  int limit_x = (canvas_w < x + w) ? canvas_w : x + w;
  int pt_pixel = 0;
  for(int i = y; i < limit_y; i++) {
    for(int j = x; j < limit_x; j++) {
      canvas[i][j] = pixels[(i - y) * w + (j - x)];
    }
  }
  int middle_screen_y = (screen_h - canvas_h) / 2;
  int middle_screen_x = (screen_w - canvas_w) / 2;
  //printf("middle x: %d, y: %d\n", middle_screen_x, middle_screen_y);
  for(int i = y; i < limit_y; i++) {
    lseek(file_frame_buffer, 4 * ((middle_screen_y + i) * screen_w + middle_screen_x + x), SEEK_SET);
    write(file_frame_buffer, &canvas[i][x], (limit_x - x) * 4);
  }
  return;
}

void NDL_OpenAudio(int freq, int channels, int samples) {
}

void NDL_CloseAudio() {
}

int NDL_PlayAudio(void *buf, int len) {
  return 0;
}

int NDL_QueryAudio() {
  return 0;
}

int NDL_Init(uint32_t flags) {
  if(!nanos_start_time) {
    struct timeval now_tmp;
    gettimeofday(&now_tmp, NULL);
    nanos_start_time = (now_tmp.tv_sec * 1000000 + now_tmp.tv_usec) / 1000;
  }else { //already been initialized
    close(file_gpuconfig);
    close(file_frame_buffer);
    close(file_events);
    free(canvas);
  }
  if (getenv("NWM_APP")) {
    evtdev = 3;
  }
  
  file_events = open("/dev/events", 0, 0);
  char raw_config[100];
  file_gpuconfig = open("/proc/dispinfo", 0, 0);
  read(file_gpuconfig, raw_config, 100);
  int pt_raw_config = 0;
  while(!('0' <= raw_config[pt_raw_config] && raw_config[pt_raw_config] <= '9'))
    pt_raw_config++;
  int tmp_a = 0;
  int tmp_b = 0;
  while('0' <= raw_config[pt_raw_config] && raw_config[pt_raw_config] <= '9') {
    tmp_a *= 10;
    tmp_a += (raw_config[pt_raw_config] - '0');
    pt_raw_config++;
  }
  while(!('0' <= raw_config[pt_raw_config] && raw_config[pt_raw_config] <= '9'))
    pt_raw_config++;
  while('0' <= raw_config[pt_raw_config] && raw_config[pt_raw_config] <= '9') {
    tmp_b *= 10;
    tmp_b += (raw_config[pt_raw_config] - '0');
    pt_raw_config++;
  }
  screen_w = (raw_config[0] == 'W' ? tmp_a : tmp_b);
  screen_h = (raw_config[0] == 'W' ? tmp_b : tmp_a);
  printf("width == %d, height == %d\n", screen_w, screen_h);
  file_frame_buffer = open("/dev/fb", 0, 0);
  return 0;
}

void NDL_Quit() {
  close(file_gpuconfig);
  close(file_frame_buffer);
  close(file_events);
  free(canvas);
}
