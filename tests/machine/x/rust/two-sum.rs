fn main() {
    fn twoSum(nums: Vec<i32>, target: i32) -> Vec<i32> {
        let n = nums.len() as i32;
        for i in 0..n {
            for j in i + 1..n {
                if nums[i as usize] + nums[j as usize] == target {
                    return vec![i, j];
                }
            }
        }
        return vec![-1, -1];
    }
    let result = twoSum(vec![2, 7, 11, 15], 9);
    println!("{}", result[0]);
    println!("{}", result[1]);
}
