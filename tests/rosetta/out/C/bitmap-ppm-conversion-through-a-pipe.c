// Generated by Mochi compiler v0.10.30 on 2025-07-18T17:09:43Z
// Generated by Mochi compiler v0.10.30 on 2025-07-18T17:09:43Z
#include <stdio.h>
#include <stdlib.h>
#include <time.h>

static long long _now() {
  struct timespec ts;
  clock_gettime(CLOCK_REALTIME, &ts);
  return (long long)ts.tv_sec * 1000000000LL + ts.tv_nsec;
}
typedef struct pixel_t pixel_t;
typedef struct bitmap_t bitmap_t;

typedef struct pixel_t {
  int R;
  int G;
  int B;
} pixel_t;
typedef struct {
  int len;
  pixel_t *data;
} pixel_list_t;
pixel_list_t create_pixel_list(int len) {
  pixel_list_t l;
  l.len = len;
  l.data = calloc(len, sizeof(pixel_t));
  if (!l.data && len > 0) {
    fprintf(stderr, "alloc failed\n");
    exit(1);
  }
  return l;
}

typedef struct bitmap_t {
  int cols;
  int rows;
  list_int px;
} bitmap_t;
typedef struct {
  int len;
  bitmap_t *data;
} bitmap_list_t;
bitmap_list_t create_bitmap_list(int len) {
  bitmap_list_t l;
  l.len = len;
  l.data = calloc(len, sizeof(bitmap_t));
  if (!l.data && len > 0) {
    fprintf(stderr, "alloc failed\n");
    exit(1);
  }
  return l;
}

pixel_t pixelFromRgb(int c) {
  __auto_type r = ((int)((((double)c) / ((double)65536)))) % 256;
  __auto_type g = ((int)((((double)c) / ((double)256)))) % 256;
  __auto_type b = c % 256;
  return (pixel_t){.r = r, .g = g, .b = b};
}

int rgbFromPixel(pixel_t *p) { return p->r * 65536 + p->g * 256 + p->b; }

bitmap_t NewBitmap(int x, int y) {
  __auto_type row = 0;
  while (row < y) {
    pixel_list_t r = {0, NULL};
    __auto_type col = 0;
    while (col < x) {
      pixel_list_t tmp1 = create_pixel_list(r.len + 1);
      for (int i2 = 0; i2 < r.len; i2++) {
        tmp1.data[i2] = r.data[i2];
      }
      tmp1.data[r.len] = (pixel_t){.r = 0, .g = 0, .b = 0};
      tmp1.len = r.len + 1;
      r = tmp1;
      col = col + 1;
    }
    data = 0;
    row = row + 1;
  }
  return (bitmap_t){.cols = x, .rows = y, .px = data};
}

int FillRgb(bitmap_t *b, int c) {
  __auto_type y = 0;
  __auto_type p = pixelFromRgb(c);
  while (y < b->rows) {
    __auto_type x = 0;
    while (x < b->cols) {
      __auto_type px = b->px;
      __auto_type row = px.data[y];
      row.data[x] = p;
      px.data[y] = row;
      b->px = px;
      x = x + 1;
    }
    y = y + 1;
  }
}

int SetPxRgb(bitmap_t *b, int x, int y, int c) {
  if (x < 0 || x >= b->cols || y < 0 || y >= b->rows) {
    return 0;
  }
  __auto_type px = b->px;
  __auto_type row = px.data[y];
  row.data[x] = pixelFromRgb(c);
  px.data[y] = row;
  b->px = px;
  return 1;
}

int nextRand(int seed) { return (seed * 1664525 + 1013904223) % 2147483648; }

int mochi_main() {
  __auto_type bm = NewBitmap(400, 300);
  FillRgb(&bm, 12615744);
  __auto_type seed = _now();
  __auto_type i = 0;
  while (i < 2000) {
    seed = nextRand(seed);
    __auto_type x = seed % 400;
    seed = nextRand(seed);
    __auto_type y = seed % 300;
    SetPxRgb(&bm, x, y, 8405024);
    i = i + 1;
  }
  __auto_type x = 0;
  while (x < 400) {
    __auto_type y = 240;
    while (y < 245) {
      SetPxRgb(&bm, x, y, 8405024);
      y = y + 1;
    }
    y = 260;
    while (y < 265) {
      SetPxRgb(&bm, x, y, 8405024);
      y = y + 1;
    }
    x = x + 1;
  }
  __auto_type y = 0;
  while (y < 300) {
    __auto_type x = 80;
    while (x < 85) {
      SetPxRgb(&bm, x, y, 8405024);
      x = x + 1;
    }
    x = 95;
    while (x < 100) {
      SetPxRgb(&bm, x, y, 8405024);
      x = x + 1;
    }
    y = y + 1;
  }
}

int _mochi_main() {
  mochi_main();
  return 0;
}
int main() { return _mochi_main(); }
