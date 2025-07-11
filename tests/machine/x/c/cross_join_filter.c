#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef struct {
  int len;
  char **data;
} list_string;
static list_string list_string_create(int len) {
  list_string l;
  l.len = len;
  l.data = calloc(len, sizeof(char *));
  if (!l.data && len > 0) {
    fprintf(stderr, "alloc failed\n");
    exit(1);
  }
  return l;
}
typedef struct {
  int n;
  char *l;
} PairsItem;
typedef struct {
  int len;
  PairsItem *data;
} list_PairsItem;
static list_PairsItem list_PairsItem_create(int len) {
  list_PairsItem l;
  l.len = len;
  l.data = calloc(len, sizeof(PairsItem));
  if (!l.data && len > 0) {
    fprintf(stderr, "alloc failed\n");
    exit(1);
  }
  return l;
}

int main() {
  int nums[] = {1, 2, 3};
  char *tmp1_data[] = {"A", "B"};
  list_string tmp1 = {2, tmp1_data};
  list_string letters = tmp1;
  int tmp2[] = {1, 2, 3};
  list_PairsItem tmp3 = list_PairsItem_create(3 * letters.len);
  int tmp4 = 0;
  for (int n_idx = 0; n_idx < 3; n_idx++) {
    int n = tmp2[n_idx];
    for (int l_idx = 0; l_idx < letters.len; l_idx++) {
      char *l = letters.data[l_idx];
      if (!(n % 2 == 0)) {
        continue;
      }
      tmp3.data[tmp4] = (PairsItem){.n = n, .l = l};
      tmp4++;
    }
  }
  tmp3.len = tmp4;
  list_PairsItem pairs = tmp3;
  printf("%s\n", "--- Even pairs ---");
  for (int tmp5 = 0; tmp5 < pairs.len; tmp5++) {
    PairsItem p = pairs.data[tmp5];
    printf("%d ", p.n);
    printf("%s\n", p.l);
  }
  return 0;
}
