// Generated by Mochi TypeScript compiler

function rotate(matrix: Array<Array<number>>): Array<Array<number>> {
  let n: number = matrix.length;
  (globalThis as any).n = n;
  let i: number = 0;
  (globalThis as any).i = i;
  while ((i < n)) {
    let j: number = i;
    (globalThis as any).j = j;
    while ((j < n)) {
      let temp: number = matrix[i][j];
      (globalThis as any).temp = temp;
      matrix[i][j] = matrix[j][i];
      matrix[j][i] = temp;
      j = j + 1;
    }
    i = i + 1;
  }
  i = 0;
  while ((i < n)) {
    let left: number = 0;
    (globalThis as any).left = left;
    let right: number = n - 1;
    (globalThis as any).right = right;
    while ((left < right)) {
      let tmp: number = matrix[i][left];
      (globalThis as any).tmp = tmp;
      matrix[i][left] = matrix[i][right];
      matrix[i][right] = tmp;
      left = left + 1;
      right = right - 1;
    }
    i = i + 1;
  }
  return matrix;
}

function test_example_1(): void {
  let m: Array<Array<number>> = [
    [
      1,
      2,
      3,
    ],
    [
      4,
      5,
      6,
    ],
    [
      7,
      8,
      9,
    ],
  ];
  (globalThis as any).m = m;
  rotate(m);
  if (
    !(_equal(m, [
      [
        7,
        4,
        1,
      ],
      [
        8,
        5,
        2,
      ],
      [
        9,
        6,
        3,
      ],
    ]))
  ) throw new Error("expect failed");
}

function test_example_2(): void {
  let m: Array<Array<number>> = [
    [
      5,
      1,
      9,
      11,
    ],
    [
      2,
      4,
      8,
      10,
    ],
    [
      13,
      3,
      6,
      7,
    ],
    [
      15,
      14,
      12,
      16,
    ],
  ];
  (globalThis as any).m = m;
  rotate(m);
  if (
    !(_equal(m, [
      [
        15,
        13,
        2,
        5,
      ],
      [
        14,
        3,
        4,
        1,
      ],
      [
        12,
        6,
        8,
        9,
      ],
      [
        16,
        7,
        10,
        11,
      ],
    ]))
  ) throw new Error("expect failed");
}

function test_single_element(): void {
  let m: Array<Array<number>> = [[1]];
  (globalThis as any).m = m;
  rotate(m);
  if (!(_equal(m, [[1]]))) throw new Error("expect failed");
}

function main(): void {
  test_example_1();
  test_example_2();
  test_single_element();
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
