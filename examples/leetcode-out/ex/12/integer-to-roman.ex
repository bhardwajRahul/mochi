# Generated by Mochi Elixir compiler
defmodule Main do
  def intToRoman(num) do
    try do
      values = [1000, 900, 500, 400, 100, 90, 50, 40, 10, 9, 5, 4, 1]
      symbols = ["M", "CM", "D", "CD", "C", "XC", "L", "XL", "X", "IX", "V", "IV", "I"]
      result = ""
      _ = result
      i = 0
      _ = i

      t1 = fn t1, i, num, result ->
        try do
          if num > 0 do
            t2 = fn t2, num, result ->
              try do
                if num >= Enum.at(values, i) do
                  result = result + Enum.at(symbols, i)
                  num = num - Enum.at(values, i)
                  t2.(t2, num, result)
                else
                  {:ok, num, result}
                end
              catch
                :break ->
                  {:ok, num, result}
              end
            end

            {_, num, result} = t2.(t2, num, result)
            _ = num
            _ = result
            i = i + 1
            t1.(t1, i, num, result)
          else
            {:ok, i, num, result}
          end
        catch
          :break ->
            {:ok, i, num, result}
        end
      end

      {_, i, num, result} = t1.(t1, i, num, result)
      _ = i
      _ = num
      _ = result
      throw({:return, result})
    catch
      {:return, v} -> v
    end
  end

  def main do
  end
end

Main.main()
