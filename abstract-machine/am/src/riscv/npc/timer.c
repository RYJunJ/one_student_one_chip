#include <am.h>
#include "/home/yjunj/ysyx-workbench/abstract-machine/am/src/riscv/riscv.h"

void __am_timer_init() {
}

void __am_timer_uptime(AM_TIMER_UPTIME_T *uptime) {
  //uptime->us = in64(RTC_ADDR);
  uint64_t low = inl(RTC_ADDR);
  uint64_t high = inl(RTC_ADDR + 4);
  uptime->us = (high << 32) + low;
}

void __am_timer_rtc(AM_TIMER_RTC_T *rtc) {
  rtc->second = 0;
  rtc->minute = 0;
  rtc->hour   = 0;
  rtc->day    = 0;
  rtc->month  = 0;
  rtc->year   = 1900;
}
