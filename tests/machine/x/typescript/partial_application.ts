function add(a, b) {
  return (a + b);
}
const add5 = (...args) => add(5, ...args);
console.log(add5(3));
