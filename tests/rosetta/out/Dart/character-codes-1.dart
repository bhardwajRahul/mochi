// Generated by Mochi compiler v0.10.28 on 2025-07-18T09:35:08Z
int ord(String ch) {
  if (ch == 'a') {
    return 97;
  }
  if (ch == 'π') {
    return 960;
  }
  if (ch == 'A') {
    return 65;
  }
  return 0;
}

void main() {
  print(ord('a').toString());
  print(ord('π').toString());
}
