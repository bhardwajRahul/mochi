# Generated by Mochi compiler v0.10.26 on 2025-07-16T12:46:01Z
defmodule Main do
  @spec powf(float(), integer()) :: float()
  def powf(base, exp) do
    try do
      result = 1
      _ = result
      i = 0
      _ = i

      t1 = fn t1, i, result ->
        try do
          if i < exp do
            result = result * base
            i = i + 1
            t1.(t1, i, result)
          else
            {:ok, i, result}
          end
        catch
          :break ->
            {:ok, i, result}
        end
      end

      {_, i, result} = t1.(t1, i, result)
      _ = i
      _ = result
      throw({:return, result})
    catch
      {:return, v} -> v
    end
  end

  @spec nthRoot(float(), integer()) :: float()
  def nthRoot(x, n) do
    try do
      low = 0
      _ = low
      high = x
      _ = high
      i = 0
      _ = i

      t2 = fn t2, high, i, low ->
        try do
          if i < 60 do
            mid = (low + high) / 2

            if powf(mid, n) > x do
              high = mid
            else
              low = mid
            end

            i = i + 1
            t2.(t2, high, i, low)
          else
            {:ok, high, i, low}
          end
        catch
          :break ->
            {:ok, high, i, low}
        end
      end

      {_, high, i, low} = t2.(t2, high, i, low)
      _ = high
      _ = i
      _ = low
      throw({:return, low})
    catch
      {:return, v} -> v
    end
  end

  @spec main() :: nil
  def main() do
    try do
      # sum :: (any() -> float())
      sum = 0
      _ = sum
      sumRecip = 0
      _ = sumRecip
      prod = 1
      _ = prod
      n = 1
      _ = n

      t3 = fn t3, n, prod, sum, sumRecip ->
        try do
          if n <= 10 do
            f = String.to_float(n)
            sum = sum + f
            sumRecip = sumRecip + 1 / f
            prod = prod * f
            n = n + 1
            t3.(t3, n, prod, sum, sumRecip)
          else
            {:ok, n, prod, sum, sumRecip}
          end
        catch
          :break ->
            {:ok, n, prod, sum, sumRecip}
        end
      end

      {_, n, prod, sum, sumRecip} = t3.(t3, n, prod, sum, sumRecip)
      _ = n
      _ = prod
      _ = sum
      _ = sumRecip
      # count :: (any() -> integer())
      count = 10
      a = sum / count
      g = nthRoot(prod, 10)
      h = count / sumRecip
      IO.puts((((("A: " <> to_string(a)) <> " G: ") <> to_string(g)) <> " H: ") <> to_string(h))
      IO.puts("A >= G >= H: " <> to_string(a >= g && g >= h))
    catch
      {:return, v} -> v
    end
  end

  def main do
    main()
  end
end

Main.main()
