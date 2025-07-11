// Generated by Mochi TypeScript compiler

type PeekingIterator = {
  nums: Array<number>;
  index: number;
};

type NextResult = {
  iter: PeekingIterator;
  val: number;
};

function newPeekingIterator(nums: Array<number>): PeekingIterator {
  return {
    nums: nums,
    index: 0,
  };
}

function hasNext(it: PeekingIterator): boolean {
  return (it.index < it.nums.length);
}

function peek(it: PeekingIterator): number {
  return it.nums[it.index];
}

function next(it: PeekingIterator): NextResult {
  let v: number = it.nums[it.index];
  (globalThis as any).v = v;
  let newIt: PeekingIterator = {
    nums: it.nums,
    index: (it.index + 1),
  };
  (globalThis as any).newIt = newIt;
  return {
    iter: newIt,
    val: v,
  };
}

function test_example(): void {
  let it: PeekingIterator = newPeekingIterator([
    1,
    2,
    3,
  ]);
  (globalThis as any).it = it;
  let r1: NextResult = next(it);
  (globalThis as any).r1 = r1;
  it = r1.iter;
  if (!(r1.val == 1)) throw new Error("expect failed");
  if (!(peek(it) == 2)) throw new Error("expect failed");
  let r2: NextResult = next(it);
  (globalThis as any).r2 = r2;
  it = r2.iter;
  if (!(r2.val == 2)) throw new Error("expect failed");
  let r3: NextResult = next(it);
  (globalThis as any).r3 = r3;
  it = r3.iter;
  if (!(r3.val == 3)) throw new Error("expect failed");
  if (!(hasNext(it) == false)) throw new Error("expect failed");
}

function test_single_element(): void {
  let it: PeekingIterator = newPeekingIterator([5]);
  (globalThis as any).it = it;
  if (!(peek(it) == 5)) throw new Error("expect failed");
  let r: NextResult = next(it);
  (globalThis as any).r = r;
  it = r.iter;
  if (!(r.val == 5)) throw new Error("expect failed");
  if (!(hasNext(it) == false)) throw new Error("expect failed");
}

function test_empty(): void {
  let it: PeekingIterator = newPeekingIterator([]);
  (globalThis as any).it = it;
  if (!(hasNext(it) == false)) throw new Error("expect failed");
}

function main(): void {
  test_example();
  test_single_element();
  test_empty();
}
main();
