// Generated by Mochi TypeScript compiler

function threeSum(nums: Array<number>): Array<Array<number>> {
  let sorted: Array<number> = (() => {
    const _src = nums;
    let _items = [];
    for (const x of _src) {
      _items.push(x);
    }
    let _pairs = _items.map((it) => {
      const x = it;
      return { item: it, key: x };
    });
    _pairs.sort((a, b) => {
      const ak = a.key;
      const bk = b.key;
      if (typeof ak === "number" && typeof bk === "number") return ak - bk;
      if (typeof ak === "string" && typeof bk === "string") {
        return ak < bk
          ? -1
          : (ak > bk ? 1 : 0);
      }
      return String(ak) < String(bk) ? -1 : (String(ak) > String(bk) ? 1 : 0);
    });
    _items = _pairs.map((p) => p.item);
    const _res = [];
    for (const x of _items) {
      _res.push(x);
    }
    return _res;
  })();
  (globalThis as any).sorted = sorted;
  let n: number = sorted.length;
  (globalThis as any).n = n;
  let res: Array<Array<number>> = [];
  (globalThis as any).res = res;
  let i: number = 0;
  (globalThis as any).i = i;
  while ((i < n)) {
    if (((i > 0) && (sorted[i] == sorted[i - 1]))) {
      i = i + 1;
      continue;
    }
    let left: number = i + 1;
    (globalThis as any).left = left;
    let right: number = n - 1;
    (globalThis as any).right = right;
    while ((left < right)) {
      let sum: number = (sorted[i] + sorted[left]) + sorted[right];
      (globalThis as any).sum = sum;
      if ((sum == 0)) {
        res = res.concat([
          [
            sorted[i],
            sorted[left],
            sorted[right],
          ],
        ]);
        left = left + 1;
        while (((left < right) && (sorted[left] == sorted[left - 1]))) {
          left = left + 1;
        }
        right = right - 1;
        while (((left < right) && (sorted[right] == sorted[right + 1]))) {
          right = right - 1;
        }
      } else if ((sum < 0)) {
        left = left + 1;
      } else {
        right = right - 1;
      }
    }
    i = i + 1;
  }
  return res;
}

function test_example_1(): void {
  if (
    !(_equal(
      threeSum([
        -1,
        0,
        1,
        2,
        -1,
        -4,
      ]),
      [
        [
          -1,
          -1,
          2,
        ],
        [
          -1,
          0,
          1,
        ],
      ],
    ))
  ) throw new Error("expect failed");
}

function test_example_2(): void {
  if (
    !(_equal(
      threeSum([
        0,
        1,
        1,
      ]),
      [],
    ))
  ) throw new Error("expect failed");
}

function test_example_3(): void {
  if (
    !(_equal(
      threeSum([
        0,
        0,
        0,
      ]),
      [
        [
          0,
          0,
          0,
        ],
      ],
    ))
  ) throw new Error("expect failed");
}

function main(): void {
  test_example_1();
  test_example_2();
  test_example_3();
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
