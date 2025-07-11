// Generated by Mochi TypeScript compiler

function formatRange(start: number, end: number): string {
  if ((start == end)) {
    return String(start);
  }
  return String(start) + "->" + String(end);
}

function findMissingRanges(
  nums: Array<number>,
  lower: number,
  upper: number,
): Array<string> {
  let result: Array<string> = [];
  (globalThis as any).result = result;
  let prev: number = lower - 1;
  (globalThis as any).prev = prev;
  let i: number = 0;
  (globalThis as any).i = i;
  while ((i <= nums.length)) {
    let curr: number = 0;
    (globalThis as any).curr = curr;
    if ((i == nums.length)) {
      curr = upper + 1;
    } else {
      curr = nums[i];
    }
    if (((curr - prev) >= 2)) {
      result = result.concat([formatRange(prev + 1, curr - 1)]);
    }
    prev = curr;
    i = i + 1;
  }
  return result;
}

function test_example_1(): void {
  if (
    !(_equal(
      findMissingRanges(
        [
          0,
          1,
          3,
          50,
          75,
        ],
        0,
        99,
      ),
      [
        "2",
        "4->49",
        "51->74",
        "76->99",
      ],
    ))
  ) throw new Error("expect failed");
}

function test_example_2(): void {
  if (!(_equal(findMissingRanges([], 1, 1), ["1"]))) {
    throw new Error("expect failed");
  }
}

function main(): void {
  test_example_1();
  test_example_2();
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
