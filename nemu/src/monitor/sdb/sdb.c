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

#include <isa.h>
#include <watchpoint.h>
#include <cpu/cpu.h>
#include <memory/paddr.h>
#include <readline/readline.h>
#include <readline/history.h>
#include "sdb.h"

static int is_batch_mode = false;
static int wp_num = 0;

WP *new_wp();
void free_wp(WP *);
WP *get_wp_head();
void init_regex();
void init_wp_pool();

/* We use the `readline' library to provide more flexibility to read from stdin. */
static char *rl_gets()
{
  static char *line_read = NULL;

  if (line_read)
  {
    free(line_read);
    line_read = NULL;
  }

  line_read = readline("(nemu) ");

  if (line_read && *line_read)
  {
    add_history(line_read);
  }

  return line_read;
}

static int cmd_c(char *args)
{
  cpu_exec(-1);
  return 0;
}

static int cmd_q(char *args)
{
  return -1;
}

static int cmd_help(char *args);

static int cmd_si(char *args)
{
  int step_number = atoi(args);
  cpu_exec(step_number);
  return 0;
}

static int cmd_info(char *args)
{
  if (args[0] == 'r')
  {
    isa_reg_display();
  }
  else if (args[0] == 'w')
  {
    WP *info_head = get_wp_head();
    if (!info_head)
      printf("No Watch Point\n");
    else
    {
      printf("Num\tLAST VAL\t\t\tEXPR\n");
      while (info_head)
      {
        printf("#%d\tlast_val = %" PRIx64 "\tEXPR: %s\n", (*info_head).NO, (*info_head).last_val, (*info_head).watch_expr);
        info_head = info_head->next;
      }
    }
  }
  return 0;
}

static int cmd_x(char *args)
{
  int n_4byte = atoi(args);
  bool success = false;
  args = strtok(args, " ");
  args = strtok(NULL, " ");
  paddr_t x_addr = expr(args, &success);
  if (!success)
    printf("Error in Calculating EXPR\n");
  else
  {
    for (int i = 0; i < n_4byte; i++)
      printf("[0x%8x]: 0x%8lx\n", x_addr + i * 4, paddr_read(x_addr + i * 4, 4));
  }
  return 0;
}

static int cmd_p(char *args)
{
  bool success_calculate = false;
  word_t cmd_p_data = expr(args, &success_calculate);
  if (!success_calculate)
    printf("Error in Calcuating EXPR\n");
  else
    printf("EXPR = %" PRIx64 "\n", cmd_p_data);
  return 0;
}

static int cmd_w(char *args)
{
  WP *watch_point = new_wp();
  (*watch_point).NO = wp_num++;
  strcpy((*watch_point).watch_expr, args);
  bool cmd_w_success = false;
  (*watch_point).last_val = expr(args, &cmd_w_success);
  assert(cmd_w_success);
  return 0;
}

static int cmd_d(char *args)
{
  bool is_delete = false;
  int delete_num = atoi(args);
  WP *delete_head = get_wp_head();
  if (!delete_head)
    printf("No Watch Point\n");
  else
  {
    while (delete_head)
    {
      if ((*delete_head).NO == delete_num)
      {
        free_wp(delete_head);
        is_delete = true;
        break;
      }
      delete_head = delete_head->next;
    }
  }
  if (!is_delete)
    printf("ERROR: Can't find Watch Point\n");
  return 0;
}

static struct
{
  const char *name;
  const char *description;
  int (*handler)(char *);
} cmd_table[] = {
    {"help", "Display information about all supported commands", cmd_help},
    {"c", "Continue the execution of the program", cmd_c},
    {"q", "Exit NEMU", cmd_q},
    {"si", "Step in [N] steps", cmd_si},
    {"info", "Print register status[info r], or watch point status[info w]", cmd_info},
    {"x", "Print Mem [x 10 $esp]", cmd_x},
    {"p", "Calculate Expr", cmd_p},
    {"w", "Add Watch Point", cmd_w},
    {"d", "Delete Watch Point#[N]", cmd_d}
    /* TODO: Add more commands */

};

#define NR_CMD ARRLEN(cmd_table)

static int cmd_help(char *args)
{
  /* extract the first argument */
  char *arg = strtok(NULL, " ");
  int i;

  if (arg == NULL)
  {
    /* no argument given */
    for (i = 0; i < NR_CMD; i++)
    {
      printf("%s - %s\n", cmd_table[i].name, cmd_table[i].description);
    }
  }
  else
  {
    for (i = 0; i < NR_CMD; i++)
    {
      if (strcmp(arg, cmd_table[i].name) == 0)
      {
        printf("%s - %s\n", cmd_table[i].name, cmd_table[i].description);
        return 0;
      }
    }
    printf("Unknown command '%s'\n", arg);
  }
  return 0;
}

void sdb_set_batch_mode()
{
  is_batch_mode = true;
}

void sdb_mainloop()
{
  if (is_batch_mode)
  {
    cmd_c(NULL);
    return;
  }

  for (char *str; (str = rl_gets()) != NULL;)
  {
    char *str_end = str + strlen(str);

    /* extract the first token as the command */
    char *cmd = strtok(str, " ");
    if (cmd == NULL)
    {
      continue;
    }

    /* treat the remaining string as the arguments,
     * which may need further parsing
     */
    char *args = cmd + strlen(cmd) + 1;
    if (args >= str_end)
    {
      args = NULL;
    }

#ifdef CONFIG_DEVICE
    extern void sdl_clear_event_queue();
    sdl_clear_event_queue();
#endif

    int i;
    for (i = 0; i < NR_CMD; i++)
    {
      if (strcmp(cmd, cmd_table[i].name) == 0)
      {
        if (cmd_table[i].handler(args) < 0)
        {
          return;
        }
        break;
      }
    }

    if (i == NR_CMD)
    {
      printf("Unknown command '%s'\n", cmd);
    }
  }
}

void init_sdb()
{
  /* Compile the regular expressions. */
  init_regex();

  /* Initialize the watchpoint pool. */
  init_wp_pool();
}
