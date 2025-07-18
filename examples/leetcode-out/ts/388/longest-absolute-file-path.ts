// Generated by Mochi TypeScript compiler

function splitLines(s: string): Array<string> {
  let lines: Array<string> = [];
  (globalThis as any).lines = lines;
  let current: string = "";
  (globalThis as any).current = current;
  let i: number = 0;
  (globalThis as any).i = i;
  while ((i < s.length)) {
    let c: string = _indexString(s, i);
    (globalThis as any).c = c;
    if ((c == "\n")) {
      lines = lines.concat([current]);
      current = "";
    } else {
      current = current + c;
    }
    i = i + 1;
  }
  lines = lines.concat([current]);
  return lines;
}

function lengthLongestPath(input: string): number {
  if ((input == "")) {
    return 0;
  }
  let lines: Array<string> = splitLines(input);
  (globalThis as any).lines = lines;
  let maxLen: number = 0;
  (globalThis as any).maxLen = maxLen;
  let levels: Record<number, number> = {};
  (globalThis as any).levels = levels;
  let i: number = 0;
  (globalThis as any).i = i;
  while ((i < lines.length)) {
    let line: string = lines[i];
    (globalThis as any).line = line;
    let depth: number = 0;
    (globalThis as any).depth = depth;
    while (((depth < line.length) && (_indexString(line, depth) == "\t"))) {
      depth = depth + 1;
    }
    let name: string = _sliceString(line, depth, line.length);
    (globalThis as any).name = name;
    let curr: number = name.length;
    (globalThis as any).curr = curr;
    if ((depth > 0)) {
      curr = (levels[depth - 1] + 1) + name.length;
    }
    levels[depth] = curr;
    if (name.includes(".")) {
      if ((curr > maxLen)) {
        maxLen = curr;
      }
    }
    i = i + 1;
  }
  return maxLen;
}

function test_example_1(): void {
  let input: string = "dir\n\tsubdir1\n\tsubdir2\n\t\tfile.ext";
  (globalThis as any).input = input;
  if (!(lengthLongestPath(input) == 20)) throw new Error("expect failed");
}

function test_example_2(): void {
  let input: string =
    "dir\n\tsubdir1\n\t\tfile1.ext\n\t\tsubsubdir1\n\tsubdir2\n\t\tsubsubdir2\n\t\t\tfile2.ext";
  (globalThis as any).input = input;
  if (!(lengthLongestPath(input) == 32)) throw new Error("expect failed");
}

function test_no_files(): void {
  if (!(lengthLongestPath("dir\n\tsubdir") == 0)) {
    throw new Error("expect failed");
  }
}

function main(): void {
  test_example_1();
  test_example_2();
  test_no_files();
}
function _indexString(s: string, i: number): string {
  const runes = Array.from(s);
  if (i < 0) i += runes.length;
  if (i < 0 || i >= runes.length) throw new Error("index out of range");
  return runes[i];
}

function _sliceString(s: string, i: number, j: number): string {
  let start = i;
  let end = j;
  const runes = Array.from(s);
  const n = runes.length;
  if (start < 0) start += n;
  if (end < 0) end += n;
  if (start < 0) start = 0;
  if (end > n) end = n;
  if (end < start) end = start;
  return runes.slice(start, end).join("");
}

main();
