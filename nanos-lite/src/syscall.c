#include <common.h>
#include "syscall.h"

struct timeval {
	long tv_sec;		/* seconds */
	long tv_usec;	  /* and microseconds */
};

struct timezone {
	int	tz_minuteswest;	/* minutes west of Greenwich */
	int	tz_dsttime;	/* type of dst correction */
};

struct AM_TIMER_UPTIME_T {
  uint64_t us;
};

void __am_timer_uptime(struct AM_TIMER_UPTIME_T *);

static int sys_yield();
static void sys_exit(int);
static unsigned long sys_write(int, const void *, unsigned long);
static int sys_brk(unsigned long addr);
static int sys_open(const char *, int, int);
static unsigned long sys_read(int, void *, unsigned long);
static unsigned long sys_lseek(int, unsigned long, int);
static int sys_close(int);
static int sys_gettimeofday(struct timeval *, struct timezone *);

char *get_file_table_name(int);
int fs_open(const char *, int, int);
unsigned long fs_read(int, void *, unsigned long);
unsigned long fs_write(int, const void *, unsigned long);
unsigned long fs_lseek(int, unsigned long, int);
int fs_close(int);

void do_syscall(Context *c) {
  uintptr_t a[4];
  a[0] = c->GPR1;
  a[1] = c->GPR2;
  a[2] = c->GPR3;
  a[3] = c->GPR4;
  

  switch (a[0]) {
    case SYS_exit:
      #ifdef CONFIG_STRACE
        printf("SYS_EXIT(%d)\n", a[1]);
      #endif
      sys_exit(a[1]);
      break;
    case SYS_yield:
      #ifdef CONFIG_STRACE
        printf("SYS_YIELD\n");
      #endif
      c->GPRx = sys_yield();
      break;
    case SYS_write:
      c->GPRx = sys_write(a[1], (const void *)(a[2]), a[3]);
      #ifdef CONFIG_STRACE
        printf("SYS_WRITE(%s, 0x%x, %d) == %d\n", get_file_table_name(a[1]), a[2], a[3], c->GPRx);
      #endif
      break;
    case SYS_brk:
      c->GPRx = sys_brk(a[1]);
      #ifdef CONFIG_STRACE
        printf("SYS_BRK(%d) == %d\n", a[1], c->GPRx);
      #endif
      break;
    case SYS_open:
      c->GPRx = sys_open((const char *)(a[1]), a[2], a[3]);
      #ifdef CONFIG_STRACE
        printf("SYS_OPEN(%s, %d, %d) == %d\n", (const char *)(a[1]), a[2], a[3], c->GPRx);
      #endif
      break;
    case SYS_read:
      c->GPRx = sys_read(a[1], (void *)(a[2]), a[3]);
      #ifdef CONFIG_STRACE
        printf("SYS_READ(%s, (void *)buf, %d) == %d\n", get_file_table_name(a[1]), a[3], c->GPRx);
      #endif
      break;
    case SYS_lseek:
      c->GPRx = sys_lseek(a[1], a[2], a[3]);
      #ifdef CONFIG_STRACE
        printf("SYS_LSEEK(%s, %d, %d) == %d\n", get_file_table_name(a[1]), a[2], a[3], c->GPRx);
      #endif
      break;
    case SYS_close:
      c->GPRx = sys_close(a[1]);
      #ifdef CONFIG_STRACE
        printf("SYS_CLOSE(%s) == %d\n", get_file_table_name(a[1]), c->GPRx);
      #endif
      break;
    case SYS_gettimeofday:
      c->GPRx = sys_gettimeofday((struct timeval *)a[1], (struct timezone *)a[2]);
      #ifdef CONFIG_STRACE
        printf("SYS_GETTIMEOFDAY() == %d\n", c->GPRx);
      #endif
      break;
    default: panic("Unhandled syscall ID = %d", a[0]);
  }
}

static int sys_yield() {
  yield();
  return 0;
}

static void sys_exit(int exit_aug) {
  halt(exit_aug);
  return;
}

static unsigned long sys_write(int fd, const void *buf, unsigned long count) { //unsigned long
  return fs_write(fd, buf, count);
}

static int sys_brk(unsigned long addr) {
  return 0;
}

static int sys_open(const char *pathname, int flags, int mode) {
  int tmp = fs_open(pathname, flags, mode);
  //printf("fs_open == %d\n", tmp);
  return tmp;
}

static unsigned long sys_read(int fd, void *buf, unsigned long len) {
  return fs_read(fd, buf, len);
}

static unsigned long sys_lseek(int fd, unsigned long offset, int whence) {
  return fs_lseek(fd, offset, whence);
}

static int sys_close(int fd) {
  return fs_close(fd);
}

static int sys_gettimeofday(struct timeval *tv, struct timezone *tz) {
  struct {
    uint64_t us;
  }tmp_us;
  __am_timer_uptime((struct AM_TIMER_UPTIME_T *)(&tmp_us));
  tv->tv_sec = tmp_us.us / 1000000;
  tv->tv_usec = tmp_us.us % 1000000;
  return 0;
}