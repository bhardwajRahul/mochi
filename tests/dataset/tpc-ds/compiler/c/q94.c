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
static list_int concat_list_int(list_int a, list_int b) {
  list_int r = list_int_create(a.len + b.len);
  for (int i = 0; i < a.len; i++)
    r.data[i] = a.data[i];
  for (int i = 0; i < b.len; i++)
    r.data[a.len + i] = b.data[i];
  return r;
}
static double _sum_float(list_float v) {
  double sum = 0;
  for (int i = 0; i < v.len; i++)
    sum += v.data[i];
  return sum;
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
typedef struct WebReturn WebReturn;
typedef struct DateDim DateDim;
typedef struct CustomerAddress CustomerAddress;
typedef struct WebSite WebSite;

typedef struct {
  int order_count;
  double total_shipping_cost;
  double total_net_profit;
} tmp_item_t;
typedef struct {
  int len;
  tmp_item_t *data;
} tmp_item_list_t;
tmp_item_list_t create_tmp_item_list(int len) {
  tmp_item_list_t l;
  l.len = len;
  l.data = calloc(len, sizeof(tmp_item_t));
  if (!l.data && len > 0) {
    fprintf(stderr, "alloc failed\n");
    exit(1);
  }
  return l;
}

typedef struct {
  int ws_order_number;
  int ws_ship_date_sk;
  int ws_warehouse_sk;
  int ws_ship_addr_sk;
  int ws_web_site_sk;
  double ws_net_profit;
  double ws_ext_ship_cost;
} web_sale_t;

typedef struct {
  int wr_order_number;
} web_return_t;

typedef struct {
  int d_date_sk;
  const char *d_date;
} date_dim_t;

typedef struct {
  int ca_address_sk;
  const char *ca_state;
} customer_addres_t;
typedef struct {
  int len;
  customer_addres_t *data;
} customer_addres_list_t;
customer_addres_list_t create_customer_addres_list(int len) {
  customer_addres_list_t l;
  l.len = len;
  l.data = calloc(len, sizeof(customer_addres_t));
  if (!l.data && len > 0) {
    fprintf(stderr, "alloc failed\n");
    exit(1);
  }
  return l;
}

typedef struct {
  int web_site_sk;
  const char *web_company_name;
} web_site_t;

typedef struct {
  int order_count;
  double total_shipping_cost;
  double total_net_profit;
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

typedef struct WebSale {
  int ws_order_number;
  int ws_ship_date_sk;
  int ws_warehouse_sk;
  int ws_ship_addr_sk;
  int ws_web_site_sk;
  double ws_net_profit;
  double ws_ext_ship_cost;
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

typedef struct WebReturn {
  int wr_order_number;
} WebReturn;
typedef struct {
  int len;
  web_return_t *data;
} web_return_list_t;
web_return_list_t create_web_return_list(int len) {
  web_return_list_t l;
  l.len = len;
  l.data = calloc(len, sizeof(web_return_t));
  if (!l.data && len > 0) {
    fprintf(stderr, "alloc failed\n");
    exit(1);
  }
  return l;
}

typedef struct DateDim {
  int d_date_sk;
  char *d_date;
} DateDim;
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

typedef struct CustomerAddress {
  int ca_address_sk;
  char *ca_state;
} CustomerAddress;
typedef struct {
  int len;
  customer_address_t *data;
} customer_address_list_t;
customer_address_list_t create_customer_address_list(int len) {
  customer_address_list_t l;
  l.len = len;
  l.data = calloc(len, sizeof(customer_address_t));
  if (!l.data && len > 0) {
    fprintf(stderr, "alloc failed\n");
    exit(1);
  }
  return l;
}

typedef struct WebSite {
  int web_site_sk;
  char *web_company_name;
} WebSite;
typedef struct {
  int len;
  web_site_t *data;
} web_site_list_t;
web_site_list_t create_web_site_list(int len) {
  web_site_list_t l;
  l.len = len;
  l.data = calloc(len, sizeof(web_site_t));
  if (!l.data && len > 0) {
    fprintf(stderr, "alloc failed\n");
    exit(1);
  }
  return l;
}

list_int distinct(list_int xs) {
  list_int out = list_int_create(0);
  for (int tmp1 = 0; tmp1 < xs.len; tmp1++) {
    int x = xs.data[tmp1];
    list_int tmp2 = list_int_create(0);
    if (((!contains(tmp2, x)))) {
      list_int tmp3 = list_int_create(0);
      int tmp4_data[1];
      list_int tmp4 = {1, tmp4_data};
      tmp4.data[0] = x;
      list_int tmp5 = concat_list_int(tmp3, tmp4);
      out = tmp5;
    }
  }
  list_int tmp6 = list_int_create(0);
  return tmp6;
}

static int test_TPCDS_Q94_shipping_result;
static void test_TPCDS_Q94_shipping() {
  if (!(test_TPCDS_Q94_shipping_result ==
        (tmp_item_t){.order_count = 1,
                     .total_shipping_cost = 2.0,
                     .total_net_profit = 5.0})) {
    fprintf(stderr, "expect failed\n");
    exit(1);
  }
}

int main() {
  web_sale_t web_sales[] = {(web_sale_t){.ws_order_number = 1,
                                         .ws_ship_date_sk = 1,
                                         .ws_warehouse_sk = 1,
                                         .ws_ship_addr_sk = 1,
                                         .ws_web_site_sk = 1,
                                         .ws_net_profit = 5.0,
                                         .ws_ext_ship_cost = 2.0},
                            (web_sale_t){.ws_order_number = 1,
                                         .ws_ship_date_sk = 1,
                                         .ws_warehouse_sk = 2,
                                         .ws_ship_addr_sk = 1,
                                         .ws_web_site_sk = 1,
                                         .ws_net_profit = 0.0,
                                         .ws_ext_ship_cost = 0.0},
                            (web_sale_t){.ws_order_number = 2,
                                         .ws_ship_date_sk = 1,
                                         .ws_warehouse_sk = 3,
                                         .ws_ship_addr_sk = 1,
                                         .ws_web_site_sk = 1,
                                         .ws_net_profit = 3.0,
                                         .ws_ext_ship_cost = 1.0}};
  int web_sales_len = sizeof(web_sales) / sizeof(web_sales[0]);
  web_return_t web_returns[] = {(web_return_t){.wr_order_number = 2}};
  int web_returns_len = sizeof(web_returns) / sizeof(web_returns[0]);
  date_dim_t date_dim[] = {
      (date_dim_t){.d_date_sk = 1, .d_date = "2001-02-01"}};
  int date_dim_len = sizeof(date_dim) / sizeof(date_dim[0]);
  customer_addres_t customer_address[] = {
      (customer_addres_t){.ca_address_sk = 1, .ca_state = "CA"}};
  int customer_address_len =
      sizeof(customer_address) / sizeof(customer_address[0]);
  web_site_t web_site[] = {
      (web_site_t){.web_site_sk = 1, .web_company_name = "pri"}};
  int web_site_len = sizeof(web_site) / sizeof(web_site[0]);
  web_sale_list_t tmp7 = web_sale_list_t_create(web_sales_len);
  int tmp8 = 0;
  for (int tmp9 = 0; tmp9 < web_sales_len; tmp9++) {
    web_sale_t ws2 = web_sales[tmp9];
    if (!(ws.ws_order_number == ws2.ws_order_number &&
          ws.ws_warehouse_sk != ws2.ws_warehouse_sk)) {
      continue;
    }
    tmp7.data[tmp8] = ws2;
    tmp8++;
  }
  tmp7.len = tmp8;
  web_return_list_t tmp10 = web_return_list_t_create(web_returns_len);
  int tmp11 = 0;
  for (int tmp12 = 0; tmp12 < web_returns_len; tmp12++) {
    web_return_t wr = web_returns[tmp12];
    if (!(wr.wr_order_number == ws.ws_order_number)) {
      continue;
    }
    tmp10.data[tmp11] = wr;
    tmp11++;
  }
  tmp10.len = tmp11;
  web_sale_list_t tmp13 = web_sale_list_t_create(
      web_sales.len * date_dim.len * customer_address.len * web_site.len);
  int tmp14 = 0;
  for (int tmp15 = 0; tmp15 < web_sales_len; tmp15++) {
    web_sale_t ws = web_sales[tmp15];
    for (int tmp16 = 0; tmp16 < date_dim_len; tmp16++) {
      date_dim_t d = date_dim[tmp16];
      if (!(ws.ws_ship_date_sk == d.d_date_sk)) {
        continue;
      }
      for (int tmp17 = 0; tmp17 < customer_address_len; tmp17++) {
        customer_addres_t ca = customer_address[tmp17];
        if (!(ws.ws_ship_addr_sk == ca.ca_address_sk)) {
          continue;
        }
        for (int tmp18 = 0; tmp18 < web_site_len; tmp18++) {
          web_site_t w = web_site[tmp18];
          if (!(ws.ws_web_site_sk == w.web_site_sk)) {
            continue;
          }
          if (!((strcmp(ca.ca_state, "CA") == 0) &&
                w.web_company_name == "pri" && tmp7.len > 0 &&
                tmp10.len > 0 == 0)) {
            continue;
          }
          tmp13.data[tmp14] = ws;
          tmp14++;
        }
      }
    }
  }
  tmp13.len = tmp14;
  web_sale_list_t filtered = tmp13;
  list_int tmp19 = list_int_create(filtered.len);
  int tmp20 = 0;
  for (int tmp21 = 0; tmp21 < filtered.len; tmp21++) {
    web_sale_t x = filtered.data[tmp21];
    tmp19.data[tmp20] = x.ws_order_number;
    tmp20++;
  }
  tmp19.len = tmp20;
  list_float tmp22 = list_float_create(filtered.len);
  int tmp23 = 0;
  for (int tmp24 = 0; tmp24 < filtered.len; tmp24++) {
    web_sale_t x = filtered.data[tmp24];
    tmp22.data[tmp23] = x.ws_ext_ship_cost;
    tmp23++;
  }
  tmp22.len = tmp23;
  list_float tmp25 = list_float_create(filtered.len);
  int tmp26 = 0;
  for (int tmp27 = 0; tmp27 < filtered.len; tmp27++) {
    web_sale_t x = filtered.data[tmp27];
    tmp25.data[tmp26] = x.ws_net_profit;
    tmp26++;
  }
  tmp25.len = tmp26;
  result_item_t result =
      (result_item_t){.order_count = distinct(tmp19).len,
                      .total_shipping_cost = _sum_float(tmp22),
                      .total_net_profit = _sum_float(tmp25)};
  printf("{");
  _json_string("order_count");
  printf(":");
  _json_int(result.order_count);
  printf(",");
  _json_string("total_shipping_cost");
  printf(":");
  _json_float(result.total_shipping_cost);
  printf(",");
  _json_string("total_net_profit");
  printf(":");
  _json_float(result.total_net_profit);
  printf("}");
  test_TPCDS_Q94_shipping_result = result;
  test_TPCDS_Q94_shipping();
  free(tmp7.data);
  free(tmp10.data);
  free(tmp19.data);
  free(tmp22.data);
  free(tmp25.data);
  return 0;
}
