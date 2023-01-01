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

#include <common.h>

void init_monitor(int, char *[]);
void am_init_monitor();
void engine_start();
int is_exit_status_bad();
word_t expr(char *, bool *);
static char main_expr_data[65540];

int main(int argc, char *argv[])
{
  /* Initialize the monitor. */
#ifdef CONFIG_TARGET_AM
  am_init_monitor();
#else
  init_monitor(argc, argv);
#endif

  /* Start engine. */
  engine_start();
  /*
  FILE *fp = fopen("/home/yjunj/ysyx-workbench/nemu/tools/gen-expr/build/input", "r");
  assert(fp != NULL);
  int cnt = 0;
  word_t ans = 0;
  while(fscanf(fp, "%u %s", &ans, main_expr_data)) {
  bool exp_succ;
  word_t tst_ans = expr(main_expr_data, &exp_succ);
  if(ans == tst_ans)
    printf("Success at point:%d\n",cnt++);
  else {
    printf("Failed at point:%d\n",cnt++);
    break;
  }
  memset(main_expr_data, 0, sizeof(main_expr_data[0])*65540);
  }
  fclose(fp);
  */
  is_exit_status_bad();
  return 0;
}
