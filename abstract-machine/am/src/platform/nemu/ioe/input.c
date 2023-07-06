#include <am.h>
#include <nemu.h>

#define KEYDOWN_MASK 0x8000

void __am_input_keybrd(AM_INPUT_KEYBRD_T *kbd) {
  uint32_t key_scancode = inl(KBD_ADDR);
  kbd->keydown = ((key_scancode & KEYDOWN_MASK) == KEYDOWN_MASK);
  kbd->keycode = (key_scancode & 0x7fff);//kbd->keydown ? (key_scancode & 0x7fff) : AM_KEY_NONE;
  //if(kbd->keycode == 0);// printf("YES");
}
