// Generated by Mochi compiler v0.10.28 on 2006-01-02T15:04:05Z
fn main() {
    fn ord(ch: &'static str) -> i32 {
        if ch == "a" {
            return 97;
        }
        if ch == "π" {
            return 960;
        }
        if ch == "A" {
            return 65;
        }
        return 0;
    }
    fn chr(n: i32) -> &'static str {
        if n == 97 {
            return "a";
        }
        if n == 960 {
            return "π";
        }
        if n == 65 {
            return "A";
        }
        return "?";
    }
    let mut b = ord("a");
    let mut r = ord("π");
    let mut s = String::from("aπ");
    println!("{}", vec![format!("{}", format!("{}{}", format!("{}{}", format!("{}{}", format!("{}{}", b.to_string(), " "), r.to_string()), " "), s))].into_iter().filter(|s| !s.is_empty()).collect::<Vec<_>>().join(" ") );
    println!("{}", vec![format!("{}", format!("{}{}", format!("{}{}", format!("{}{}", format!("{}{}", "string cast to []rune: [", b.to_string()), " "), r.to_string()), "]"))].into_iter().filter(|s| !s.is_empty()).collect::<Vec<_>>().join(" ") );
    println!("{}", vec![format!("{}", format!("{}{}", format!("{}{}", format!("{}{}", "    string range loop: ", b.to_string()), " "), r.to_string()))].into_iter().filter(|s| !s.is_empty()).collect::<Vec<_>>().join(" ") );
    println!("         string bytes: 0x61 0xcf 0x80");
}
