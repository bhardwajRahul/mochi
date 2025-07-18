// Generated by Mochi compiler v0.10.26 on 2025-07-15T08:19:21Z
// Generated by Mochi compiler v0.10.26 on 2025-07-15T08:19:21Z
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
static int contains_list_int(list_int v, int item) {
  for (int i = 0; i < v.len; i++)
    if (v.data[i] == item)
      return 1;
  return 0;
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
static char *prefix = "forest";

typedef struct {
  const char *s_name;
  const char *s_address;
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
  const char *n_name;
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
  const char *s_name;
  const char *s_address;
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
  int p_partkey;
  const char *p_name;
} part_t;
typedef struct {
  int len;
  part_t *data;
} part_list_t;
part_list_t create_part_list(int len) {
  part_list_t l;
  l.len = len;
  l.data = calloc(len, sizeof(part_t));
  if (!l.data && len > 0) {
    fprintf(stderr, "alloc failed\n");
    exit(1);
  }
  return l;
}

typedef struct {
  int ps_partkey;
  int ps_suppkey;
  int ps_availqty;
} partsupp_t;
typedef struct {
  int len;
  partsupp_t *data;
} partsupp_list_t;
partsupp_list_t create_partsupp_list(int len) {
  partsupp_list_t l;
  l.len = len;
  l.data = calloc(len, sizeof(partsupp_t));
  if (!l.data && len > 0) {
    fprintf(stderr, "alloc failed\n");
    exit(1);
  }
  return l;
}

typedef struct {
  int l_partkey;
  int l_suppkey;
  int l_quantity;
  const char *l_shipdate;
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
  int partkey;
  int suppkey;
  double qty;
} shipped_94_item_t;
typedef struct {
  int len;
  shipped_94_item_t *data;
} shipped_94_item_list_t;
shipped_94_item_list_t create_shipped_94_item_list(int len) {
  shipped_94_item_list_t l;
  l.len = len;
  l.data = calloc(len, sizeof(shipped_94_item_t));
  if (!l.data && len > 0) {
    fprintf(stderr, "alloc failed\n");
    exit(1);
  }
  return l;
}

typedef struct {
  const char *s_name;
  const char *s_address;
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
    test_Q20_returns_suppliers_from_CANADA_with_forest_part_stock___50__of_1994_shipments_result;
static void
test_Q20_returns_suppliers_from_CANADA_with_forest_part_stock___50__of_1994_shipments() {
  tmp1_t tmp1[] = {
      (tmp1_t){.s_name = "Maple Supply", .s_address = "123 Forest Lane"}};
  int tmp1_len = sizeof(tmp1) / sizeof(tmp1[0]);
  int tmp2 = 1;
  if (test_Q20_returns_suppliers_from_CANADA_with_forest_part_stock___50__of_1994_shipments_result
          .len != tmp1.len) {
    tmp2 = 0;
  } else {
    for (
        int i3 = 0;
        i3 <
        test_Q20_returns_suppliers_from_CANADA_with_forest_part_stock___50__of_1994_shipments_result
            .len;
        i3++) {
      if (test_Q20_returns_suppliers_from_CANADA_with_forest_part_stock___50__of_1994_shipments_result
              .data[i3] != tmp1.data[i3]) {
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
  nation_t nation[] = {(nation_t){.n_nationkey = 1, .n_name = "CANADA"},
                       (nation_t){.n_nationkey = 2, .n_name = "GERMANY"}};
  int nation_len = sizeof(nation) / sizeof(nation[0]);
  supplier_t supplier[] = {(supplier_t){.s_suppkey = 100,
                                        .s_name = "Maple Supply",
                                        .s_address = "123 Forest Lane",
                                        .s_nationkey = 1},
                           (supplier_t){.s_suppkey = 200,
                                        .s_name = "Berlin Metals",
                                        .s_address = "456 Iron Str",
                                        .s_nationkey = 2}};
  int supplier_len = sizeof(supplier) / sizeof(supplier[0]);
  part_t part[] = {(part_t){.p_partkey = 10, .p_name = "forest glade bricks"},
                   (part_t){.p_partkey = 20, .p_name = "desert sand paper"}};
  int part_len = sizeof(part) / sizeof(part[0]);
  partsupp_t partsupp[] = {
      (partsupp_t){.ps_partkey = 10, .ps_suppkey = 100, .ps_availqty = 100},
      (partsupp_t){.ps_partkey = 20, .ps_suppkey = 200, .ps_availqty = 30}};
  int partsupp_len = sizeof(partsupp) / sizeof(partsupp[0]);
  lineitem_t lineitem[] = {(lineitem_t){.l_partkey = 10,
                                        .l_suppkey = 100,
                                        .l_quantity = 100,
                                        .l_shipdate = "1994-05-15"},
                           (lineitem_t){.l_partkey = 10,
                                        .l_suppkey = 100,
                                        .l_quantity = 50,
                                        .l_shipdate = "1995-01-01"}};
  int lineitem_len = sizeof(lineitem) / sizeof(lineitem[0]);
  shipped_94_item_list_t shipped_94 = (shipped_94_item_list_t){0, NULL};
  list_int tmp4 = list_int_create(partsupp.len * part.len * shipped_94.len);
  int tmp5 = 0;
  for (int tmp6 = 0; tmp6 < partsupp_len; tmp6++) {
    partsupp_t ps = partsupp[tmp6];
    for (int tmp7 = 0; tmp7 < part_len; tmp7++) {
      part_t p = part[tmp7];
      if (!(ps.ps_partkey == p.p_partkey)) {
        continue;
      }
      for (int tmp8 = 0; tmp8 < shipped_94.len; tmp8++) {
        shipped_94_item_t s = shipped_94.data[tmp8];
        if (!(ps.ps_partkey == s.partkey && ps.ps_suppkey == s.suppkey)) {
          continue;
        }
        if (!(slice_string(p.p_name, 0, strlen(prefix)) == prefix &&
              ps.ps_availqty > (0.5 * s.qty))) {
          continue;
        }
        tmp4.data[tmp5] = ps.ps_suppkey;
        tmp5++;
      }
    }
  }
  tmp4.len = tmp5;
  list_int target_partkeys = tmp4;
  result_item_list_t tmp9 =
      result_item_list_t_create(supplier.len * nation.len);
  int tmp10 = 0;
  for (int tmp11 = 0; tmp11 < supplier_len; tmp11++) {
    supplier_t s = supplier[tmp11];
    for (int tmp12 = 0; tmp12 < nation_len; tmp12++) {
      nation_t n = nation[tmp12];
      if (!(n.n_nationkey == s.s_nationkey)) {
        continue;
      }
      if (!(contains_list_int(target_partkeys, s.s_suppkey) &&
            n.n_name == "CANADA")) {
        continue;
      }
      tmp9.data[tmp10] =
          (result_item_t){.s_name = s.s_name, .s_address = s.s_address};
      tmp10++;
    }
  }
  tmp9.len = tmp10;
  result_item_list_t result = tmp9;
  printf("[");
  for (int i13 = 0; i13 < result.len; i13++) {
    if (i13 > 0)
      printf(",");
    result_item_t it = result.data[i13];
    printf("{");
    _json_string("s_name");
    printf(":");
    _json_string(it.s_name);
    printf(",");
    _json_string("s_address");
    printf(":");
    _json_string(it.s_address);
    printf("}");
  }
  printf("]");
  test_Q20_returns_suppliers_from_CANADA_with_forest_part_stock___50__of_1994_shipments_result =
      result;
  test_Q20_returns_suppliers_from_CANADA_with_forest_part_stock___50__of_1994_shipments();
  return 0;
}
