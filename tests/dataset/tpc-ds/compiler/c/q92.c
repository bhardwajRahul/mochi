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
static double _sum_float(list_float v) {
  double sum = 0;
  for (int i = 0; i < v.len; i++)
    sum += v.data[i];
  return sum;
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
typedef struct WebSale WebSale;

typedef struct {
  int ws_item_sk;
  int ws_sold_date_sk;
  double ws_ext_discount_amt;
} web_sale_t;

typedef struct {
  int i_item_sk;
  int i_manufact_id;
} item_t;
typedef struct {
  int len;
  item_t *data;
} item_list_t;
item_list_t create_item_list(int len) {
  item_list_t l;
  l.len = len;
  l.data = calloc(len, sizeof(item_t));
  if (!l.data && len > 0) {
    fprintf(stderr, "alloc failed\n");
    exit(1);
  }
  return l;
}

typedef struct {
  int d_date_sk;
  const char *d_date;
} date_dim_t;
typedef struct {
  int len;
  date_dim_t *data;
} date_dim_list_t;
date_dim_list_t create_date_dim_list(int len) {
  date_dim_list_t l;
  l.len = len;
  l.data = calloc(len, sizeof(date_dim_t));
  if (!l.data && len > 0) {
    fprintf(stderr, "alloc failed\n");
    exit(1);
  }
  return l;
}

typedef struct WebSale {
  int ws_item_sk;
  int ws_sold_date_sk;
  double ws_ext_discount_amt;
} WebSale;
typedef struct {
  int len;
  web_sale_t *data;
} web_sale_list_t;
web_sale_list_t create_web_sale_list(int len) {
  web_sale_list_t l;
  l.len = len;
  l.data = calloc(len, sizeof(web_sale_t));
  if (!l.data && len > 0) {
    fprintf(stderr, "alloc failed\n");
    exit(1);
  }
  return l;
}

static double test_TPCDS_Q92_threshold_result;
static void test_TPCDS_Q92_threshold() {
  if (!(test_TPCDS_Q92_threshold_result == 4.0)) {
    fprintf(stderr, "expect failed\n");
    exit(1);
  }
}

int main() {
  web_sale_t web_sales[] = {
      (web_sale_t){
          .ws_item_sk = 1, .ws_sold_date_sk = 1, .ws_ext_discount_amt = 1.0},
      (web_sale_t){
          .ws_item_sk = 1, .ws_sold_date_sk = 1, .ws_ext_discount_amt = 1.0},
      (web_sale_t){
          .ws_item_sk = 1, .ws_sold_date_sk = 1, .ws_ext_discount_amt = 2.0}};
  int web_sales_len = sizeof(web_sales) / sizeof(web_sales[0]);
  item_t item[] = {(item_t){.i_item_sk = 1, .i_manufact_id = 1}};
  int item_len = sizeof(item) / sizeof(item[0]);
  date_dim_t date_dim[] = {
      (date_dim_t){.d_date_sk = 1, .d_date = "2000-01-02"}};
  int date_dim_len = sizeof(date_dim) / sizeof(date_dim[0]);
  list_float tmp1 = list_float_create(web_sales_len);
  int tmp2 = 0;
  for (int tmp3 = 0; tmp3 < web_sales_len; tmp3++) {
    web_sale_t ws = web_sales[tmp3];
    tmp1.data[tmp2] = ws.ws_ext_discount_amt;
    tmp2++;
  }
  tmp1.len = tmp2;
  double sum_amt = _sum_float(tmp1);
  list_float tmp4 = list_float_create(web_sales_len);
  int tmp5 = 0;
  for (int tmp6 = 0; tmp6 < web_sales_len; tmp6++) {
    web_sale_t ws = web_sales[tmp6];
    tmp4.data[tmp5] = ws.ws_ext_discount_amt;
    tmp5++;
  }
  tmp4.len = tmp5;
  double avg_amt = _avg_float(tmp4);
  double result = (sum_amt > avg_amt * 1.3 ? sum_amt : 0.0);
  _json_float(result);
  test_TPCDS_Q92_threshold_result = result;
  test_TPCDS_Q92_threshold();
  free(tmp1.data);
  free(tmp4.data);
  return 0;
}
