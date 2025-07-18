// Generated by Mochi TypeScript compiler

function maxProfit(k: number, prices: Array<number>): number {
  let n: number = prices.length;
  (globalThis as any).n = n;
  if (((n == 0) || (k == 0))) {
    return 0;
  }
  if ((k >= Math.trunc(n / 2))) {
    let profit: number = 0;
    (globalThis as any).profit = profit;
    for (let i: number = 1; i < n; i++) {
      let diff: number = prices[i] - prices[i - 1];
      (globalThis as any).diff = diff;
      if ((diff > 0)) {
        profit = profit + diff;
      }
    }
    return profit;
  }
  let buy: Array<number> = [];
  (globalThis as any).buy = buy;
  let sell: Array<number> = [];
  (globalThis as any).sell = sell;
  let idx: number = 0;
  (globalThis as any).idx = idx;
  while ((idx < k)) {
    buy = buy.concat([0 - prices[0]]);
    sell = sell.concat([0]);
    idx = idx + 1;
  }
  let i: number = 1;
  (globalThis as any).i = i;
  while ((i < n)) {
    let price: number = prices[i];
    (globalThis as any).price = price;
    let b0: number = 0 - price;
    (globalThis as any).b0 = b0;
    if ((b0 > buy[0])) {
      buy[0] = b0;
    }
    let s0: number = buy[0] + price;
    (globalThis as any).s0 = s0;
    if ((s0 > sell[0])) {
      sell[0] = s0;
    }
    let j: number = 1;
    (globalThis as any).j = j;
    while ((j < k)) {
      let b: number = sell[j - 1] - price;
      (globalThis as any).b = b;
      if ((b > buy[j])) {
        buy[j] = b;
      }
      let s: number = buy[j] + price;
      (globalThis as any).s = s;
      if ((s > sell[j])) {
        sell[j] = s;
      }
      j = j + 1;
    }
    i = i + 1;
  }
  return sell[k - 1];
}

function test_example_1(): void {
  if (
    !(maxProfit(2, [
      2,
      4,
      1,
    ]) == 2)
  ) throw new Error("expect failed");
}

function test_example_2(): void {
  if (
    !(maxProfit(2, [
      3,
      2,
      6,
      5,
      0,
      3,
    ]) == 7)
  ) throw new Error("expect failed");
}

function test_empty_prices(): void {
  if (!(maxProfit(3, []) == 0)) throw new Error("expect failed");
}

function test_unlimited_transactions(): void {
  if (
    !(maxProfit(100, [
      1,
      2,
      3,
      4,
      5,
    ]) == 4)
  ) throw new Error("expect failed");
}

function test_zero_k(): void {
  if (
    !(maxProfit(0, [
      1,
      3,
      2,
      8,
    ]) == 0)
  ) throw new Error("expect failed");
}

function main(): void {
  test_example_1();
  test_example_2();
  test_empty_prices();
  test_unlimited_transactions();
  test_zero_k();
}
main();
