#include <NDL.h>
#include <SDL.h>
#include <string.h>
#include <assert.h>
#include <stdio.h>

#define keyname(k) #k,

static SDL_Event event_queue[500];
static int queue_head = 0;
static int queue_tail = 0;
static uint8_t key_state[100];

static const char *keyname[] = {
  "NONE",
  _KEYS(keyname)
};

void SDL_PumpEvents(void) {
  char raw_event[50];
  if(NDL_PollEvent(raw_event, 49) == 0) return;
  if(raw_event[1] == 'u')
    event_queue[queue_head].type = SDL_KEYUP;
  else
    event_queue[queue_head].type = SDL_KEYDOWN;
  raw_event[strlen(raw_event) - 1] = '\0';
  int i = 0;
  while(strcmp(raw_event + 3, keyname[i]))
    i++;
  event_queue[queue_head].key.keysym.sym = i;

  //update keyboard short cut
  if(event_queue[queue_head].type == SDL_KEYUP)
    key_state[event_queue[queue_head].key.keysym.sym] = 0;
  else
    key_state[event_queue[queue_head].key.keysym.sym] = 1;

  queue_head = (queue_head + 1 == 500 ? 0 : queue_head + 1);
  return;
}

int SDL_PushEvent(SDL_Event *ev) {  //into queue
  printf("!!Should not reach SDL_PushEvent!!\n");
  assert(0);
  return 0;
}

int SDL_PollEvent(SDL_Event *ev) {  //out queue
  SDL_PumpEvents();
  if(ev) {
    if(queue_head == queue_tail) return 0;
    ev->type = event_queue[queue_tail].type;
    ev->key.keysym.sym = event_queue[queue_tail].key.keysym.sym;
    queue_tail = (queue_tail + 1 == 500 ? 0 : queue_tail + 1);
    return 1;
  }else
    return (queue_head != queue_tail);
}

int SDL_WaitEvent(SDL_Event *event) {
  SDL_PumpEvents();
  while(queue_head == queue_tail) SDL_PumpEvents();
  event->type = event_queue[queue_tail].type;
  event->key.keysym.sym = event_queue[queue_tail].key.keysym.sym;
  queue_tail = (queue_tail + 1 == 500 ? 0 : queue_tail + 1);
  return 1;
}

int SDL_PeepEvents(SDL_Event *ev, int numevents, int action, uint32_t mask) { //into queue
  printf("!!Should not reach SDL_PeepEvents!!\n");
  assert(0);
  return 0;
}

uint8_t* SDL_GetKeyState(int *numkeys) {
	if (numkeys)
		*numkeys = 83;
	return key_state;
}
