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
  int customer_id;
  const char *customer_first_name;
  const char *customer_last_name;
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
  int c_customer_sk;
  int c_customer_id;
  const char *c_first_name;
  const char *c_last_name;
} customer_t;
typedef struct {
  int len;
  customer_t *data;
} customer_list_t;
customer_list_t create_customer_list(int len) {
  customer_list_t l;
  l.len = len;
  l.data = calloc(len, sizeof(customer_t));
  if (!l.data && len > 0) {
    fprintf(stderr, "alloc failed\n");
    exit(1);
  }
  return l;
}

typedef struct {
  int d_date_sk;
  int d_year;
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

typedef struct {
  int ss_customer_sk;
  int ss_sold_date_sk;
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
  int ws_bill_customer_sk;
  int ws_sold_date_sk;
  double ws_net_paid;
} web_sale_t;
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

typedef struct {
  int customer_id;
  int customer_first_name;
  int customer_last_name;
  int year;
  double year_total;
  const char *sale_type;
} c_item_t;
typedef struct {
  int len;
  c_item_t *data;
} c_item_list_t;
c_item_list_t create_c_item_list(int len) {
  c_item_list_t l;
  l.len = len;
  l.data = calloc(len, sizeof(c_item_t));
  if (!l.data && len > 0) {
    fprintf(stderr, "alloc failed\n");
    exit(1);
  }
  return l;
}

typedef struct {
  int customer_id;
  int customer_first_name;
  int customer_last_name;
  int year;
  double year_total;
  const char *sale_type;
} c_item1_t;
typedef struct {
  int len;
  c_item1_t *data;
} c_item1_list_t;
c_item1_list_t create_c_item1_list(int len) {
  c_item1_list_t l;
  l.len = len;
  l.data = calloc(len, sizeof(c_item1_t));
  if (!l.data && len > 0) {
    fprintf(stderr, "alloc failed\n");
    exit(1);
  }
  return l;
}

typedef struct {
  int customer_id;
  int customer_first_name;
  int customer_last_name;
} result_t;
typedef struct {
  int len;
  result_t *data;
} result_list_t;
result_list_t create_result_list(int len) {
  result_list_t l;
  l.len = len;
  l.data = calloc(len, sizeof(result_t));
  if (!l.data && len > 0) {
    fprintf(stderr, "alloc failed\n");
    exit(1);
  }
  return l;
}

static list_int test_TPCDS_Q74_simplified_result;
static void test_TPCDS_Q74_simplified() {
  tmp1_t tmp1[] = {(tmp1_t){.customer_id = 1,
                            .customer_first_name = "Alice",
                            .customer_last_name = "Smith"}};
  int tmp1_len = sizeof(tmp1) / sizeof(tmp1[0]);
  int tmp2 = 1;
  if (test_TPCDS_Q74_simplified_result.len != tmp1.len) {
    tmp2 = 0;
  } else {
    for (int i3 = 0; i3 < test_TPCDS_Q74_simplified_result.len; i3++) {
      if (test_TPCDS_Q74_simplified_result.data[i3] != tmp1.data[i3]) {
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
  customer_t customer[] = {(customer_t){.c_customer_sk = 1,
                                        .c_customer_id = 1,
                                        .c_first_name = "Alice",
                                        .c_last_name = "Smith"}};
  int customer_len = sizeof(customer) / sizeof(customer[0]);
  date_dim_t date_dim[] = {(date_dim_t){.d_date_sk = 1, .d_year = 1998},
                           (date_dim_t){.d_date_sk = 2, .d_year = 1999}};
  int date_dim_len = sizeof(date_dim) / sizeof(date_dim[0]);
  store_sale_t store_sales[] = {
      (store_sale_t){
          .ss_customer_sk = 1, .ss_sold_date_sk = 1, .ss_net_paid = 100.0},
      (store_sale_t){
          .ss_customer_sk = 1, .ss_sold_date_sk = 2, .ss_net_paid = 110.0}};
  int store_sales_len = sizeof(store_sales) / sizeof(store_sales[0]);
  web_sale_t web_sales[] = {
      (web_sale_t){
          .ws_bill_customer_sk = 1, .ws_sold_date_sk = 1, .ws_net_paid = 40.0},
      (web_sale_t){
          .ws_bill_customer_sk = 1, .ws_sold_date_sk = 2, .ws_net_paid = 80.0}};
  int web_sales_len = sizeof(web_sales) / sizeof(web_sales[0]);
  int year_total = concat((c_item_list_t){0, NULL}, (c_item1_list_t){0, NULL});
  int s_firstyear = first(0);
  int s_secyear = first(0);
  int w_firstyear = first(0);
  int w_secyear = first(0);
  result_t result[] = {
      (result_t){.customer_id = s_secyear.customer_id,
                 .customer_first_name = s_secyear.customer_first_name,
                 .customer_last_name = s_secyear.customer_last_name}};
  int result_len = sizeof(result) / sizeof(result[0]);
  list_int tmp4 = list_int_create(0);
  list_int result =
      ((s_firstyear.year_total > 0 && w_firstyear.year_total > 0 &&
        (w_secyear.year_total / w_firstyear.year_total) >
            (s_secyear.year_total / s_firstyear.year_total))
           ? result
           : tmp4);
  _json_int(result.len);
  test_TPCDS_Q74_simplified_result = result;
  test_TPCDS_Q74_simplified();
  return 0;
}
