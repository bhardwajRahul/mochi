# ts2mochi

This package converts a limited subset of TypeScript into Mochi source code. It is
implemented in pure Go and relies on the TypeScript language server to obtain
symbol information. It is mainly used for testing the TypeScript backend by
round‑tripping compiler output.

## Supported features

- Function declarations with parameter and return types derived via the
  language server
- `return` statements
- `console.log` translated to `print`
- Variable declarations (`let`, `const`, `var`)
- `if` statements with optional `else` blocks
- `for ... of` loops
- Numeric literals and identifiers
- Array literals
- Simple call expressions

## Unsupported features

The converter is intentionally small and does not understand advanced
TypeScript syntax such as classes, generics or module systems. Unsupported
statements in function bodies are ignored.
