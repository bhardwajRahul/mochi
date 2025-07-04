// Generated by Mochi TypeScript compiler

function myPow(x: number, n: number): number {
  if ((n == 0)) {
    return 1;
  }
  if ((n < 0)) {
    return (1 / myPow(x, -n));
  }
  let base: number = x;
  (globalThis as any).base = base;
  let exp: number = n;
  (globalThis as any).exp = exp;
  let result: number = 1;
  (globalThis as any).result = result;
  while ((exp > 0)) {
    if (((exp % 2) == 1)) {
      result = result * base;
    }
    base = base * base;
    exp = Math.trunc(exp / 2);
  }
  return result;
}

function test_example_1(): void {
  if (!(myPow(2, 10) == 1024)) throw new Error("expect failed");
}

function test_example_2(): void {
  if (!(myPow(2.1, 3) == 9.261000000000001)) throw new Error("expect failed");
}

function test_example_3(): void {
  if (!(myPow(2, -2) == 0.25)) throw new Error("expect failed");
}

function main(): void {
  test_example_1();
  test_example_2();
  test_example_3();
}
main();
