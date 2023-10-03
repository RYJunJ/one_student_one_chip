#include <am.h>
#include <klib.h>
#include <klib-macros.h>
#include <stdarg.h>

#if !defined(__ISA_NATIVE__) || defined(__NATIVE_USE_KLIB__)

int transfer_int(int idx, uint64_t data, bool hex, char *d_out) {
  int idx_tmp = 0;
  char tmp[20];
  //int flag = data < 0 ? 1 : 0;
  uint64_t mol_num = (hex) ? 16 : 10;
  if(!data) {
    tmp[idx_tmp] = '0';
    idx_tmp++;
  }else {
    while(data) {
      tmp[idx_tmp] = (data % mol_num) + ((data % mol_num > 9) ? ('a' - 10) : '0');//(data % mol_num < 0 ? -(data%10) : data%10) + '0';
      idx_tmp++;
      data /= mol_num;
    }
    /*
    if(flag) {
      tmp[idx_tmp] = '-';
      idx_tmp++;
    }
    */
  }
  idx_tmp--;
  while(idx_tmp >= 0) {
    d_out[idx] = tmp[idx_tmp];
    idx++;
    idx_tmp--;
  }
  return idx;
}

int transfer_char(int idx, char *src, char *dst) {
  int i = 0;
  while(src[i]) {
    dst[idx] = src[i];
    i++;
    idx++;
  }
  return idx;
}

int printf(const char *fmt, ...) {
  char tp_out[100] = "";
  const char *tp_fmt = fmt;
  char *tp_string;
  void *tp_pointer;
  uint64_t tp_int;
  unsigned long long tp_hex_int;
  va_list arg;
  va_start(arg, fmt);
  int i = 0, p_arg = 0;
  while(tp_fmt[i]) {
    if(tp_fmt[i] == '"') {
      if(!(i == 0 || tp_fmt[i+1] == '\0')) {
        putch('"');
      }
    }else {
      if(tp_fmt[i] == '%') {
        if(tp_fmt[i+1] == 'd') {
          i++;
          tp_int = va_arg(arg, int);
          p_arg = transfer_int(0, tp_int, false, tp_out);
          tp_out[p_arg] = '\0';
          putstr(tp_out);
        }else if(tp_fmt[i+1] == 's') {
          i++;
          tp_string = va_arg(arg, char*);
          putstr(tp_string);
        }else if(tp_fmt[i+1] == 'p') {
          i++;
          tp_pointer = va_arg(arg, void*);
          uint64_t prt_addr = (long unsigned int)tp_pointer;
          p_arg = transfer_int(0, prt_addr, true, tp_out);
          tp_out[p_arg] = '\0';
          putstr(tp_out);
        }else if(tp_fmt[i+1] == 'x') {
          i++;
          tp_hex_int = va_arg(arg, unsigned long long);
          p_arg = transfer_int(0, tp_hex_int, true, tp_out);
          tp_out[p_arg] = '\0';
          putstr(tp_out);
        }else if(tp_fmt[i+1] == 'l' && tp_fmt[i+2] == 'd') {
          i+=2;
          tp_int = va_arg(arg, long);
          p_arg = transfer_int(0, tp_int, false, tp_out);
          tp_out[p_arg] = '\0';
          putstr(tp_out);
        }
      }else {
        putch(tp_fmt[i]);
      }
    }
    i++;
  }
  va_end(arg);
  return 0;
}

int vsprintf(char *out, const char *fmt, va_list ap) {
  panic("Not implemented");
}

int sprintf(char *out, const char *fmt, ...) {
  char *tp_out = out;
  const char *tp_fmt = fmt;
  char *tp_string;
  void *tp_pointer;
  va_list arg;
  va_start(arg, fmt);
  int i = 0, j = 0;
  int tp_int;
  while(tp_fmt[i]) {
    //putstr(out);
    if(tp_fmt[i] == '"') {
      if(!(i == 0 || tp_fmt[i+1] == '\0')) {
        tp_out[j] = '"';
        j++;
      }
    }else {
      if(tp_fmt[i] == '%') {
        if(tp_fmt[i+1] == 'd') {
          //putstr("\nYEE\n");
          i++;
          tp_int = va_arg(arg, int);
          j = transfer_int(j, tp_int, false, tp_out);
        }else if(tp_fmt[i+1] == 's') {
          i++;
          tp_string = va_arg(arg, char*);
          j = transfer_char(j, tp_string, tp_out);
        }else if(tp_fmt[i+1] == 'p') {
          i++;
          tp_pointer = va_arg(arg, void*);
          uint64_t prt_addr = (long unsigned int)tp_pointer;
          j = transfer_int(j, prt_addr, true, tp_out);
        }else if(tp_fmt[i+1] == 'x') {
          i++;
          uint64_t tp_hex_int = va_arg(arg, unsigned long long);
          j = transfer_int(j, tp_hex_int, true, tp_out);
        }
      }else {
        tp_out[j] = tp_fmt[i];
        j++;
      }
    }
    i++;
  }
  tp_out[j] = '\0';
  //putstr(tp_out);
  va_end(arg);
  return j;
}

int snprintf(char *out, size_t n, const char *fmt, ...) {
  panic("Not implemented");
}

int vsnprintf(char *out, size_t n, const char *fmt, va_list ap) {
  panic("Not implemented");
}

#endif
