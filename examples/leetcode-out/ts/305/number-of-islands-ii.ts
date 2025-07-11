// Generated by Mochi TypeScript compiler

function numIslands2(
  m: number,
  n: number,
  positions: Array<Array<number>>,
): Array<number> {
  let parent: Array<number> = [];
  (globalThis as any).parent = parent;
  let rank: Array<number> = [];
  (globalThis as any).rank = rank;
  let land: Array<boolean> = [];
  (globalThis as any).land = land;
  let i: number = 0;
  (globalThis as any).i = i;
  while ((i < (m * n))) {
    parent = parent.concat([i]);
    rank = rank.concat([0]);
    land = land.concat([false]);
    i = i + 1;
  }
  function find(x: number): number {
    let p: number = parent[x];
    (globalThis as any).p = p;
    while ((p != parent[p])) {
      parent[p] = parent[parent[p]];
      p = parent[p];
    }
    parent[x] = p;
    return p;
  }
  function unite(a: number, b: number, count: number): number {
    let pa: number = find(a);
    (globalThis as any).pa = pa;
    let pb: number = find(b);
    (globalThis as any).pb = pb;
    if ((pa == pb)) {
      return count;
    }
    if ((rank[pa] < rank[pb])) {
      parent[pa] = pb;
    } else if ((rank[pa] > rank[pb])) {
      parent[pb] = pa;
    } else {
      parent[pb] = pa;
      rank[pa] = rank[pa] + 1;
    }
    return (count - 1);
  }
  let result: Array<number> = [];
  (globalThis as any).result = result;
  let count: number = 0;
  (globalThis as any).count = count;
  let idx: number = 0;
  (globalThis as any).idx = idx;
  while ((idx < positions.length)) {
    let r: number = positions[idx][0];
    (globalThis as any).r = r;
    let c: number = positions[idx][1];
    (globalThis as any).c = c;
    let id: number = (r * n) + c;
    (globalThis as any).id = id;
    if ((!land[id])) {
      land[id] = true;
      count = count + 1;
      if ((r > 0)) {
        let up: number = ((r - 1) * n) + c;
        (globalThis as any).up = up;
        if (land[up]) {
          count = unite(id, up, count);
        }
      }
      if (((r + 1) < m)) {
        let down: number = ((r + 1) * n) + c;
        (globalThis as any).down = down;
        if (land[down]) {
          count = unite(id, down, count);
        }
      }
      if ((c > 0)) {
        let left: number = (r * n) + (c - 1);
        (globalThis as any).left = left;
        if (land[left]) {
          count = unite(id, left, count);
        }
      }
      if (((c + 1) < n)) {
        let right: number = (r * n) + (c + 1);
        (globalThis as any).right = right;
        if (land[right]) {
          count = unite(id, right, count);
        }
      }
    }
    result = result.concat([count]);
    idx = idx + 1;
  }
  return result;
}

function test_example_1(): void {
  let m: number = 3;
  (globalThis as any).m = m;
  let n: number = 3;
  (globalThis as any).n = n;
  let positions: Array<Array<number>> = [
    [
      0,
      0,
    ],
    [
      0,
      1,
    ],
    [
      1,
      2,
    ],
    [
      2,
      1,
    ],
    [
      1,
      1,
    ],
  ];
  (globalThis as any).positions = positions;
  if (
    !(_equal(numIslands2(m, n, positions), [
      1,
      1,
      2,
      3,
      1,
    ]))
  ) throw new Error("expect failed");
}

function test_add_same_cell(): void {
  let m: number = 1;
  (globalThis as any).m = m;
  let n: number = 2;
  (globalThis as any).n = n;
  let positions: Array<Array<number>> = [
    [
      0,
      0,
    ],
    [
      0,
      1,
    ],
    [
      0,
      1,
    ],
  ];
  (globalThis as any).positions = positions;
  if (
    !(_equal(numIslands2(m, n, positions), [
      1,
      1,
      1,
    ]))
  ) throw new Error("expect failed");
}

function test_single_cell(): void {
  if (
    !(_equal(
      numIslands2(1, 1, [
        [
          0,
          0,
        ],
      ]),
      [1],
    ))
  ) throw new Error("expect failed");
}

function main(): void {
  test_example_1();
  test_add_same_cell();
  test_single_cell();
}
function _equal(a: any, b: any): boolean {
  if (Array.isArray(a) && Array.isArray(b)) {
    if (a.length !== b.length) return false;
    for (let i = 0; i < a.length; i++) if (!_equal(a[i], b[i])) return false;
    return true;
  }
  if (a && b && typeof a === "object" && typeof b === "object") {
    const ak = Object.keys(a);
    const bk = Object.keys(b);
    if (ak.length !== bk.length) return false;
    for (const k of ak) {
      if (!bk.includes(k) || !_equal((a as any)[k], (b as any)[k])) {
        return false;
      }
    }
    return true;
  }
  return a === b;
}

main();
