// Generated by Mochi compiler v0.10.28 on 2006-01-02T15:04:05Z
fn main() {
    fn initGrid(size: i32) -> Vec<Vec<&'static str>> {
        let mut g: Vec<Vec<&'static str>> = vec![];
        let mut y = 0;
        while y < size {
            let mut row: Vec<&'static str> = vec![];
            let mut x = 0;
            while x < size {
                row = { let mut tmp = row.clone(); tmp.push(" "); tmp };
                x += 1;
            }
            g = { let mut tmp = g.clone(); tmp.push(row); tmp };
            y += 1;
        }
        return g;
    }
    fn set(g: &mut Vec<Vec<&'static str>>, x: i32, y: i32) -> () {
        if x >= 0 && x < g[0].len() as i32 && y >= 0 && y < g.len() as i32 {
            g[y as usize][x as usize] = "#";
        }
    }
    fn circle(r: i32) -> Vec<Vec<&'static str>> {
        let size = r * 2 + 1;
        let mut g = initGrid(size);
        let mut x = r;
        let mut y = 0;
        let mut err = 1 - r;
        while y <= x {
            set(&mut g, r + x, r + y);
            set(&mut g, r + y, r + x);
            set(&mut g, r - x, r + y);
            set(&mut g, r - y, r + x);
            set(&mut g, r - x, r - y);
            set(&mut g, r - y, r - x);
            set(&mut g, r + x, r - y);
            set(&mut g, r + y, r - x);
            y += 1;
            if err < 0 {
                err = err + 2 * y + 1;
            } else {
                x -= 1;
                err = err + 2 * (y - x) + 1;
            }
        }
        return g;
    }
    fn trimRight(row: Vec<&'static str>) -> &'static str {
        let mut end = row.len() as i32;
        while end > 0 && row[end - 1 as usize] == " " {
            end -= 1;
        }
        let mut s = String::new();
        let mut i = 0;
        while i < end {
            s += row[i as usize];
            i += 1;
        }
        return s;
    }
    let mut g = circle(10);
    for row in g {
        println!("{}", vec![format!("{}", trimRight(row))].into_iter().filter(|s| !s.is_empty()).collect::<Vec<_>>().join(" ") );
    }
}
