# Generated by Mochi compiler v0.10.26 on 2025-07-16T12:45:11Z
defmodule Main do
  @spec main() :: nil
  def main() do
    try do
      a = 12
      b = 8
      IO.puts((((to_string(a) <> " + ") <> to_string(b)) <> " = ") <> to_string(a + b))
      IO.puts((((to_string(a) <> " - ") <> to_string(b)) <> " = ") <> to_string(a - b))
      IO.puts((((to_string(a) <> " * ") <> to_string(b)) <> " = ") <> to_string(a * b))

      IO.puts(
        (((to_string(a) <> " / ") <> to_string(b)) <> " = ") <>
          to_string(String.to_integer(a / b))
      )

      IO.puts((((to_string(a) <> " % ") <> to_string(b)) <> " = ") <> to_string(rem(a, b)))
    catch
      {:return, v} -> v
    end
  end

  def main do
    main()
  end
end

Main.main()
