function boom(): boolean {
  console.log("boom");
  return true;
}
console.log(1 < 2 && 2 < 3 && 3 < 4);
console.log(1 < 2 && 2 > 3 && boom());
console.log(1 < 2 && 2 < 3 && 3 > 4 && boom());
