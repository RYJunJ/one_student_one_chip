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

#include "sdb.h"
#include <watchpoint.h>

#define NR_WP 32

static WP wp_pool[NR_WP] = {};
static WP *head = NULL, *free_ = NULL;

WP* new_wp();
void free_wp(WP *wp);

WP* get_wp_head() {
	return head;
}

WP* new_wp() {
	assert(free_);
	WP* tmp = free_;
	free_ = (*free_).next;
	(*tmp).next = head;
	head = tmp;
	return tmp;	
}

void free_wp(WP* to_free) {
	WP* tmp = head;
	while(tmp)
		if(tmp->next == to_free || tmp == to_free)
			break;
	if(tmp == to_free)
		head = to_free->next;
	else if(tmp->next == to_free)
		tmp->next = to_free->next;
	(*to_free).NO = 0;
	memset((*to_free).watch_expr, 0, sizeof(char)*32);
	(*to_free).last_val = 0;
	(*to_free).next = free_;
	free_ = to_free;
}

void init_wp_pool() {
  int i;
  for (i = 0; i < NR_WP; i ++) {
    wp_pool[i].NO = i;
	memset(wp_pool[i].watch_expr, 0, sizeof(char)*32);
    wp_pool[i].next = (i == NR_WP - 1 ? NULL : &wp_pool[i + 1]);
  }

  head = NULL;
  free_ = wp_pool;
}

/* TODO: Implement the functionality of watchpoint */

