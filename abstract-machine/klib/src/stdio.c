#include <am.h>
#include <klib.h>
#include <klib-macros.h>
#include <stdarg.h>

#if !defined(__ISA_NATIVE__) || defined(__NATIVE_USE_KLIB__)

int transfer_int(int idx, int data, char *d_out) {
  int idx_tmp = 0;
  char tmp[20];
  int flag = data < 0 ? 1 : 0;
  if(!data) {
    tmp[idx_tmp] = '0';
    idx_tmp++;
  }else {
    while(data) {
      tmp[idx_tmp] = (data%10 < 0 ? -(data%10) : data%10) + '0';
      idx_tmp++;
      data /= 10;
    }
    if(flag) {
      tmp[idx_tmp] = '-';
      idx_tmp++;
    }
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
  va_list arg;
  va_start(arg, fmt);
  int i = 0, p_arg = 0;//, j = 0;
  int tp_int;
  while(tp_fmt[i]) {
    //putstr(out);
    if(tp_fmt[i] == '"') {
      if(!(i == 0 || tp_fmt[i+1] == '\0')) {
        putch('"');
        //tp_out[j] = '"';
        //j++;
      }
    }else {
      if(tp_fmt[i] == '%') {
        if(tp_fmt[i+1] == 'd') {
          //putstr("\nYEE\n");
          i++;
          tp_int = va_arg(arg, int);
          p_arg = transfer_int(0, tp_int, tp_out);
          tp_out[p_arg] = '\0';
          putstr(tp_out);
        }else if(tp_fmt[i+1] == 's') {
          i++;
          tp_string = va_arg(arg, char*);
          putstr(tp_string);
          //j = transfer_char(j, tp_string, tp_out);
        }
      }else {
        putch(tp_fmt[i]);
        //tp_out[j] = tp_fmt[i];
        //j++;
      }
    }
    i++;
  }
  //tp_out[j] = '\0';
  //putstr(tp_out);
  va_end(arg);
  //return j;
  /*
  char tp_prin_str[1000] = "";
  va_list prin_arg;
  va_start(prin_arg, fmt);
  sprintf(tp_prin_str, fmt, prin_arg);
  putstr(tp_prin_str);
  va_end(prin_arg);
  */
  return 0;
}

int vsprintf(char *out, const char *fmt, va_list ap) {
  panic("Not implemented");
}

int sprintf(char *out, const char *fmt, ...) {
  char *tp_out = out;
  const char *tp_fmt = fmt;
  char *tp_string;
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
          j = transfer_int(j, tp_int, tp_out);
        }else if(tp_fmt[i+1] == 's') {
          i++;
          tp_string = va_arg(arg, char*);
          j = transfer_char(j, tp_string, tp_out);
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
