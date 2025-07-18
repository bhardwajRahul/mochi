// Generated by Mochi compiler v0.10.30 on 2025-07-18T17:11:54Z
// Generated by Mochi compiler v0.10.30 on 2025-07-18T17:11:54Z
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef struct {
  int len;
  int *data;
} list_int;
static list_int list_int_create(int len) {
  list_int l;
  l.len = len;
  l.data = calloc(len, sizeof(int));
  if (!l.data && len > 0) {
    fprintf(stderr, "alloc failed\n");
    exit(1);
  }
  return l;
}
static char *concat_string(char *a, char *b) {
  size_t len1 = strlen(a);
  size_t len2 = strlen(b);
  char *buf = (char *)malloc(len1 + len2 + 1);
  memcpy(buf, a, len1);
  memcpy(buf + len1, b, len2);
  buf[len1 + len2] = '\0';
  return buf;
}
static char *_str(int v) {
  char *buf = (char *)malloc(32);
  sprintf(buf, "%d", v);
  return buf;
}
int fib(int n) {
  if (n < 2) {
    return n;
  }
  __auto_type a = 0;
  __auto_type b = 1;
  __auto_type i = 1;
  while (i < n) {
    __auto_type t = a + b;
    a = b;
    b = t;
    i = i + 1;
  }
  return b;
}

int mochi_main() {
  list_int tmp1 = list_int_create(12);
  tmp1.data[0] = (-1);
  tmp1.data[1] = 0;
  tmp1.data[2] = 1;
  tmp1.data[3] = 2;
  tmp1.data[4] = 3;
  tmp1.data[5] = 4;
  tmp1.data[6] = 5;
  tmp1.data[7] = 6;
  tmp1.data[8] = 7;
  tmp1.data[9] = 8;
  tmp1.data[10] = 9;
  tmp1.data[11] = 10;
  for (int tmp2 = 0; tmp2 < 12; tmp2++) {
    int i = tmp1.data[tmp2];
    if (i < 0) {
      char *tmp3 = _str(i);
      char *tmp4 = concat_string("fib(", tmp3);
      char *tmp5 =
          concat_string(tmp4, ") returned error: negative n is forbidden");
      printf("%s\n", tmp5);
    } else {
      char *tmp6 = _str(i);
      char *tmp7 = concat_string("fib(", tmp6);
      char *tmp8 = concat_string(tmp7, ") = ");
      char *tmp9 = _str(fib(i));
      char *tmp10 = concat_string(tmp8, tmp9);
      printf("%s\n", tmp10);
    }
  }
}

int _mochi_main() {
  mochi_main();
  return 0;
}
int main() { return _mochi_main(); }
