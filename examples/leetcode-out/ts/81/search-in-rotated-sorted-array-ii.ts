// Generated by Mochi TypeScript compiler

function search(nums: Array<number>, target: number): boolean {
  let left: number = 0;
  (globalThis as any).left = left;
  let right: number = nums.length - 1;
  (globalThis as any).right = right;
  while ((left <= right)) {
    let mid: number = Math.trunc((left + right) / 2);
    (globalThis as any).mid = mid;
    if ((nums[mid] == target)) {
      return true;
    }
    if ((nums[left] == nums[mid])) {
      left = left + 1;
    } else if ((nums[left] < nums[mid])) {
      if (((nums[left] <= target) && (target < nums[mid]))) {
        right = mid - 1;
      } else {
        left = mid + 1;
      }
    } else {
      if (((nums[mid] < target) && (target <= nums[right]))) {
        left = mid + 1;
      } else {
        right = mid - 1;
      }
    }
  }
  return false;
}

function test_example_1(): void {
  if (
    !(search([
      2,
      5,
      6,
      0,
      0,
      1,
      2,
    ], 0) == true)
  ) throw new Error("expect failed");
}

function test_example_2(): void {
  if (
    !(search([
      2,
      5,
      6,
      0,
      0,
      1,
      2,
    ], 3) == false)
  ) throw new Error("expect failed");
}

function test_all_duplicates(): void {
  if (
    !(search([
      1,
      1,
      1,
      1,
      1,
    ], 2) == false)
  ) throw new Error("expect failed");
}

function test_single_element(): void {
  if (!(search([1], 1) == true)) throw new Error("expect failed");
}

function test_empty_array(): void {
  if (!(search([], 5) == false)) throw new Error("expect failed");
}

function main(): void {
  test_example_1();
  test_example_2();
  test_all_duplicates();
  test_single_element();
  test_empty_array();
}
main();
