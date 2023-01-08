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
#include <memory/paddr.h>
#include <isa.h>

/* We use the POSIX regex functions to process regular expressions.
 * Type 'man regex' for more information about POSIX regex functions.
 */
#include <regex.h>

enum {
  TK_NOTYPE = 1, TK_REG, TK_HEX, TK_DEC, TK_EQ, TK_NEQ, TK_AND, DEREF

  /* TODO: Add more token types */

};

static struct rule {
  const char *regex;
  int token_type;
} rules[] = {

  /* TODO: Add more  rules.
   * Pay attention to the precedence level of different rules.
   */

  {" +", TK_NOTYPE},    // spaces
  {"\\+", '+'},         // plus
  {"\\-", '-'},			// minus
  {"\\*", '*'},			// mul
  {"\\/", '/'},			// div
  {"\\(", '('},			// (
  {"\\)", ')'},			// )
  {"\\$[0-9a-z]+", TK_REG},// register
  {"0x[0-9a-zA-Z]+", TK_HEX},
  {"[0-9]+", TK_DEC},		// decimal
  {"==", TK_EQ},        // equal
  {"!=", TK_NEQ},		// not equal
  {"&&", TK_AND},		// &&
};

#define NR_REGEX ARRLEN(rules)

static regex_t re[NR_REGEX] = {};

/* Rules are used for many times.
 * Therefore we compile them only once before any usage.
 */
void init_regex() {
  int i;
  char error_msg[128];
  int ret;

  for (i = 0; i < NR_REGEX; i ++) {
    ret = regcomp(&re[i], rules[i].regex, REG_EXTENDED);
    if (ret != 0) {
      regerror(ret, &re[i], error_msg, 128);
      panic("regex compilation failed: %s\n%s", error_msg, rules[i].regex);
    }
  }
}

typedef struct token {
  int type;
  char str[32];
} Token;

static Token tokens[32] __attribute__((used)) = {};
static int nr_token __attribute__((used))  = 0;

static void my_strcpy(char* source, int num) {
	assert(num < 33);
	for(int i=0;i<num;i++)
		tokens[nr_token].str[i] = source[i];
	return;
}

static void delete_multi_operator(char* data) {
	bool mark = false, status = false;
	int data_len = strlen(data);
	int modify = -1;
	for(int i=0;i<data_len;i++) {
		if(data[i] == '+' || data[i] == '-') {
			if(!mark) {
				mark = true;
				modify = i;
				status = (data[i] == '+' ? true : false);
			}else {
				bool tmp = (data[i] == '+' ? true : false);
				status = !(status ^ tmp);
				data[i] = ' ';
			}
		}else if(data[i] != ' ' && data[i] != '\t' && modify > -1) {
			mark = false;
			data[modify] = (status ? '+' : '-');
		}
	}
}

static bool make_token(char *e) {
  int position = 0;
  int i;
  regmatch_t pmatch;

  nr_token = -1;

  delete_multi_operator(e);

  while (e[position] != '\0') {
    /* Try all rules one by one. */
    for (i = 0; i < NR_REGEX; i ++) {
	  if(e[position] == '*' && (nr_token == -1 || tokens[nr_token].type == '+' || tokens[nr_token].type == '-' || tokens[nr_token].type == '*' || tokens[nr_token].type == '/' || tokens[nr_token].type == '(' || tokens[nr_token].type == TK_EQ || tokens[nr_token].type == TK_NEQ || tokens[nr_token].type == TK_AND || tokens[nr_token].type == DEREF)) {
		tokens[++nr_token].type = DEREF;
		position += 1;
		break;
	  }else if (regexec(&re[i], e + position, 1, &pmatch, 0) == 0 && pmatch.rm_so == 0) {
        char *substr_start = e + position;
        int substr_len = pmatch.rm_eo;

        //Log("match rules[%d] = \"%s\" at position %d with len %d: %.*s", i, rules[i].regex, position, substr_len, substr_len, substr_start);

        /* TODO: Now a new token is recognized with rules[i]. Add codes
         * to record the token in the array `tokens'. For certain types
         * of tokens, some extra actions should be performed.
         */

        switch (rules[i].token_type) {
			case '+' :
				tokens[++nr_token].type = '+';
				break;
			case '-' :
				tokens[++nr_token].type = '-';
				break;
			case '*' :
				tokens[++nr_token].type = '*';
				break;
			case '/' :
				tokens[++nr_token].type = '/';
				break;
			case '(' :
				tokens[++nr_token].type = '(';
				break;
			case ')' :
				tokens[++nr_token].type = ')';
				break;
			case TK_REG :
				tokens[++nr_token].type = TK_REG;
				if(substr_start[1] != '0')
					my_strcpy(substr_start+1, substr_len-1);
				else
					my_strcpy(substr_start, substr_len);
				break;
			case TK_HEX :
				tokens[++nr_token].type = TK_HEX;
				my_strcpy(substr_start+2, substr_len-2);
				break;
			case TK_DEC :
				tokens[++nr_token].type = TK_DEC;
				my_strcpy(substr_start, substr_len);
				break;
			case TK_EQ :
				tokens[++nr_token].type = TK_EQ;
				break;
			case TK_NEQ :
				tokens[++nr_token].type = TK_NEQ;
				break;
			case TK_AND :
				tokens[++nr_token].type = TK_AND;
				break;
			default: ;
        }

		//last_match = rules[i].token_type;
		position += substr_len;
		break;
      }
    }

    if (i == NR_REGEX) {
      printf("no match at position %d\n%s\n%*.s^\n", position, e, position, "");
      return false;
    }
  }

  return true;
}

static word_t my_atoi(char* data, word_t base) {
	int tmp = strlen(data);
	word_t sum = 0;
	for(int i=0;i<tmp;i++) {
		sum *= base;
		if('0' <= data[i] && data[i] <= '9')
			sum += (data[i] - '0');
		else if( ('a' <= data[i] && data[i] <= 'z') || ('A' <= data[i] && data[i] <= 'Z') ) {
			if('a' <= data[i] && data[i] <= 'z')
				sum += (data[i] - 'a' + 10);
			else
				sum += (data[i] - 'A' + 10);
		}
	}
	return sum;
}

static bool check_parentheses(int p, int q) {
	int is_paren_match = 0;
	for(int i=p+1;i<=q-1;i++) {
		if(tokens[i].type == '(')
			is_paren_match++;
		else if(tokens[i].type == ')') {
			is_paren_match--;
			if(is_paren_match < 0)
				return false;
		}
	}
	if((!is_paren_match)&&(tokens[p].type == '(' && tokens[q].type == ')'))
		return true;
	return false;
}

static word_t eval(int p, int q) {
	if(p > q) {
		return 0;
	}
	else if(p == q) {
		if(tokens[p].type == TK_HEX)
			return my_atoi(tokens[p].str, 16);
		else if(tokens[p].type == TK_DEC)
			return my_atoi(tokens[p].str, 10);
		else if(tokens[p].type == TK_REG) {
			bool success = false;
			word_t reg_data = isa_reg_str2val(tokens[p].str, &success);
			if(success)
				return reg_data;
			else
				assert(success);
		}
	}
	else if(check_parentheses(p, q) == true) {
		return eval(p+1, q-1);
	}
	else {
		int is_in_paren = 0;
		int main_operator = -1;
		char last_operator = -1;
		for(int i=p;i<=q;i++) {
			if(tokens[i].type == '(')
				is_in_paren++;
			else if(tokens[i].type == ')')
				is_in_paren--;
			if((tokens[i].type == '+' || tokens[i].type == '-' || tokens[i].type == '*' || tokens[i].type == '/' || tokens[i].type == TK_EQ || tokens[i].type == TK_NEQ || tokens[i].type == TK_AND || tokens[i].type == DEREF) && (!is_in_paren)) {
				if(last_operator == -1) {
					main_operator = i;
					last_operator = tokens[i].type;
				}else {
					switch(tokens[i].type) {
						case '/': case '*':
							if(last_operator == '/' || last_operator == '*' || last_operator == DEREF) {
								main_operator = i;
								last_operator = tokens[i].type;
							}
							break;
						case '+': case '-':
							if(last_operator != TK_EQ && last_operator != TK_NEQ && last_operator != TK_AND) {
								main_operator = i;
								last_operator = tokens[i].type;
							}
							break;
						case TK_EQ: case TK_NEQ:
							if(last_operator != TK_AND) {
								main_operator = i;
								last_operator = tokens[i].type;
							}
							break;
						case TK_AND:
							main_operator = i;
							last_operator = tokens[i].type;
							break;
						default: assert(0);
					}
				}
			}
		}
		if(main_operator != -1) {
			word_t val1, val2;
			if(last_operator != DEREF) {
				val1 = eval(p, main_operator - 1);
				val2 = eval(main_operator + 1, q);
			}
			//printf("%u %c %u = ", val1, last_operator, val2);
			switch (last_operator) {
				case DEREF:
					paddr_t deref_addr = eval(main_operator + 1, q);
					word_t deref_data = paddr_read(deref_addr, 8);
					return deref_data;
				case '+': /*printf("%u\n", val1 + val2);*/ return (val1 + val2);
				case '-': /*printf("%u\n", val1 - val2);*/ return (val1 - val2);
				case '*': /*printf("%u\n", val1 * val2);*/ return (val1 * val2);
				case '/': /*printf("%u\n", val1 / val2);*/ return (val1 / val2);
				case TK_EQ:  return (val1 == val2);
				case TK_NEQ: return (val1 != val2);
				case TK_AND: return (val1 && val2);
				default: assert(0);
			}
		}
	}
	return 0;
}
word_t expr(char *e, bool *success) {
  memset(tokens, 0, sizeof(Token)*32);
  if (!make_token(e)) {
    *success = false;
    return 0;
  }
	
  /* TODO: Insert codes to evaluate the expression. */
  word_t tst_ans = eval(0, nr_token);
  *success = true;

  return tst_ans;
}
