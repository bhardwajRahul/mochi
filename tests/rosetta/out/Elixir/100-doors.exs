# Generated by Mochi compiler v0.10.30 on 2025-07-19T01:03:39Z
defmodule Main do
  def main do
    # doors :: list(any())
    doors = []
    _ = doors

    {doors} =
      Enum.reduce(0..(100 - 1), {doors}, fn i, {doors} ->
        doors = doors ++ [false]
        {doors}
      end)

    _ = doors

    {doors} =
      Enum.reduce(1..(101 - 1), {doors}, fn pass, {doors} ->
        # idx :: any()
        idx = pass - 1
        _ = idx

        t1 = fn t1, doors, idx ->
          try do
            if idx < 100 do
              doors = List.replace_at(doors, idx, !Enum.at(doors, idx))
              idx = idx + pass
              t1.(t1, doors, idx)
            else
              {:ok, doors, idx}
            end
          catch
            :break ->
              {:ok, doors, idx}
          end
        end

        {_, doors, idx} = t1.(t1, doors, idx)
        _ = doors
        _ = idx
        {doors}
      end)

    _ = doors

    for row <- 0..(10 - 1) do
      # line :: String.t()
      line = ""
      _ = line

      {line} =
        Enum.reduce(0..(10 - 1), {line}, fn col, {line} ->
          # idx :: any()
          idx = row * 10 + col

          if Enum.at(doors, idx) do
            line = line <> "1"
          else
            line = line <> "0"
          end

          if col < 9 do
            line = line <> " "
          end

          {line}
        end)

      _ = line
      IO.puts(line)
    end
  end
end

Main.main()
