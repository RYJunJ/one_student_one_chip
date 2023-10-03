#include <am.h>
#include <nemu.h>
#include <stdio.h>

#define SYNC_ADDR (VGACTL_ADDR + 4)

void __am_gpu_init() {
  int i;
  int w = inw(VGACTL_ADDR + 2);  // TODO: get the correct width
  int h = inw(VGACTL_ADDR);  // TODO: get the correct height
  uint32_t *fb = (uint32_t *)(uintptr_t)FB_ADDR;
  for (i = 0; i < w * h; i ++)
    fb[i] = i; 
  outl(SYNC_ADDR, 1);
}

void __am_gpu_config(AM_GPU_CONFIG_T *cfg) {
  uint16_t height = inw(VGACTL_ADDR);
  uint16_t width = inw(VGACTL_ADDR + 2);
  *cfg = (AM_GPU_CONFIG_T) {
    .present = true, .has_accel = false,
    .width = width, .height = height,
    .vmemsz = width * height * 32
  };
}

void __am_gpu_fbdraw(AM_GPU_FBDRAW_T *ctl) {
  if (ctl->sync) {
    outl(SYNC_ADDR, 1);
  }
  uint16_t width = inw(VGACTL_ADDR + 2);
  uint32_t *fb = (uint32_t *)(uintptr_t)FB_ADDR;
  for(int i = 0; i < ((ctl->w) * (ctl->h)); i++) {
    fb[(ctl->y + (i / (ctl->w))) * width + (ctl->x + (i % (ctl->w)))] = ((uint32_t *)(ctl->pixels))[i];
  }
}

void __am_gpu_status(AM_GPU_STATUS_T *status) {
  status->ready = true;
}
