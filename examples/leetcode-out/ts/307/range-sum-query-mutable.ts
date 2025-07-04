// Generated by Mochi TypeScript compiler

type NumArray = {
  nums: Array<number>;
};

function newNumArray(values: Array<number>): NumArray {
  return { nums: values };
}

function update(arr: NumArray, index: number, val: number): NumArray {
  let data: Array<number> = arr.nums;
  (globalThis as any).data = data;
  data[index] = val;
  return { nums: data };
}

function sumRange(arr: NumArray, left: number, right: number): number {
  let i: number = left;
  (globalThis as any).i = i;
  let total: number = 0;
  (globalThis as any).total = total;
  while ((i <= right)) {
    total = total + arr.nums[i];
    i = i + 1;
  }
  return total;
}

function test_example(): void {
  let na: NumArray = newNumArray([
    1,
    3,
    5,
  ]);
  (globalThis as any).na = na;
  if (!(sumRange(na, 0, 2) == 9)) throw new Error("expect failed");
  na = update(na, 1, 2);
  if (!(sumRange(na, 0, 2) == 8)) throw new Error("expect failed");
}

function test_update_first_and_last(): void {
  let na: NumArray = newNumArray([
    2,
    4,
    6,
    8,
  ]);
  (globalThis as any).na = na;
  na = update(na, 0, 1);
  na = update(na, 3, 5);
  if (!(sumRange(na, 0, 3) == 16)) throw new Error("expect failed");
  if (!(sumRange(na, 1, 2) == 10)) throw new Error("expect failed");
}

function main(): void {
  test_example();
  test_update_first_and_last();
}
main();
