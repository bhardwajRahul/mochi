// Generated by Mochi TypeScript compiler

function minPatches(nums: Array<number>, n: number): number {
  let miss: number = 1;
  (globalThis as any).miss = miss;
  let i: number = 0;
  (globalThis as any).i = i;
  let patches: number = 0;
  (globalThis as any).patches = patches;
  while ((miss <= n)) {
    if ((i < nums.length)) {
      if ((nums[i] <= miss)) {
        miss = miss + nums[i];
        i = i + 1;
      } else {
        miss = miss + miss;
        patches = patches + 1;
      }
    } else {
      miss = miss + miss;
      patches = patches + 1;
    }
  }
  return patches;
}

function test_example_1(): void {
  if (
    !(minPatches([
      1,
      3,
    ], 6) == 1)
  ) throw new Error("expect failed");
}

function test_example_2(): void {
  if (
    !(minPatches([
      1,
      5,
      10,
    ], 20) == 2)
  ) throw new Error("expect failed");
}

function test_example_3(): void {
  if (
    !(minPatches([
      1,
      2,
      2,
    ], 5) == 0)
  ) throw new Error("expect failed");
}

function test_no_patches_needed(): void {
  if (
    !(minPatches([
      1,
      2,
      4,
      13,
      43,
    ], 100) == 2)
  ) throw new Error("expect failed");
}

function test_large_n(): void {
  if (!(minPatches([], 7) == 3)) throw new Error("expect failed");
}

function test_single_element(): void {
  if (!(minPatches([1], 1) == 0)) throw new Error("expect failed");
}

function main(): void {
  test_example_1();
  test_example_2();
  test_example_3();
  test_no_patches_needed();
  test_large_n();
  test_single_element();
}
main();
