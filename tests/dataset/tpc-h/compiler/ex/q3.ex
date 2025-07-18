# Generated by Mochi compiler v0.10.27 on 2025-07-17T18:23:32Z
defmodule Main do
  @cutoff "1995-03-15"
  @segment "BUILDING"
  def main do
    # customer :: list(map())
    customer = [
      %{c_custkey: 1, c_mktsegment: "BUILDING"},
      %{c_custkey: 2, c_mktsegment: "AUTOMOBILE"}
    ]

    # orders :: list(map())
    orders = [
      %{o_orderkey: 100, o_custkey: 1, o_orderdate: "1995-03-14", o_shippriority: 1},
      %{o_orderkey: 200, o_custkey: 2, o_orderdate: "1995-03-10", o_shippriority: 2}
    ]

    # lineitem :: list(map())
    lineitem = [
      %{l_orderkey: 100, l_extendedprice: 1000, l_discount: 0.05, l_shipdate: "1995-03-16"},
      %{l_orderkey: 100, l_extendedprice: 500, l_discount: 0, l_shipdate: "1995-03-20"},
      %{l_orderkey: 200, l_extendedprice: 1000, l_discount: 0.1, l_shipdate: "1995-03-14"}
    ]

    # building_customers :: list(map())
    building_customers = for c <- customer, c.c_mktsegment == @segment, do: c
    # valid_orders :: list(map())
    valid_orders =
      for o <- orders,
          c <- building_customers,
          o.o_custkey == c.c_custkey && o.o_orderdate < @cutoff,
          do: o

    # valid_lineitems :: list(map())
    valid_lineitems = for l <- lineitem, l.l_shipdate > @cutoff, do: l
    # order_line_join :: list(map())
    order_line_join =
      (fn ->
         src = valid_orders

         rows =
           _query(
             src,
             [
               %{items: valid_lineitems, on: fn o, l -> l.l_orderkey == o.o_orderkey end}
             ],
             %{select: fn o, l -> _merge_map(_merge_map(o, l), %{o: o, l: l}) end}
           )

         groups =
           _group_by(rows, fn %{o: o, l: l} ->
             %{
               o_orderkey: o.o_orderkey,
               o_orderdate: o.o_orderdate,
               o_shippriority: o.o_shippriority
             }
           end)

         items = groups

         items =
           Enum.sort_by(items, fn g ->
             [
               -Enum.sum(for r <- g.items, do: r.l.l_extendedprice * (1 - r.l.l_discount)),
               g.key.o_orderdate
             ]
           end)

         Enum.map(items, fn g ->
           %{
             l_orderkey: g.key.o_orderkey,
             revenue: Enum.sum(for r <- g.items, do: r.l.l_extendedprice * (1 - r.l.l_discount)),
             o_orderdate: g.key.o_orderdate,
             o_shippriority: g.key.o_shippriority
           }
         end)
       end).()

    _json(order_line_join)
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

  defp _merge_map(a, b) do
    cond do
      is_map(a) and is_map(b) -> Map.merge(a, b)
      is_map(a) -> a
      is_map(b) -> b
      true -> %{}
    end
  end

  defp _query(src, joins, opts \\ %{}) do
    where = Map.get(opts, :where)
    items = Enum.map(src, fn v -> [v] end)

    items =
      Enum.reduce(joins, items, fn j, items ->
        joined =
          cond do
            Map.get(j, :right) && Map.get(j, :left) ->
              matched = for _ <- j[:items], do: false

              {res, matched} =
                Enum.reduce(items, {[], matched}, fn left, {acc, matched} ->
                  {acc, matched, m} =
                    Enum.reduce(Enum.with_index(j[:items]), {acc, matched, false}, fn {right, ri},
                                                                                      {acc,
                                                                                       matched,
                                                                                       m} ->
                      keep =
                        if Map.has_key?(j, :on) and j[:on],
                          do: apply(j[:on], left ++ [right]),
                          else: true

                      if keep do
                        matched = List.replace_at(matched, ri, true)
                        {acc ++ [left ++ [right]], matched, true}
                      else
                        {acc, matched, m}
                      end
                    end)

                  acc = if !m, do: acc ++ [left ++ [nil]], else: acc
                  {acc, matched}
                end)

              Enum.reduce(Enum.with_index(j[:items]), res, fn {right, ri}, acc ->
                if Enum.at(matched, ri) do
                  acc
                else
                  undef = List.duplicate(nil, if(items == [], do: 0, else: length(hd(items))))
                  acc ++ [undef ++ [right]]
                end
              end)

            Map.get(j, :right) ->
              Enum.reduce(j[:items], [], fn right, acc ->
                {acc2, m} =
                  Enum.reduce(items, {acc, false}, fn left, {acc, m} ->
                    keep =
                      if Map.has_key?(j, :on) and j[:on],
                        do: apply(j[:on], left ++ [right]),
                        else: true

                    if keep, do: {acc ++ [left ++ [right]], true}, else: {acc, m}
                  end)

                if !m do
                  undef = List.duplicate(nil, if(items == [], do: 0, else: length(hd(items))))
                  acc2 ++ [undef ++ [right]]
                else
                  acc2
                end
              end)

            true ->
              Enum.reduce(items, [], fn left, acc ->
                {acc2, m} =
                  Enum.reduce(j[:items], {acc, false}, fn right, {acc, m} ->
                    keep =
                      if Map.has_key?(j, :on) and j[:on],
                        do: apply(j[:on], left ++ [right]),
                        else: true

                    if keep, do: {acc ++ [left ++ [right]], true}, else: {acc, m}
                  end)

                if Map.get(j, :left) && !m do
                  acc2 ++ [left ++ [nil]]
                else
                  acc2
                end
              end)
          end

        joined
      end)

    items = if where, do: Enum.filter(items, fn r -> where.(r) end), else: items

    items =
      if Map.has_key?(opts, :sortKey),
        do: Enum.sort_by(items, fn r -> apply(opts[:sortKey], r) end),
        else: items

    items =
      if Map.has_key?(opts, :skip),
        do:
          (
            n = opts[:skip]
            if n < length(items), do: Enum.drop(items, n), else: []
          ),
        else: items

    items =
      if Map.has_key?(opts, :take),
        do:
          (
            n = opts[:take]
            if n < length(items), do: Enum.take(items, n), else: items
          ),
        else: items

    Enum.map(items, fn r -> apply(opts[:select], r) end)
  end
end

Main.main()
