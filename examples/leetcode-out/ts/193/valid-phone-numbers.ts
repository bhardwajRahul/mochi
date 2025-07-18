// Generated by Mochi TypeScript compiler

function isDigit(ch: string): boolean {
  return ((ch >= "0") && (ch <= "9"));
}

function isValidPhoneNumber(s: string): boolean {
  let n: number = s.length;
  (globalThis as any).n = n;
  if ((n == 12)) {
    if (((_indexString(s, 3) != "-") || (_indexString(s, 7) != "-"))) {
      return false;
    }
    let i: number = 0;
    (globalThis as any).i = i;
    while ((i < n)) {
      if (((i == 3) || (i == 7))) {
        i = i + 1;
        continue;
      }
      if ((!isDigit(_indexString(s, i)))) {
        return false;
      }
      i = i + 1;
    }
    return true;
  }
  if ((n == 14)) {
    if (
      ((((_indexString(s, 0) != "(") || (_indexString(s, 4) != ")")) ||
        (_indexString(s, 5) != " ")) || (_indexString(s, 9) != "-"))
    ) {
      return false;
    }
    let i: number = 0;
    (globalThis as any).i = i;
    while ((i < n)) {
      if (((((i == 0) || (i == 4)) || (i == 5)) || (i == 9))) {
        i = i + 1;
        continue;
      }
      if ((!isDigit(_indexString(s, i)))) {
        return false;
      }
      i = i + 1;
    }
    return true;
  }
  return false;
}

function validPhoneNumbers(lines: Array<string>): Array<string> {
  let result: Array<string> = [];
  (globalThis as any).result = result;
  for (const line of lines) {
    if (isValidPhoneNumber(line)) {
      result = result.concat([line]);
    }
  }
  return result;
}

function test_example(): void {
  let input: Array<string> = [
    "987-123-4567",
    "123 456 7890",
    "(123) 456-7890",
  ];
  (globalThis as any).input = input;
  if (
    !(_equal(validPhoneNumbers(input), [
      "987-123-4567",
      "(123) 456-7890",
    ]))
  ) throw new Error("expect failed");
}

function main(): void {
  test_example();
}
function _equal(a: any, b: any): boolean {
  if (Array.isArray(a) && Array.isArray(b)) {
    if (a.length !== b.length) return false;
    for (let i = 0; i < a.length; i++) if (!_equal(a[i], b[i])) return false;
    return true;
  }
  if (a && b && typeof a === "object" && typeof b === "object") {
    const ak = Object.keys(a);
    const bk = Object.keys(b);
    if (ak.length !== bk.length) return false;
    for (const k of ak) {
      if (!bk.includes(k) || !_equal((a as any)[k], (b as any)[k])) {
        return false;
      }
    }
    return true;
  }
  return a === b;
}

function _indexString(s: string, i: number): string {
  const runes = Array.from(s);
  if (i < 0) i += runes.length;
  if (i < 0 || i >= runes.length) throw new Error("index out of range");
  return runes[i];
}

main();
