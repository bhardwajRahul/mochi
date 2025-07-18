// Generated by Mochi compiler v0.10.27 on 2025-07-17T18:26:22Z
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
static char *start_date = "1995-01-01";
static char *end_date = "1996-12-31";
static char *nation1 = "FRANCE";
static char *nation2 = "GERMANY";

typedef struct {
  char *supp_nation;
  char *cust_nation;
  char *l_year;
  double revenue;
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
  int n_nationkey;
  char *n_name;
} nation_t;
typedef struct {
  int len;
  nation_t *data;
} nation_list_t;
nation_list_t create_nation_list(int len) {
  nation_list_t l;
  l.len = len;
  l.data = calloc(len, sizeof(nation_t));
  if (!l.data && len > 0) {
    fprintf(stderr, "alloc failed\n");
    exit(1);
  }
  return l;
}

typedef struct {
  int s_suppkey;
  int s_nationkey;
} supplier_t;
typedef struct {
  int len;
  supplier_t *data;
} supplier_list_t;
supplier_list_t create_supplier_list(int len) {
  supplier_list_t l;
  l.len = len;
  l.data = calloc(len, sizeof(supplier_t));
  if (!l.data && len > 0) {
    fprintf(stderr, "alloc failed\n");
    exit(1);
  }
  return l;
}

typedef struct {
  int c_custkey;
  int c_nationkey;
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
  int o_orderkey;
  int o_custkey;
} order_t;
typedef struct {
  int len;
  order_t *data;
} order_list_t;
order_list_t create_order_list(int len) {
  order_list_t l;
  l.len = len;
  l.data = calloc(len, sizeof(order_t));
  if (!l.data && len > 0) {
    fprintf(stderr, "alloc failed\n");
    exit(1);
  }
  return l;
}

typedef struct {
  int l_orderkey;
  int l_suppkey;
  double l_extendedprice;
  double l_discount;
  char *l_shipdate;
} lineitem_t;
typedef struct {
  int len;
  lineitem_t *data;
} lineitem_list_t;
lineitem_list_t create_lineitem_list(int len) {
  lineitem_list_t l;
  l.len = len;
  l.data = calloc(len, sizeof(lineitem_t));
  if (!l.data && len > 0) {
    fprintf(stderr, "alloc failed\n");
    exit(1);
  }
  return l;
}

typedef struct {
  int supp_nation;
  int cust_nation;
  int l_year;
  double revenue;
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

static list_int
    test_Q7_computes_revenue_between_FRANCE_and_GERMANY_by_year_result;
static void test_Q7_computes_revenue_between_FRANCE_and_GERMANY_by_year() {
  tmp1_t tmp1[] = {(tmp1_t){.supp_nation = "FRANCE",
                            .cust_nation = "GERMANY",
                            .l_year = "1995",
                            .revenue = 900.0}};
  int tmp1_len = sizeof(tmp1) / sizeof(tmp1[0]);
  int tmp2 = 1;
  if (test_Q7_computes_revenue_between_FRANCE_and_GERMANY_by_year_result.len !=
      tmp1_len) {
    tmp2 = 0;
  } else {
    for (int i3 = 0;
         i3 <
         test_Q7_computes_revenue_between_FRANCE_and_GERMANY_by_year_result.len;
         i3++) {
      if (test_Q7_computes_revenue_between_FRANCE_and_GERMANY_by_year_result
              .data[i3] != tmp1[i3]) {
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

int _mochi_main() {
  nation_t nation[] = {(nation_t){.n_nationkey = 1, .n_name = "FRANCE"},
                       (nation_t){.n_nationkey = 2, .n_name = "GERMANY"}};
  int nation_len = sizeof(nation) / sizeof(nation[0]);
  supplier_t supplier[] = {(supplier_t){.s_suppkey = 100, .s_nationkey = 1}};
  int supplier_len = sizeof(supplier) / sizeof(supplier[0]);
  customer_t customer[] = {(customer_t){.c_custkey = 200, .c_nationkey = 2}};
  int customer_len = sizeof(customer) / sizeof(customer[0]);
  order_t orders[] = {(order_t){.o_orderkey = 1000, .o_custkey = 200}};
  int orders_len = sizeof(orders) / sizeof(orders[0]);
  lineitem_t lineitem[] = {(lineitem_t){.l_orderkey = 1000,
                                        .l_suppkey = 100,
                                        .l_extendedprice = 1000.0,
                                        .l_discount = 0.1,
                                        .l_shipdate = "1995-06-15"},
                           (lineitem_t){.l_orderkey = 1000,
                                        .l_suppkey = 100,
                                        .l_extendedprice = 800.0,
                                        .l_discount = 0.05,
                                        .l_shipdate = "1997-01-01"}};
  int lineitem_len = sizeof(lineitem) / sizeof(lineitem[0]);
  result_item_list_t result = (result_item_list_t){0, NULL};
  printf("[");
  for (int i4 = 0; i4 < result.len; i4++) {
    if (i4 > 0)
      printf(",");
    result_item_t it = result.data[i4];
    printf("{");
    _json_string("supp_nation");
    printf(":");
    _json_int(it.supp_nation);
    printf(",");
    _json_string("cust_nation");
    printf(":");
    _json_int(it.cust_nation);
    printf(",");
    _json_string("l_year");
    printf(":");
    _json_int(it.l_year);
    printf(",");
    _json_string("revenue");
    printf(":");
    _json_float(it.revenue);
    printf("}");
  }
  printf("]");
  test_Q7_computes_revenue_between_FRANCE_and_GERMANY_by_year_result = result;
  test_Q7_computes_revenue_between_FRANCE_and_GERMANY_by_year();
  return 0;
}
int main() { return _mochi_main(); }
