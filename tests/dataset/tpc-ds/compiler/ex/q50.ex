# Generated by Mochi compiler v0.10.26 on 2025-07-16T17:35:13Z
defmodule Main do
  @year 2001
  @month 8
  def main do
    # store_sales :: list(map())
    store_sales = [
      %{ticket: 1, item: 101, sold: 1, customer: 1, store: 1},
      %{ticket: 2, item: 102, sold: 1, customer: 1, store: 1},
      %{ticket: 3, item: 103, sold: 1, customer: 1, store: 1},
      %{ticket: 4, item: 104, sold: 1, customer: 1, store: 1},
      %{ticket: 5, item: 105, sold: 1, customer: 1, store: 1}
    ]

    # store_returns :: list(map())
    store_returns = [
      %{ticket: 1, item: 101, returned: 16, customer: 1},
      %{ticket: 2, item: 102, returned: 46, customer: 1},
      %{ticket: 3, item: 103, returned: 76, customer: 1},
      %{ticket: 4, item: 104, returned: 111, customer: 1},
      %{ticket: 5, item: 105, returned: 151, customer: 1}
    ]

    # date_dim :: list(map())
    date_dim = [
      %{d_date_sk: 1, d_year: 2001, d_moy: 7},
      %{d_date_sk: 16, d_year: 2001, d_moy: 8},
      %{d_date_sk: 46, d_year: 2001, d_moy: 8},
      %{d_date_sk: 76, d_year: 2001, d_moy: 8},
      %{d_date_sk: 111, d_year: 2001, d_moy: 8},
      %{d_date_sk: 151, d_year: 2001, d_moy: 8}
    ]

    # store :: list(map())
    store = [
      %{
        s_store_sk: 1,
        s_store_name: "Main",
        s_company_id: 1,
        s_street_number: "1",
        s_street_name: "Main",
        s_street_type: "St",
        s_suite_number: "100",
        s_city: "City",
        s_county: "County",
        s_state: "CA",
        s_zip: "12345"
      }
    ]

    # joined :: list(map())
    joined =
      for ss <- store_sales,
          sr <- store_returns,
          d1 <- date_dim,
          d2 <- date_dim,
          s <- store,
          ss.ticket == sr.ticket && ss.item == sr.item && ss.customer == sr.customer &&
            ss.sold == d1.d_date_sk &&
            (sr.returned == d2.d_date_sk && d2.d_year == @year && d2.d_moy == @month) &&
            ss.store == s.s_store_sk,
          do: %{s: s, diff: sr.returned - ss.sold}

    # result :: list(map())
    result =
      Enum.map(_group_by(joined, fn j -> j.s end), fn g ->
        %{
          s_store_name: g.key.s_store_name,
          d30: _count(for x <- g.items, x.diff <= 30, do: 1),
          d31_60: _count(for x <- g.items, x.diff > 30 && x.diff <= 60, do: 1),
          d61_90: _count(for x <- g.items, x.diff > 60 && x.diff <= 90, do: 1),
          d91_120: _count(for x <- g.items, x.diff > 90 && x.diff <= 120, do: 1),
          d_gt_120: _count(for x <- g.items, x.diff > 120, do: 1)
        }
      end)

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
end

Main.main()
