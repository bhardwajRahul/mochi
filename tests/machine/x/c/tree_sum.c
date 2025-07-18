// Generated by Mochi compiler v0.10.28 on 2006-01-02T15:04:05Z
#include <stdio.h>
#include <stdlib.h>

typedef struct tree_t tree_t;
typedef struct leaf_t leaf_t;
typedef struct node_t node_t;

typedef struct leaf_t {
} leaf_t;
typedef struct node_t {
  tree_t *left;
  int value;
  tree_t *right;
} node_t;
typedef struct tree_t {
  int tag;
  union {
    leaf_t leaf_t;
    node_t node_t;
  } value;
} tree_t;
#define tree_t_leaf_t 0
#define tree_t_node_t 1

int sum_tree(tree_t t) {
  tree_t tmp1 = t;
  int tmp2;
  switch (tmp1.tag) {
  case tree_t_leaf_t:
    tmp2 = 0;
    break;
  case tree_t_node_t:
    tree_t left = *tmp1.value.node_t.left;
    int value = tmp1.value.node_t.value;
    tree_t right = *tmp1.value.node_t.right;
    tmp2 = sum_tree(left) + value + sum_tree(right);
    break;
  default:
    tmp2 = 0;
    break;
  }
  return tmp2;
}

int _mochi_main() {
  tree_t t = (tree_t){
      .tag = tree_t_node_t,
      .value.node_t = (node_t){
          .left = &(tree_t){.tag = tree_t_leaf_t},
          .value = 1,
          .right = &(tree_t){.tag = tree_t_node_t,
                             .value.node_t = (node_t){
                                 .left = &(tree_t){.tag = tree_t_leaf_t},
                                 .value = 2,
                                 .right = &(tree_t){.tag = tree_t_leaf_t}}}}};
  printf("%d\n", sum_tree(t));
  return 0;
}
int main() { return _mochi_main(); }
