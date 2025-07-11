// Generated by Mochi TypeScript compiler

function findPeakElement(nums: Array<number>): number {
  let n: number = nums.length;
  (globalThis as any).n = n;
  let left: number = 0;
  (globalThis as any).left = left;
  let right: number = n - 1;
  (globalThis as any).right = right;
  while ((left < right)) {
    let mid: number = Math.trunc((left + right) / 2);
    (globalThis as any).mid = mid;
    if ((nums[mid] > nums[mid + 1])) {
      right = mid;
    } else {
      left = mid + 1;
    }
  }
  return left;
}

function test_example_1(): void {
  if (
    !(findPeakElement([
      1,
      2,
      3,
      1,
    ]) == 2)
  ) throw new Error("expect failed");
}

function test_example_2(): void {
  let idx: number = findPeakElement([
    1,
    2,
    1,
    3,
    5,
    6,
    4,
  ]);
  (globalThis as any).idx = idx;
  if (!((idx == 1) || (idx == 5))) throw new Error("expect failed");
}

function main(): void {
  test_example_1();
  test_example_2();
}
main();
