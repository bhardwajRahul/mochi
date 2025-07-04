// Generated by Mochi TypeScript compiler

function search(nums: Array<number>, target: number): number {
  let left: number = 0;
  (globalThis as any).left = left;
  let right: number = nums.length - 1;
  (globalThis as any).right = right;
  while ((left <= right)) {
    let mid: number = Math.trunc((left + right) / 2);
    (globalThis as any).mid = mid;
    if ((nums[mid] == target)) {
      return mid;
    }
    if ((nums[left] <= nums[mid])) {
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
  return (-1);
}

function test_example_1(): void {
  if (
    !(search([
      4,
      5,
      6,
      7,
      0,
      1,
      2,
    ], 0) == 4)
  ) throw new Error("expect failed");
}

function test_example_2(): void {
  if (
    !(search([
      4,
      5,
      6,
      7,
      0,
      1,
      2,
    ], 3) == (-1))
  ) throw new Error("expect failed");
}

function test_example_3(): void {
  if (!(search([1], 0) == (-1))) throw new Error("expect failed");
}

function test_single_element_found(): void {
  if (!(search([1], 1) == 0)) throw new Error("expect failed");
}

function test_two_elements(): void {
  if (
    !(search([
      3,
      1,
    ], 1) == 1)
  ) throw new Error("expect failed");
}

function main(): void {
  test_example_1();
  test_example_2();
  test_example_3();
  test_single_element_found();
  test_two_elements();
}
main();
