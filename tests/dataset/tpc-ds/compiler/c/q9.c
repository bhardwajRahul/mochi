// Generated by Mochi compiler v0.10.26 on 2006-01-02T15:04:05Z
// Generated by Mochi compiler v0.10.26 on 2006-01-02T15:04:05Z
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
typedef struct {
  int len;
  double *data;
} list_float;
static list_float list_float_create(int len) {
  list_float l;
  l.len = len;
  l.data = calloc(len, sizeof(double));
  if (!l.data && len > 0) {
    fprintf(stderr, "alloc failed\n");
    exit(1);
  }
  return l;
}
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
  int len;
  list_int *data;
} list_list_int;
static list_list_int list_list_int_create(int len) {
  list_list_int l;
  l.len = len;
  l.data = calloc(len, sizeof(list_int));
  if (!l.data && len > 0) {
    fprintf(stderr, "alloc failed\n");
    exit(1);
  }
  return l;
}
static double _avg_float(list_float v) {
  if (v.len == 0)
    return 0;
  double sum = 0;
  for (int i = 0; i < v.len; i++)
    sum += v.data[i];
  return sum / v.len;
}
static void _json_int(int v) { printf("%d", v); }
static void _json_float(double v) { printf("%g", v); }
static void _json_string(char *s) { printf("\"%s\"", s); }
static void _json_list_int(list_int v) {
  printf("[");
  for (int i = 0; i < v.len; i++) {
    if (i > 0)
      printf(",");
    _json_int(v.data[i]);
  }
  printf("]");
}
static void _json_list_float(list_float v) {
  printf("[");
  for (int i = 0; i < v.len; i++) {
    if (i > 0)
      printf(",");
    _json_float(v.data[i]);
  }
  printf("]");
}
static void _json_list_string(list_string v) {
  printf("[");
  for (int i = 0; i < v.len; i++) {
    if (i > 0)
      printf(",");
    _json_string(v.data[i]);
  }
  printf("]");
}
static void _json_list_list_int(list_list_int v) {
  printf("[");
  for (int i = 0; i < v.len; i++) {
    if (i > 0)
      printf(",");
    _json_list_int(v.data[i]);
  }
  printf("]");
}
typedef struct {
  double bucket1;
  double bucket2;
  double bucket3;
  double bucket4;
  double bucket5;
} tmp1_t;
typedef struct {
  int len;
  tmp1_t *data;
} tmp1_list_t;
tmp1_list_t create_tmp1_list(int len) {
  tmp1_list_t l;
  l.len = len;
  l.data = calloc(len, sizeof(tmp1_t));
  if (!l.data && len > 0) {
    fprintf(stderr, "alloc failed\n");
    exit(1);
  }
  return l;
}

typedef struct {
  int ss_quantity;
  double ss_ext_discount_amt;
  double ss_net_paid;
} store_sale_t;
typedef struct {
  int len;
  store_sale_t *data;
} store_sale_list_t;
store_sale_list_t create_store_sale_list(int len) {
  store_sale_list_t l;
  l.len = len;
  l.data = calloc(len, sizeof(store_sale_t));
  if (!l.data && len > 0) {
    fprintf(stderr, "alloc failed\n");
    exit(1);
  }
  return l;
}

typedef struct {
  int r_reason_sk;
} reason_t;
typedef struct {
  int len;
  reason_t *data;
} reason_list_t;
reason_list_t create_reason_list(int len) {
  reason_list_t l;
  l.len = len;
  l.data = calloc(len, sizeof(reason_t));
  if (!l.data && len > 0) {
    fprintf(stderr, "alloc failed\n");
    exit(1);
  }
  return l;
}

typedef struct {
  double bucket1;
  double bucket2;
  double bucket3;
  double bucket4;
  double bucket5;
} result_item_t;
typedef struct {
  int len;
  result_item_t *data;
} result_item_list_t;
result_item_list_t create_result_item_list(int len) {
  result_item_list_t l;
  l.len = len;
  l.data = calloc(len, sizeof(result_item_t));
  if (!l.data && len > 0) {
    fprintf(stderr, "alloc failed\n");
    exit(1);
  }
  return l;
}

static list_int test_TPCDS_Q9_result_result;
static void test_TPCDS_Q9_result() {
  tmp1_t tmp1[] = {(tmp1_t){.bucket1 = 7.0,
                            .bucket2 = 15.0,
                            .bucket3 = 30.0,
                            .bucket4 = 35.0,
                            .bucket5 = 50.0}};
  int tmp1_len = sizeof(tmp1) / sizeof(tmp1[0]);
  int tmp2 = 1;
  if (test_TPCDS_Q9_result_result.len != tmp1.len) {
    tmp2 = 0;
  } else {
    for (int i3 = 0; i3 < test_TPCDS_Q9_result_result.len; i3++) {
      if (test_TPCDS_Q9_result_result.data[i3] != tmp1.data[i3]) {
        tmp2 = 0;
        break;
      }
    }
  }
  if (!(tmp2)) {
    fprintf(stderr, "expect failed\n");
    exit(1);
  }
}

int main() {
  store_sale_t store_sales[] = {
      (store_sale_t){
          .ss_quantity = 5, .ss_ext_discount_amt = 5.0, .ss_net_paid = 7.0},
      (store_sale_t){
          .ss_quantity = 30, .ss_ext_discount_amt = 10.0, .ss_net_paid = 15.0},
      (store_sale_t){
          .ss_quantity = 50, .ss_ext_discount_amt = 20.0, .ss_net_paid = 30.0},
      (store_sale_t){
          .ss_quantity = 70, .ss_ext_discount_amt = 25.0, .ss_net_paid = 35.0},
      (store_sale_t){
          .ss_quantity = 90, .ss_ext_discount_amt = 40.0, .ss_net_paid = 50.0}};
  int store_sales_len = sizeof(store_sales) / sizeof(store_sales[0]);
  reason_t reason[] = {(reason_t){.r_reason_sk = 1}};
  int reason_len = sizeof(reason) / sizeof(reason[0]);
  store_sale_list_t tmp4 = store_sale_list_t_create(store_sales_len);
  int tmp5 = 0;
  for (int tmp6 = 0; tmp6 < store_sales_len; tmp6++) {
    store_sale_t s = store_sales[tmp6];
    if (!(s.ss_quantity >= 1 && s.ss_quantity <= 20)) {
      continue;
    }
    tmp4.data[tmp5] = s;
    tmp5++;
  }
  tmp4.len = tmp5;
  list_float tmp7 = list_float_create(store_sales_len);
  int tmp8 = 0;
  for (int tmp9 = 0; tmp9 < store_sales_len; tmp9++) {
    store_sale_t s = store_sales[tmp9];
    if (!(s.ss_quantity >= 1 && s.ss_quantity <= 20)) {
      continue;
    }
    tmp7.data[tmp8] = s.ss_ext_discount_amt;
    tmp8++;
  }
  tmp7.len = tmp8;
  list_float tmp10 = list_float_create(store_sales_len);
  int tmp11 = 0;
  for (int tmp12 = 0; tmp12 < store_sales_len; tmp12++) {
    store_sale_t s = store_sales[tmp12];
    if (!(s.ss_quantity >= 1 && s.ss_quantity <= 20)) {
      continue;
    }
    tmp10.data[tmp11] = s.ss_net_paid;
    tmp11++;
  }
  tmp10.len = tmp11;
  double bucket1 = (tmp4.len > 10 ? _avg_float(tmp7) : _avg_float(tmp10));
  store_sale_list_t tmp13 = store_sale_list_t_create(store_sales_len);
  int tmp14 = 0;
  for (int tmp15 = 0; tmp15 < store_sales_len; tmp15++) {
    store_sale_t s = store_sales[tmp15];
    if (!(s.ss_quantity >= 21 && s.ss_quantity <= 40)) {
      continue;
    }
    tmp13.data[tmp14] = s;
    tmp14++;
  }
  tmp13.len = tmp14;
  list_float tmp16 = list_float_create(store_sales_len);
  int tmp17 = 0;
  for (int tmp18 = 0; tmp18 < store_sales_len; tmp18++) {
    store_sale_t s = store_sales[tmp18];
    if (!(s.ss_quantity >= 21 && s.ss_quantity <= 40)) {
      continue;
    }
    tmp16.data[tmp17] = s.ss_ext_discount_amt;
    tmp17++;
  }
  tmp16.len = tmp17;
  list_float tmp19 = list_float_create(store_sales_len);
  int tmp20 = 0;
  for (int tmp21 = 0; tmp21 < store_sales_len; tmp21++) {
    store_sale_t s = store_sales[tmp21];
    if (!(s.ss_quantity >= 21 && s.ss_quantity <= 40)) {
      continue;
    }
    tmp19.data[tmp20] = s.ss_net_paid;
    tmp20++;
  }
  tmp19.len = tmp20;
  double bucket2 = (tmp13.len > 20 ? _avg_float(tmp16) : _avg_float(tmp19));
  store_sale_list_t tmp22 = store_sale_list_t_create(store_sales_len);
  int tmp23 = 0;
  for (int tmp24 = 0; tmp24 < store_sales_len; tmp24++) {
    store_sale_t s = store_sales[tmp24];
    if (!(s.ss_quantity >= 41 && s.ss_quantity <= 60)) {
      continue;
    }
    tmp22.data[tmp23] = s;
    tmp23++;
  }
  tmp22.len = tmp23;
  list_float tmp25 = list_float_create(store_sales_len);
  int tmp26 = 0;
  for (int tmp27 = 0; tmp27 < store_sales_len; tmp27++) {
    store_sale_t s = store_sales[tmp27];
    if (!(s.ss_quantity >= 41 && s.ss_quantity <= 60)) {
      continue;
    }
    tmp25.data[tmp26] = s.ss_ext_discount_amt;
    tmp26++;
  }
  tmp25.len = tmp26;
  list_float tmp28 = list_float_create(store_sales_len);
  int tmp29 = 0;
  for (int tmp30 = 0; tmp30 < store_sales_len; tmp30++) {
    store_sale_t s = store_sales[tmp30];
    if (!(s.ss_quantity >= 41 && s.ss_quantity <= 60)) {
      continue;
    }
    tmp28.data[tmp29] = s.ss_net_paid;
    tmp29++;
  }
  tmp28.len = tmp29;
  double bucket3 = (tmp22.len > 30 ? _avg_float(tmp25) : _avg_float(tmp28));
  store_sale_list_t tmp31 = store_sale_list_t_create(store_sales_len);
  int tmp32 = 0;
  for (int tmp33 = 0; tmp33 < store_sales_len; tmp33++) {
    store_sale_t s = store_sales[tmp33];
    if (!(s.ss_quantity >= 61 && s.ss_quantity <= 80)) {
      continue;
    }
    tmp31.data[tmp32] = s;
    tmp32++;
  }
  tmp31.len = tmp32;
  list_float tmp34 = list_float_create(store_sales_len);
  int tmp35 = 0;
  for (int tmp36 = 0; tmp36 < store_sales_len; tmp36++) {
    store_sale_t s = store_sales[tmp36];
    if (!(s.ss_quantity >= 61 && s.ss_quantity <= 80)) {
      continue;
    }
    tmp34.data[tmp35] = s.ss_ext_discount_amt;
    tmp35++;
  }
  tmp34.len = tmp35;
  list_float tmp37 = list_float_create(store_sales_len);
  int tmp38 = 0;
  for (int tmp39 = 0; tmp39 < store_sales_len; tmp39++) {
    store_sale_t s = store_sales[tmp39];
    if (!(s.ss_quantity >= 61 && s.ss_quantity <= 80)) {
      continue;
    }
    tmp37.data[tmp38] = s.ss_net_paid;
    tmp38++;
  }
  tmp37.len = tmp38;
  double bucket4 = (tmp31.len > 40 ? _avg_float(tmp34) : _avg_float(tmp37));
  store_sale_list_t tmp40 = store_sale_list_t_create(store_sales_len);
  int tmp41 = 0;
  for (int tmp42 = 0; tmp42 < store_sales_len; tmp42++) {
    store_sale_t s = store_sales[tmp42];
    if (!(s.ss_quantity >= 81 && s.ss_quantity <= 100)) {
      continue;
    }
    tmp40.data[tmp41] = s;
    tmp41++;
  }
  tmp40.len = tmp41;
  list_float tmp43 = list_float_create(store_sales_len);
  int tmp44 = 0;
  for (int tmp45 = 0; tmp45 < store_sales_len; tmp45++) {
    store_sale_t s = store_sales[tmp45];
    if (!(s.ss_quantity >= 81 && s.ss_quantity <= 100)) {
      continue;
    }
    tmp43.data[tmp44] = s.ss_ext_discount_amt;
    tmp44++;
  }
  tmp43.len = tmp44;
  list_float tmp46 = list_float_create(store_sales_len);
  int tmp47 = 0;
  for (int tmp48 = 0; tmp48 < store_sales_len; tmp48++) {
    store_sale_t s = store_sales[tmp48];
    if (!(s.ss_quantity >= 81 && s.ss_quantity <= 100)) {
      continue;
    }
    tmp46.data[tmp47] = s.ss_net_paid;
    tmp47++;
  }
  tmp46.len = tmp47;
  double bucket5 = (tmp40.len > 50 ? _avg_float(tmp43) : _avg_float(tmp46));
  result_item_list_t tmp49 = create_result_item_list(reason_len);
  int tmp50 = 0;
  for (int tmp51 = 0; tmp51 < reason_len; tmp51++) {
    reason_t r = reason[tmp51];
    if (!(r.r_reason_sk == 1)) {
      continue;
    }
    tmp49.data[tmp50] = (result_item_t){.bucket1 = bucket1,
                                        .bucket2 = bucket2,
                                        .bucket3 = bucket3,
                                        .bucket4 = bucket4,
                                        .bucket5 = bucket5};
    tmp50++;
  }
  tmp49.len = tmp50;
  result_item_list_t result = tmp49;
  printf("[");
  for (int i52 = 0; i52 < result.len; i52++) {
    if (i52 > 0)
      printf(",");
    result_item_t it = result.data[i52];
    printf("{");
    _json_string("bucket1");
    printf(":");
    _json_float(it.bucket1);
    printf(",");
    _json_string("bucket2");
    printf(":");
    _json_float(it.bucket2);
    printf(",");
    _json_string("bucket3");
    printf(":");
    _json_float(it.bucket3);
    printf(",");
    _json_string("bucket4");
    printf(":");
    _json_float(it.bucket4);
    printf(",");
    _json_string("bucket5");
    printf(":");
    _json_float(it.bucket5);
    printf("}");
  }
  printf("]");
  test_TPCDS_Q9_result_result = result;
  test_TPCDS_Q9_result();
  free(tmp4.data);
  free(tmp7.data);
  free(tmp10.data);
  free(tmp13.data);
  free(tmp16.data);
  free(tmp19.data);
  free(tmp22.data);
  free(tmp25.data);
  free(tmp28.data);
  free(tmp31.data);
  free(tmp34.data);
  free(tmp37.data);
  free(tmp40.data);
  free(tmp43.data);
  free(tmp46.data);
  free(result.data);
  return 0;
}
