// Generated by Mochi TypeScript compiler

function twoSum(nums: number[], target: number): number[] {
  let n: number = nums.length;
  for (let i: number = 0; i < n; i++) {
    for (let j: number = i + 1; j < n; j++) {
      if (((nums[i] + nums[j]) == target)) {
        return [
          i,
          j,
        ];
      }
    }
  }
  return [
    -1,
    -1,
  ];
}

let result: number[];

function main(): void {
  result = twoSum([
    2,
    7,
    11,
    15,
  ], 9);
  console.log(result[0]);
  console.log(result[1]);
}
main();
