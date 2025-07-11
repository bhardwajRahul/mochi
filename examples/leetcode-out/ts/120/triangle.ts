// Generated by Mochi TypeScript compiler

function minimumTotal(triangle: Array<Array<number>>): number {
  let n: number = triangle.length;
  (globalThis as any).n = n;
  if ((n == 0)) {
    return 0;
  }
  let dp: Array<number> = triangle[n - 1];
  (globalThis as any).dp = dp;
  let i: number = n - 2;
  (globalThis as any).i = i;
  while ((i >= 0)) {
    let j: number = 0;
    (globalThis as any).j = j;
    while ((j <= i)) {
      let left: number = dp[j];
      (globalThis as any).left = left;
      let right: number = dp[j + 1];
      (globalThis as any).right = right;
      if ((left < right)) {
        dp[j] = triangle[i][j] + left;
      } else {
        dp[j] = triangle[i][j] + right;
      }
      j = j + 1;
    }
    i = i - 1;
  }
  return dp[0];
}

function test_example_1(): void {
  if (
    !(minimumTotal([
      [2],
      [
        3,
        4,
      ],
      [
        6,
        5,
        7,
      ],
      [
        4,
        1,
        8,
        3,
      ],
    ]) == 11)
  ) throw new Error("expect failed");
}

function test_example_2(): void {
  if (!(minimumTotal([[-10]]) == (-10))) throw new Error("expect failed");
}

function test_single_level(): void {
  if (!(minimumTotal([[1]]) == 1)) throw new Error("expect failed");
}

function main(): void {
  test_example_1();
  test_example_2();
  test_single_level();
}
main();
