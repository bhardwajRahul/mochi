// Generated by Mochi TypeScript compiler

function totalNQueens(n: number): number {
  let cols: Array<boolean> = [];
  (globalThis as any).cols = cols;
  let i: number = 0;
  (globalThis as any).i = i;
  while ((i < n)) {
    cols = cols.concat([false]);
    i = i + 1;
  }
  let diag1: Array<boolean> = [];
  (globalThis as any).diag1 = diag1;
  i = 0;
  while ((i < (2 * n))) {
    diag1 = diag1.concat([false]);
    i = i + 1;
  }
  let diag2: Array<boolean> = [];
  (globalThis as any).diag2 = diag2;
  i = 0;
  while ((i < (2 * n))) {
    diag2 = diag2.concat([false]);
    i = i + 1;
  }
  let count: number = 0;
  (globalThis as any).count = count;
  function backtrack(row: number): void {
    if ((row == n)) {
      count = count + 1;
    } else {
      for (let col: number = 0; col < n; col++) {
        let d1: number = (row - col) + n;
        (globalThis as any).d1 = d1;
        let d2: number = row + col;
        (globalThis as any).d2 = d2;
        if (((cols[col] || diag1[d1]) || diag2[d2])) {
          continue;
        }
        cols[col] = true;
        diag1[d1] = true;
        diag2[d2] = true;
        backtrack(row + 1);
        cols[col] = false;
        diag1[d1] = false;
        diag2[d2] = false;
      }
    }
  }
  backtrack(0);
  return count;
}

function test_example_1(): void {
  if (!(totalNQueens(1) == 1)) throw new Error("expect failed");
}

function test_example_2(): void {
  if (!(totalNQueens(4) == 2)) throw new Error("expect failed");
}

function test_example_3(): void {
  if (!(totalNQueens(5) == 10)) throw new Error("expect failed");
}

function main(): void {
  test_example_1();
  test_example_2();
  test_example_3();
}
main();
