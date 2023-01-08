/***************************************************************************************
* Copyright (c) 2014-2022 Zihao Yu, Nanjing University
*
* NEMU is licensed under Mulan PSL v2.
* You can use this software according to the terms and conditions of the Mulan PSL v2.
* You may obtain a copy of Mulan PSL v2 at:
*          http://license.coscl.org.cn/MulanPSL2
*
* THIS SOFTWARE IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
* EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
* MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
*
* See the Mulan PSL v2 for more details.
***************************************************************************************/

#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <assert.h>
#include <string.h>
#include <stdbool.h>

// this should be enough
static char buf[65536] = {};
static char uint_buf[70000];
static char code_buf[70200/*65536 + 128*/] = {}; // a little larger than `buf`
static char *code_format =
"#include <stdio.h>\n"
"int main() { "
"  unsigned result = %s; "
"  printf(\"%%u\", result); "
"  return 0; "
"}";

static uint32_t rand_u32() {
	uint32_t r = 0;
	for(int i=0; i<32; i++)
		r = r*2 + rand()%2;
	return r;
}
static void gen_num(int* idx, int boundary) {
	uint32_t r = rand_u32();
	if(!r)	r = 1;
	uint32_t tmp = r;
	int len = 0;
	while(tmp) {
		len++;
		tmp /= 10;
	}
	if(boundary - (*idx) < len) {
		uint32_t base = 1;
		for(int i=0; i<len-boundary+(*idx); i++)
			base *= 10;
		r /= base;
		for(int i=boundary-1; i>=(*idx); i--) {
			buf[i] = (r%10) + '0';
			r /= 10;
		}
		(*idx) = boundary;
	}else {
		for(int i=(*idx)+len-1; i>=(*idx); i--) {
			buf[i] = (r%10) + '0';
			r /= 10;
		}
		(*idx) += len;
	}
	return;
}
static void gen_rand_op(int* idx) {
	int which_op = rand() % 4;
	switch(which_op) {
		case 0: buf[*idx] = '+'; break;
		case 1: buf[*idx] = '-'; break;
		case 2: buf[*idx] = '*'; break;
		default: buf[*idx] = '/';
	}
	(*idx)++;
	return;
}
static void gen_rand_expr(int* idx, int boundary) {
	int rand_num = rand() % 3;
	bool mark = false;
	while(!mark) {
		switch(rand_num) {
			case 0: 
				mark = true;
				gen_num(idx, boundary);
				break;
			case 1:
				if(boundary - (*idx) > 2) {
					buf[*idx] = '(';
					(*idx)++;	
					gen_rand_expr(idx, boundary - 1);
					buf[*idx] = ')';
					(*idx)++;
					mark = true;
				}
				break;
			default:
				if(boundary - (*idx) > 2) {
					int idx_backup_1 = *idx;
					while(true) {
						gen_rand_expr(idx, boundary);
						if(boundary - (*idx) < 2)
							*idx = idx_backup_1;
						else
							break;
					}
					gen_rand_op(idx);
					gen_rand_expr(idx, boundary);
					mark = true;
				}
		}
	}
	return;
}

int main(int argc, char *argv[]) {
  int seed = time(NULL);
  srand(seed);
  int loop;
  if (argc > 1) {
    sscanf(argv[1], "%d", &loop);
  }
  int i;
  int expr_point = 0;
  int uint_buf_point = 0;
  for (i = 0; i < loop; i ++) {
	memset(buf, 0, sizeof(buf[0])*65536);
	memset(uint_buf, 0, sizeof(uint_buf[0])*70000);
	uint_buf_point = 0;
	expr_point = 0;
    gen_rand_expr(&expr_point, 65535);
	buf[expr_point] = '\0';

	uint_buf[uint_buf_point++] = buf[0];
	for(int i=1; i<strlen(buf); i++) {
		if((buf[i] < '0' || buf[i] > '9') && ('0' <= buf[i-1] && buf[i-1] <= '9'))
			uint_buf[uint_buf_point++] = 'u';
		uint_buf[uint_buf_point++] = buf[i];
	}
	if('0' <= uint_buf[uint_buf_point-1] && uint_buf[uint_buf_point - 1] <= '9')
		uint_buf[uint_buf_point++] = 'u';
	uint_buf[uint_buf_point] = '\0';

    sprintf(code_buf, code_format, uint_buf);

    FILE *fp = fopen("/tmp/.code.c", "w");
    assert(fp != NULL);
    fputs(code_buf, fp);
    fclose(fp);

    int ret = system("gcc /tmp/.code.c -o /tmp/.expr");
    if (ret != 0) continue;

    fp = popen("/tmp/.expr", "r");
    assert(fp != NULL);

	int return_val_fscan;
    int result;
    return_val_fscan = fscanf(fp, "%d", &result);
    pclose(fp);

	if(return_val_fscan > 0)
		printf("%u %s\n", result, buf);
  }
  return 0;
}
