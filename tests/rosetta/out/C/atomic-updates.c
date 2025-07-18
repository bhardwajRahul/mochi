// Generated by Mochi compiler v0.10.30 on 2025-07-18T17:09:31Z
// Generated by Mochi compiler v0.10.30 on 2025-07-18T17:09:31Z
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
static list_int concat_list_int(list_int a, list_int b) {
  list_int r = list_int_create(a.len + b.len);
  for (int i = 0; i < a.len; i++)
    r.data[i] = a.data[i];
  for (int i = 0; i < b.len; i++)
    r.data[a.len + i] = b.data[i];
  return r;
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
list_int randOrder(int seed, int n) {
  __auto_type next = (seed * 1664525 + 1013904223) % 2147483647;
  list_int tmp1 = list_int_create(2);
  tmp1.data[0] = next;
  tmp1.data[1] = next % n;
  return tmp1;
}

list_int randChaos(int seed, int n) {
  __auto_type next = (seed * 1103515245 + 12345) % 2147483647;
  list_int tmp2 = list_int_create(2);
  tmp2.data[0] = next;
  tmp2.data[1] = next % n;
  return tmp2;
}

int mochi_main() {
  __auto_type nBuckets = 10;
  __auto_type initialSum = 1000;
  list_int buckets = list_int_create(0);
  for (int i = 0; i < nBuckets; i++) {
    int tmp3_data[1];
    list_int tmp3 = {1, tmp3_data};
    tmp3.data[0] = 0;
    list_int tmp4 = concat_list_int(buckets, tmp3);
    buckets = tmp4;
  }
  __auto_type i = nBuckets;
  __auto_type dist = initialSum;
  while (i > 0) {
    __auto_type v = ((double)dist) / ((double)i);
    i = i - 1;
    buckets.data[i] = v;
    dist = dist - v;
  }
  __auto_type tc0 = 0;
  __auto_type tc1 = 0;
  __auto_type total = 0;
  __auto_type nTicks = 0;
  __auto_type seedOrder = 1;
  __auto_type seedChaos = 2;
  printf("sum  ---updates---    mean  buckets\n");
  __auto_type t = 0;
  while (t < 5) {
    __auto_type r = randOrder(seedOrder, nBuckets);
    seedOrder = r.data[0];
    __auto_type b1 = r.data[1];
    __auto_type b2 = (b1 + 1) % nBuckets;
    __auto_type v1 = buckets.data[b1];
    __auto_type v2 = buckets.data[b2];
    if ((v1 > v2)) {
      __auto_type a = (int)(((v1 - v2) / 2));
      if ((a > buckets.data[b1])) {
        a = buckets.data[b1];
      }
      buckets.data[b1] = buckets.data[b1] - a;
      buckets.data[b2] = buckets.data[b2] + a;
    } else {
      __auto_type a = (int)(((v2 - v1) / 2));
      if ((a > buckets.data[b2])) {
        a = buckets.data[b2];
      }
      buckets.data[b2] = buckets.data[b2] - a;
      buckets.data[b1] = buckets.data[b1] + a;
    }
    tc0 = tc0 + 1;
    r = randChaos(seedChaos, nBuckets);
    seedChaos = r.data[0];
    b1 = r.data[1];
    b2 = (b1 + 1) % nBuckets;
    r = randChaos(seedChaos, buckets.data[b1] + 1);
    seedChaos = r.data[0];
    __auto_type amt = r.data[1];
    if ((amt > buckets.data[b1])) {
      amt = buckets.data[b1];
    }
    buckets.data[b1] = buckets.data[b1] - amt;
    buckets.data[b2] = buckets.data[b2] + amt;
    tc1 = tc1 + 1;
    __auto_type sum = 0;
    __auto_type idx = 0;
    while (idx < nBuckets) {
      sum = sum + buckets.data[idx];
      idx = idx + 1;
    }
    total = total + tc0 + tc1;
    nTicks = nTicks + 1;
    char *tmp5 = _str(sum);
    char *tmp6 = concat_string(tmp5, " ");
    char *tmp7 = _str(tc0);
    char *tmp8 = concat_string(tmp6, tmp7);
    char *tmp9 = concat_string(tmp8, " ");
    char *tmp10 = _str(tc1);
    char *tmp11 = concat_string(tmp9, tmp10);
    char *tmp12 = concat_string(tmp11, " ");
    char *tmp13 = _str(((double)total) / ((double)nTicks));
    char *tmp14 = concat_string(tmp12, tmp13);
    char *tmp15 = concat_string(tmp14, "  ");
    char *tmp16 = _str(buckets);
    char *tmp17 = concat_string(tmp15, tmp16);
    char *tmp18 = _str(sum);
    char *tmp19 = concat_string(tmp18, " ");
    char *tmp20 = _str(tc0);
    char *tmp21 = concat_string(tmp19, tmp20);
    char *tmp22 = concat_string(tmp21, " ");
    char *tmp23 = _str(tc1);
    char *tmp24 = concat_string(tmp22, tmp23);
    char *tmp25 = concat_string(tmp24, " ");
    char *tmp26 = _str(((double)total) / ((double)nTicks));
    char *tmp27 = concat_string(tmp25, tmp26);
    char *tmp28 = concat_string(tmp27, "  ");
    char *tmp29 = _str(buckets);
    char *tmp30 = concat_string(tmp28, tmp29);
    printf("%d\n", tmp30);
    tc0 = 0;
    tc1 = 0;
    t = t + 1;
  }
}

int _mochi_main() {
  mochi_main();
  return 0;
}
int main() { return _mochi_main(); }
