# Generated by Mochi compiler v0.10.28 on 2025-07-18T07:04:08Z
defmodule Main do
  @nums [3, 1, 4]
  def main do
    IO.inspect(Enum.min(@nums))
    IO.inspect(Enum.max(@nums))
  end
end

Main.main()
