typedef struct watchpoint {
  int NO;
  char watch_expr[32];
  word_t last_val;
  struct watchpoint *next;

  /* TODO: Add more members if necessary */

} WP;
