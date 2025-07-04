// Generated by Mochi TypeScript compiler

function NewStack(): Record<string, any> {
  return { "q": [] };
}

function push(stack: Record<string, any>, x: number): void {
  let q: Array<number> = stack["q"];
  (globalThis as any).q = q;
  q = q.concat([x]);
  let i: number = 0;
  (globalThis as any).i = i;
  while ((i < (q.length - 1))) {
    q = q.slice(1, q.length).concat([q[0]]);
    i = i + 1;
  }
  stack["q"] = q;
}

function pop(stack: Record<string, any>): number {
  let q: Array<number> = stack["q"];
  (globalThis as any).q = q;
  let v: number = q[0];
  (globalThis as any).v = v;
  q = q.slice(1, q.length);
  stack["q"] = q;
  return v;
}

function top(stack: Record<string, any>): number {
  let q: Array<number> = stack["q"];
  (globalThis as any).q = q;
  return q[0];
}

function empty(stack: Record<string, any>): boolean {
  let q: Array<number> = stack["q"];
  (globalThis as any).q = q;
  return (q.length == 0);
}

function test_example(): void {
  let st: Record<string, any> = NewStack();
  (globalThis as any).st = st;
  push(st, 1);
  push(st, 2);
  if (!(top(st) == 2)) throw new Error("expect failed");
  if (!(pop(st) == 2)) throw new Error("expect failed");
  if (!(empty(st) == false)) throw new Error("expect failed");
}

function test_single_push_pop(): void {
  let st: Record<string, any> = NewStack();
  (globalThis as any).st = st;
  push(st, 5);
  if (!(pop(st) == 5)) throw new Error("expect failed");
  if (!(empty(st) == true)) throw new Error("expect failed");
}

function test_multiple_pushes(): void {
  let st: Record<string, any> = NewStack();
  (globalThis as any).st = st;
  push(st, 1);
  push(st, 2);
  push(st, 3);
  if (!(pop(st) == 3)) throw new Error("expect failed");
  if (!(pop(st) == 2)) throw new Error("expect failed");
  if (!(pop(st) == 1)) throw new Error("expect failed");
  if (!(empty(st) == true)) throw new Error("expect failed");
}

function main(): void {
  test_example();
  test_single_push_pop();
  test_multiple_pushes();
}
main();
