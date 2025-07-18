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
typedef struct StoreSale StoreSale;
typedef struct HouseholdDemographics HouseholdDemographics;
typedef struct TimeDim TimeDim;
typedef struct Store Store;

typedef struct {
  int ss_sold_time_sk;
  int ss_hdemo_sk;
  int ss_store_sk;
} store_sale_t;

typedef struct {
  int hd_demo_sk;
  int hd_dep_count;
} household_demographic_t;
typedef struct {
  int len;
  household_demographic_t *data;
} household_demographic_list_t;
household_demographic_list_t create_household_demographic_list(int len) {
  household_demographic_list_t l;
  l.len = len;
  l.data = calloc(len, sizeof(household_demographic_t));
  if (!l.data && len > 0) {
    fprintf(stderr, "alloc failed\n");
    exit(1);
  }
  return l;
}

typedef struct {
  int t_time_sk;
  int t_hour;
  int t_minute;
} time_dim_t;

typedef struct {
  int s_store_sk;
  const char *s_store_name;
} store_t;

typedef struct StoreSale {
  int ss_sold_time_sk;
  int ss_hdemo_sk;
  int ss_store_sk;
} StoreSale;
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

typedef struct HouseholdDemographics {
  int hd_demo_sk;
  int hd_dep_count;
} HouseholdDemographics;
typedef struct {
  int len;
  household_demographics_t *data;
} household_demographics_list_t;
household_demographics_list_t create_household_demographics_list(int len) {
  household_demographics_list_t l;
  l.len = len;
  l.data = calloc(len, sizeof(household_demographics_t));
  if (!l.data && len > 0) {
    fprintf(stderr, "alloc failed\n");
    exit(1);
  }
  return l;
}

typedef struct TimeDim {
  int t_time_sk;
  int t_hour;
  int t_minute;
} TimeDim;
typedef struct {
  int len;
  time_dim_t *data;
} time_dim_list_t;
time_dim_list_t create_time_dim_list(int len) {
  time_dim_list_t l;
  l.len = len;
  l.data = calloc(len, sizeof(time_dim_t));
  if (!l.data && len > 0) {
    fprintf(stderr, "alloc failed\n");
    exit(1);
  }
  return l;
}

typedef struct Store {
  int s_store_sk;
  char *s_store_name;
} Store;
typedef struct {
  int len;
  store_t *data;
} store_list_t;
store_list_t create_store_list(int len) {
  store_list_t l;
  l.len = len;
  l.data = calloc(len, sizeof(store_t));
  if (!l.data && len > 0) {
    fprintf(stderr, "alloc failed\n");
    exit(1);
  }
  return l;
}

static int test_TPCDS_Q96_count_result;
static void test_TPCDS_Q96_count() {
  if (!(test_TPCDS_Q96_count_result == 3)) {
    fprintf(stderr, "expect failed\n");
    exit(1);
  }
}

int main() {
  store_sale_t store_sales[] = {
      (store_sale_t){.ss_sold_time_sk = 1, .ss_hdemo_sk = 1, .ss_store_sk = 1},
      (store_sale_t){.ss_sold_time_sk = 1, .ss_hdemo_sk = 1, .ss_store_sk = 1},
      (store_sale_t){.ss_sold_time_sk = 2, .ss_hdemo_sk = 1, .ss_store_sk = 1}};
  int store_sales_len = sizeof(store_sales) / sizeof(store_sales[0]);
  household_demographic_t household_demographics[] = {
      (household_demographic_t){.hd_demo_sk = 1, .hd_dep_count = 3}};
  int household_demographics_len =
      sizeof(household_demographics) / sizeof(household_demographics[0]);
  time_dim_t time_dim[] = {
      (time_dim_t){.t_time_sk = 1, .t_hour = 20, .t_minute = 35},
      (time_dim_t){.t_time_sk = 2, .t_hour = 20, .t_minute = 45}};
  int time_dim_len = sizeof(time_dim) / sizeof(time_dim[0]);
  store_t store[] = {(store_t){.s_store_sk = 1, .s_store_name = "ese"}};
  int store_len = sizeof(store) / sizeof(store[0]);
  store_sale_list_t tmp1 = store_sale_list_t_create(
      store_sales.len * household_demographics.len * time_dim.len * store.len);
  int tmp2 = 0;
  for (int tmp3 = 0; tmp3 < store_sales_len; tmp3++) {
    store_sale_t ss = store_sales[tmp3];
    for (int tmp4 = 0; tmp4 < household_demographics_len; tmp4++) {
      household_demographic_t hd = household_demographics[tmp4];
      if (!(ss.ss_hdemo_sk == hd.hd_demo_sk)) {
        continue;
      }
      for (int tmp5 = 0; tmp5 < time_dim_len; tmp5++) {
        time_dim_t t = time_dim[tmp5];
        if (!(ss.ss_sold_time_sk == t.t_time_sk)) {
          continue;
        }
        for (int tmp6 = 0; tmp6 < store_len; tmp6++) {
          store_t s = store[tmp6];
          if (!(ss.ss_store_sk == s.s_store_sk)) {
            continue;
          }
          if (!(t.t_hour == 20 && t.t_minute >= 30 && hd.hd_dep_count == 3 &&
                s.s_store_name == "ese")) {
            continue;
          }
          tmp1.data[tmp2] = ss;
          tmp2++;
        }
      }
    }
  }
  tmp1.len = tmp2;
  int result = tmp1.len;
  _json_int(result);
  test_TPCDS_Q96_count_result = result;
  test_TPCDS_Q96_count();
  return 0;
}
