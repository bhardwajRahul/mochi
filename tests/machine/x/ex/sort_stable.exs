# Generated by Mochi Elixir compiler
defmodule Main do
  def main do
    # items :: list(map())
    items = [%{n: 1, v: "a"}, %{n: 1, v: "b"}, %{n: 2, v: "c"}]
    # result :: list(any())
    result = for i <- Enum.sort_by(items, fn i -> i.n end), do: i.v
    IO.inspect(result)
  end
end

Main.main()
