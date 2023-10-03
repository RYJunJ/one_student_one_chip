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
#include <cpu/cpu.h>
#include <difftest-def.h>
#include <memory/paddr.h>

void difftest_memcpy(uint32_t addr, uint8_t *buf, size_t n, bool direction) {
  if(direction == DIFFTEST_TO_REF) {
    for(int i = 0; i < n; i++) {
      paddr_write(addr + i, 1, *(buf + i));
    }
  }
  return;
}

void difftest_regcpy(uint64_t *dut, bool direction) {
  if(direction == DIFFTEST_TO_REF) {
    for(int i = 0; i < 32; i++) {
      //printf("YES!!!!!!! == %d\n", dut == NULL);
      cpu.gpr[i] = dut[i];
    }
  }else {
    for(int i = 0; i < 32; i++) {
      dut[i] = cpu.gpr[i];
    }
  }
  return;
}

void difftest_exec(uint64_t n) {
  cpu_exec(n);
  return;
}

void difftest_raise_intr(word_t NO) {
  return;
}

void difftest_init() {
  /* Perform ISA dependent initialization. */
  init_isa();
  return;
}
