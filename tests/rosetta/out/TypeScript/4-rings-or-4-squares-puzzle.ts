// Generated by Mochi compiler v0.10.30 on 2025-07-19T02:08:26Z
// Source: /workspace/mochi/tests/rosetta/x/Mochi/4-rings-or-4-squares-puzzle.mochi

function validComb(
  a: number,
  b: number,
  c: number,
  d: number,
  e: number,
  f: number,
  g: number,
): boolean {
  let square1 = a + b;
  let square2 = (b + c) + d;
  let square3 = (d + e) + f;
  let square4 = f + g;
  return (((square1 == square2) && (square2 == square3)) &&
    (square3 == square4));
}

function isUnique(
  a: number,
  b: number,
  c: number,
  d: number,
  e: number,
  f: number,
  g: number,
): boolean {
  var nums = [
    a,
    b,
    c,
    d,
    e,
    f,
    g,
  ];
  var i = 0;
  while ((i < nums.length)) {
    var j = i + 1;
    while ((j < nums.length)) {
      if ((nums[i] == nums[j])) {
        return false;
      }
      j = j + 1;
    }
    i = i + 1;
  }
  return true;
}

function getCombs(
  low: number,
  high: number,
  unique: boolean,
): Record<string, any> {
  var valid = [];
  var count = 0;
  for (let b: number = low; b < (high + 1); b++) {
    for (let c: number = low; c < (high + 1); c++) {
      for (let d: number = low; d < (high + 1); d++) {
        let s = (b + c) + d;
        for (let e: number = low; e < (high + 1); e++) {
          for (let f: number = low; f < (high + 1); f++) {
            let a = s - b;
            let g = s - f;
            if (((a < low) || (a > high))) {
              continue;
            }
            if (((g < low) || (g > high))) {
              continue;
            }
            if ((((d + e) + f) != s)) {
              continue;
            }
            if (((f + g) != s)) {
              continue;
            }
            if (((!unique) || isUnique(a, b, c, d, e, f, g))) {
              valid = [...valid, [
                a,
                b,
                c,
                d,
                e,
                f,
                g,
              ]];
              count = count + 1;
            }
          }
        }
      }
    }
  }
  return {
    "count": count,
    "list": valid,
  };
}

let r1: Record<string, any>;
let r2: Record<string, any>;
let r3: Record<string, any>;

function main(): void {
  let r1: Record<string, any> = getCombs(1, 7, true);
  console.log(`${String(r1["count"])} unique solutions in 1 to 7`);
  console.log(r1["list"]);
  let r2: Record<string, any> = getCombs(3, 9, true);
  console.log(`${String(r2["count"])} unique solutions in 3 to 9`);
  console.log(r2["list"]);
  let r3: Record<string, any> = getCombs(0, 9, false);
  console.log(`${String(r3["count"])} non-unique solutions in 0 to 9`);
}
main();
