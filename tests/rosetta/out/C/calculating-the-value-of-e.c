// Generated by Mochi compiler v0.10.30 on 2025-07-18T17:09:49Z
// Generated by Mochi compiler v0.10.30 on 2025-07-18T17:09:49Z
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

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
static char *slice_string(char *s, int start, int end) {
  int len = strlen(s);
  if (start < 0)
    start += len;
  if (end < 0)
    end += len;
  if (start < 0)
    start = 0;
  if (end > len)
    end = len;
  if (start > end)
    start = end;
  char *buf = (char *)malloc(end - start + 1);
  memcpy(buf, s + start, end - start);
  buf[end - start] = '\0';
  return buf;
}
static double epsilon = 0.000000000000001;
static int factval = 1;
static double e = 2.0;
static int n = 2;
static double term = 1.0;

double absf(double x) {
  if (x < 0.0) {
    return (-x);
  }
  return x;
}

double pow10(int n) {
  double r = 1.0;
  __auto_type i = 0;
  while (i < n) {
    r = r * 10.0;
    i = i + 1;
  }
  return r;
}

char *formatFloat(double f, int prec) {
  __auto_type scale = pow10(prec);
  __auto_type scaled = (f * scale) + 0.5;
  __auto_type n = ((int)(scaled));
  char *tmp1 = _str(n);
  __auto_type digits = tmp1;
  while (strlen(digits) <= prec) {
    char *tmp2 = concat_string("0", digits);
    digits = tmp2;
  }
  __auto_type intPart = slice_string(digits, 0, strlen(digits) - prec);
  __auto_type fracPart =
      slice_string(digits, strlen(digits) - prec, strlen(digits));
  char *tmp3 = concat_string(intPart, ".");
  char *tmp4 = concat_string(tmp3, fracPart);
  return tmp4;
}

int _mochi_main() {
  while (1) {
    factval = factval * n;
    n = n + 1;
    term = 1.0 / ((double)(factval));
    e = e + term;
    if (absf(term) < epsilon) {
      break;
    }
  }
  char *tmp5 = concat_string("e = ", formatFloat(e, 15));
  printf("%s\n", tmp5);
  return 0;
}
int main() { return _mochi_main(); }
