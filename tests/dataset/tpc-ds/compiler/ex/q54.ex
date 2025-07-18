# Generated by Mochi compiler v0.10.26 on 2025-07-16T17:35:24Z
defmodule Main do
  @spec int(float()) :: integer()
  def int(x) do
    try do
      throw({:return, String.to_integer(x)})
    catch
      {:return, v} -> v
    end
  end

  def main do
    # store_sales :: list(map())
    store_sales = [
      %{customer: 1, sold_date: 2, price: 60},
      %{customer: 2, sold_date: 2, price: 40}
    ]

    # date_dim :: list(map())
    date_dim = [%{d_date_sk: 2, d_month_seq: 5}]
    # customer :: list(map())
    customer = [
      %{c_customer_sk: 1, c_current_addr_sk: 1},
      %{c_customer_sk: 2, c_current_addr_sk: 1}
    ]

    # customer_address :: list(map())
    customer_address = [%{ca_address_sk: 1, ca_county: "X", ca_state: "Y"}]
    # store :: list(map())
    store = [%{s_store_sk: 1, s_county: "X", s_state: "Y"}]
    # revenue :: list(map())
    revenue =
      for ss <- store_sales,
          d <- date_dim,
          c <- customer,
          ca <- customer_address,
          s <- store,
          ss.sold_date == d.d_date_sk && ss.customer == c.c_customer_sk &&
            (c.c_current_addr_sk == ca.ca_address_sk && ca.ca_county == "X" && ca.ca_state == "Y") &&
            (1 == s.s_store_sk && ca.ca_county == s.s_county && ca.ca_state == s.s_state),
          do: %{customer: c.c_customer_sk, amt: ss.price}

    # by_customer :: list(map())
    by_customer =
      Enum.map(_group_by(revenue, fn r -> r.customer end), fn g ->
        %{customer: g.key, revenue: _sum(for x <- g.items, do: x.amt)}
      end)

    # segments :: list(map())
    segments =
      Enum.map(_group_by(by_customer, fn r -> %{seg: int(r.revenue / 50)} end), fn g ->
        %{segment: g.key.seg, num_customers: _count(g), segment_base: g.key.seg * 50}
      end)

    # result :: list(map())
    result = segments
    _json(result)
  end

  defp _count(v) do
    cond do
      is_list(v) -> length(v)
      is_map(v) and Map.has_key?(v, :items) -> length(Map.get(v, :items))
      true -> raise "count() expects list or group"
    end
  end

  defmodule Group do
    defstruct key: nil, items: []

    def fetch(g, k) do
      case k do
        :key -> {:ok, g.key}
        :items -> {:ok, g.items}
        _ -> :error
      end
    end

    def get_and_update(g, k, f) do
      case k do
        :key ->
          {v, nv} = f.(g.key)
          {v, %{g | key: nv}}

        :items ->
          {v, nv} = f.(g.items)
          {v, %{g | items: nv}}

        _ ->
          {nil, g}
      end
    end
  end

  defp _group_by(src, keyfn) do
    {groups, order} =
      Enum.reduce(src, {%{}, []}, fn it, {groups, order} ->
        key =
          if is_list(it) do
            arity = :erlang.fun_info(keyfn, :arity) |> elem(1)
            if arity == 1, do: keyfn.(it), else: apply(keyfn, it)
          else
            keyfn.(it)
          end

        ks = :erlang.phash2(key)

        {groups, order} =
          if Map.has_key?(groups, ks) do
            {groups, order}
          else
            {Map.put(groups, ks, %Group{key: key}), order ++ [ks]}
          end

        val = if is_list(it) and length(it) == 1, do: hd(it), else: it
        groups = Map.update!(groups, ks, fn g -> %{g | items: g.items ++ [val]} end)
        {groups, order}
      end)

    Enum.map(order, fn k -> groups[k] end)
  end

  defp _escape_json(<<>>), do: ""
  defp _escape_json(<<"\\", rest::binary>>), do: "\\\\" <> _escape_json(rest)
  defp _escape_json(<<"\"", rest::binary>>), do: "\\\"" <> _escape_json(rest)
  defp _escape_json(<<c::binary-size(1), rest::binary>>), do: c <> _escape_json(rest)
  defp _to_json(v) when is_binary(v), do: "\"" <> _escape_json(v) <> "\""
  defp _to_json(v) when is_number(v), do: to_string(v)
  defp _to_json(v) when is_boolean(v), do: if(v, do: "true", else: "false")
  defp _to_json(v) when is_list(v), do: "[" <> Enum.map_join(v, ",", &_to_json/1) <> "]"

  defp _to_json(v) when is_map(v) do
    keys = Map.keys(v) |> Enum.map(&to_string/1) |> Enum.sort()

    inner =
      Enum.map_join(keys, ",", fn k ->
        _to_json(k) <> ":" <> _to_json(Map.get(v, String.to_atom(k), Map.get(v, k)))
      end)

    "{" <> inner <> "}"
  end

  defp _to_json(_), do: "null"
  defp _json(v), do: IO.puts(_to_json(v))

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
