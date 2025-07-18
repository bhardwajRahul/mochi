# Generated by Mochi compiler v0.10.28 on 2025-07-18T07:04:15Z
defmodule Main do
  @nums [1, 2, 3]
  def main do
    # result :: float()
    result = _sum(for n <- @nums, n > 1, do: n)
    IO.inspect(result)
  end

  defp _sum(v) do
    list =
      cond do
        is_map(v) and Map.has_key?(v, :items) -> Map.get(v, :items)
        is_list(v) -> v
        true -> raise "sum() expects list or group"
      end

    Enum.sum(list)
  end
end

Main.main()
