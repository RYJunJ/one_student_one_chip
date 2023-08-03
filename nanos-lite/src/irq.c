#include <common.h>
void do_syscall(Context *);

static Context* do_event(Event e, Context* c) {
  switch (e.event) {
    case EVENT_YIELD: 
      printf("YIELD_EVENT!\n");
      #ifdef NEMU_NATIVE
        //printf("NATIVE KSP + 4\n");
        c->ksp  = c->ksp  + 4;
      #else
        //printf("NON NATIVE!\n");
        c->mepc = c->mepc + 4;
      #endif
      break;
    case EVENT_SYSCALL:
      #ifdef CONFIG_STRACE
        printf("SYSCALL from pc: 0x%x, ", c->mepc);
      #endif
      do_syscall(c);
      #ifdef NEMU_NATIVE
        c->ksp  = c->ksp  + 4;
      #else
        c->mepc = c->mepc + 4;
      #endif
      break;
    default: panic("Unhandled event ID = %d", c->mcause /*e.event*/);
  }

  return c;
}

void init_irq(void) {
  Log("Initializing interrupt/exception handler...");
  cte_init(do_event);
}
