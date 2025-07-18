fn twoSum(nums: Vec<i64>, target: i64) -> Vec<i64> {
    let mut n = nums.len() as i64;
    for i in 0..n {
        for j in i + 1..n {
            if nums[i as usize] + nums[j as usize] == target {
                return vec![i, j];
            }
        }
    }
    return vec![-1, -1];
}

fn main() {
    let mut result = twoSum(vec![2, 7, 11, 15], 9);
    println!("{}", result[(0) as usize]);
    println!("{}", result[(1) as usize]);
}
