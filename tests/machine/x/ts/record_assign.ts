// Generated by Mochi TypeScript compiler

type Counter = {
  n: number;
};

function inc(c: Counter): void {
  c = c.n + 1;
}

var c: Counter;

function main(): void {
  c = { n: 0 };
  inc(c);
  console.log(c.n);
}
main();
