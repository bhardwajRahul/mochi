# Generated by Mochi compiler v0.10.26 on 2025-07-16T12:49:27Z
defmodule Main do
  @dim 16
  @spec newPile(integer()) :: list(list(integer()))
  def newPile(d) do
    try do
      b = []
      _ = b
      y = 0
      _ = y

      t1 = fn t1, b, y ->
        try do
          if y < d do
            row = []
            _ = row
            x = 0
            _ = x

            t2 = fn t2, row, x ->
              try do
                if x < d do
                  row = row ++ [0]
                  x = x + 1
                  t2.(t2, row, x)
                else
                  {:ok, row, x}
                end
              catch
                :break ->
                  {:ok, row, x}
              end
            end

            {_, row, x} = t2.(t2, row, x)
            _ = row
            _ = x
            b = b ++ [row]
            y = y + 1
            t1.(t1, b, y)
          else
            {:ok, b, y}
          end
        catch
          :break ->
            {:ok, b, y}
        end
      end

      {_, b, y} = t1.(t1, b, y)
      _ = b
      _ = y
      throw({:return, b})
    catch
      {:return, v} -> v
    end
  end

  @spec handlePile(list(list(integer())), integer(), integer()) :: list(list(integer()))
  def handlePile(pile, x, y) do
    try do
      if Enum.at(Enum.at(pile, y), x) >= 4 do
        pile = Map.put(pile, y, Enum.at(Enum.at(pile, y), x) - 4)

        if y > 0 do
          pile = Map.put(pile, y - 1, Enum.at(Enum.at(pile, y - 1), x) + 1)

          if Enum.at(Enum.at(pile, y - 1), x) >= 4 do
            pile = handlePile(pile, x, y - 1)
          end
        end

        if x > 0 do
          pile = Map.put(pile, y, Enum.at(Enum.at(pile, y), x - 1) + 1)

          if Enum.at(Enum.at(pile, y), x - 1) >= 4 do
            pile = handlePile(pile, x - 1, y)
          end
        end

        if y < @dim - 1 do
          pile = Map.put(pile, y + 1, Enum.at(Enum.at(pile, y + 1), x) + 1)

          if Enum.at(Enum.at(pile, y + 1), x) >= 4 do
            pile = handlePile(pile, x, y + 1)
          end
        end

        if x < @dim - 1 do
          pile = Map.put(pile, y, Enum.at(Enum.at(pile, y), x + 1) + 1)

          if Enum.at(Enum.at(pile, y), x + 1) >= 4 do
            pile = handlePile(pile, x + 1, y)
          end
        end

        pile = handlePile(pile, x, y)
      end

      throw({:return, pile})
    catch
      {:return, v} -> v
    end
  end

  @spec drawPile(list(list(integer())), integer()) :: nil
  def drawPile(pile, d) do
    try do
      chars = [" ", "░", "▓", "█"]
      row = 0
      _ = row

      t3 = fn t3, row ->
        try do
          if row < d do
            line = ""
            _ = line
            col = 0
            _ = col

            t4 = fn t4, col, line ->
              try do
                if col < d do
                  v = Enum.at(Enum.at(pile, row), col)
                  _ = v

                  if v > 3 do
                    v = 3
                  end

                  line = line + Enum.at(chars, v)
                  col = col + 1
                  t4.(t4, col, line)
                else
                  {:ok, col, line}
                end
              catch
                :break ->
                  {:ok, col, line}
              end
            end

            {_, col, line} = t4.(t4, col, line)
            _ = col
            _ = line
            IO.inspect(line)
            row = row + 1
            t3.(t3, row)
          else
            {:ok, row}
          end
        catch
          :break ->
            {:ok, row}
        end
      end

      {_, row} = t3.(t3, row)
      _ = row
    catch
      {:return, v} -> v
    end
  end

  @spec main() :: nil
  def main() do
    try do
      pile = newPile(16)
      _ = pile
      hdim = 7
      pile = Map.put(pile, hdim, 16)
      pile = handlePile(pile, hdim, hdim)
      drawPile(pile, 16)
    catch
      {:return, v} -> v
    end
  end

  def main do
    main()
  end
end

Main.main()
