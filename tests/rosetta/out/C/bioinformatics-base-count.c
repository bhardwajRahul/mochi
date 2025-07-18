// Generated by Mochi compiler v0.10.30 on 2025-07-18T17:09:40Z
// Generated by Mochi compiler v0.10.30 on 2025-07-18T17:09:40Z
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
static char *dna;
static int le;
static int i = 0;
static int a = 0;
static int c = 0;
static int g = 0;
static int t = 0;
static int idx = 0;

char *padLeft(char *s, int w) {
  __auto_type res = "";
  __auto_type n = w - strlen(s);
  while (n > 0) {
    char *tmp1 = concat_string(res, " ");
    res = tmp1;
    n = n - 1;
  }
  char *tmp2 = concat_string(res, s);
  return tmp2;
}

int _mochi_main() {
  char *tmp3 =
      concat_string("", "CGTAAAAAATTACAACGTCCTTTGGCTATCTCTTAAACTCCTGCTAAATG");
  char *tmp4 =
      concat_string(tmp3, "CTCGTGCTTTCCAATTATGTAAGCGTTCCGAGACGGGGTGGTCGATTCTG");
  char *tmp5 =
      concat_string(tmp4, "AGGACAAAGGTCAAGATGGAGCGCATCGAACGCAATAAGGATCATTTGAT");
  char *tmp6 =
      concat_string(tmp5, "GGGACGTTTCGTCGACAAAGTCTTGTTTCGAGAGTAACGGCTACCGTCTT");
  char *tmp7 =
      concat_string(tmp6, "CGATTCTGCTTATAACACTATGTTCTTATGAAATGGATGTTCTGAGTTGG");
  char *tmp8 =
      concat_string(tmp7, "TCAGTCCCAATGTGCGGGGTTTCTTTTAGTACGTCGGGAGTGGTATTATA");
  char *tmp9 =
      concat_string(tmp8, "TTTAATTTTTCTATATAGCGATCTGTATTTAAGCAATTCATTTAGGTTAT");
  char *tmp10 =
      concat_string(tmp9, "CGCCGCGATGCTCGGTTCGGACCGCCAAGCATCTGGCTCCACTGCTAGTG");
  char *tmp11 = concat_string(
      tmp10, "TCCTAAATTTGAATGGCAAACACAAATAAGATTTAGCAATTCGTGTAGAC");
  char *tmp12 = concat_string(
      tmp11, "GACCGGGGACTTGCATGATGGGAGCAGCTTTGTTAAACTACGAACGTAAT");
  dna = tmp12;
  le = strlen(dna);
  printf("SEQUENCE:\n");
  while (i < le) {
    __auto_type k = i + 50;
    if (k > le) {
      k = le;
    }
    char *tmp13 = _str(i);
    char *tmp14 = concat_string(padLeft(tmp13, 5), ": ");
    char *tmp15 = slice_string(dna, i, k);
    char *tmp16 = concat_string(tmp14, tmp15);
    printf("%s\n", tmp16);
    i = i + 50;
  }
  while (idx < le) {
    __auto_type ch = slice_string(dna, idx, idx + 1);
    if ((strcmp(ch, "A") == 0)) {
      a = a + 1;
    } else {
      if ((strcmp(ch, "C") == 0)) {
        c = c + 1;
      } else {
        if ((strcmp(ch, "G") == 0)) {
          g = g + 1;
        } else {
          if ((strcmp(ch, "T") == 0)) {
            t = t + 1;
          }
        }
      }
    }
    idx = idx + 1;
  }
  printf("\n");
  printf("BASE COUNT:\n");
  char *tmp17 = _str(a);
  char *tmp18 = concat_string("    A: ", padLeft(tmp17, 3));
  printf("%s\n", tmp18);
  char *tmp19 = _str(c);
  char *tmp20 = concat_string("    C: ", padLeft(tmp19, 3));
  printf("%s\n", tmp20);
  char *tmp21 = _str(g);
  char *tmp22 = concat_string("    G: ", padLeft(tmp21, 3));
  printf("%s\n", tmp22);
  char *tmp23 = _str(t);
  char *tmp24 = concat_string("    T: ", padLeft(tmp23, 3));
  printf("%s\n", tmp24);
  printf("    ------\n");
  char *tmp25 = _str(le);
  char *tmp26 = concat_string("    Σ: ", tmp25);
  printf("%s\n", tmp26);
  printf("    ======\n");
  return 0;
}
int main() { return _mochi_main(); }
